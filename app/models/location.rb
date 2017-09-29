class Location < ActiveRecord::Base
	require 'money'
	require 'money/bank/google_currency'
	Money.default_bank = Money::Bank::GoogleCurrency.new
	belongs_to :user
	belongs_to :collection

	has_many :bookings, dependent: :destroy
	has_many :taggings, dependent: :destroy
	has_many :tags, through: :taggings
	has_many :attachments, dependent: :destroy
	has_many :uploads, dependent: :destroy

	accepts_nested_attributes_for :uploads, allow_destroy: true

	enum status: [ :archived, :draft, :submitted, :approved ]

	#SEARCH
	include PgSearch
  	multisearchable :against => [:title, :description, :city, :county, :services, :extras]
  	pg_search_scope :custom_search, :against => [:title, :description, :city, :county, :services, :extras], :associated_against => {:tags => [:name]}, :using => { :tsearch => {:prefix => true} }

	acts_as_paranoid

	#AFTER
	before_create :set_draft_status
	attr_accessor :tag_names
	after_save :assign_tags

	def statusnames
		["Archivada","Borrador","Esperando Aprobación","Publicada"]
	end

	def labels
		["label-danger","label-default","label-info","label-success"]
	end

	def statuslabel
		return labels[self.read_attribute('status')]
	end

	def statusname
		return statusnames[self.read_attribute('status')]
	end

	def savephoto(upload_id)
		upload=Upload.find(upload_id)
		if upload
		  upload.update_columns(location_id: self.id)
		  upload.save
		  true
		else
		  false
		end
	end

	def tag_names
    @tag_names || tags.map(&:name).join(', ')
    #@tag_names || tags.map{ |tag|  link_to tag.name, '/location' }
	end

	def addtag(word)
		name=word.gsub(/[^0-9a-z ]/i, '').downcase
		tag=Tag.where(:name=>name).first_or_create
		tagging=Tagging.where(:tag_id=>tag.id,:location_id=>self.id).first_or_create
	end

	def approve
		if (self.status=="submitted"||self.status=="archived")
			self.update_attribute(:status,"approved")
			true
		else
			false
		end
	end

	def archive
		self.update_attribute(:status,"archived")
		true
	end

	def submit
		if self.user && self.status=="draft"
			self.update_attribute(:status,"submitted")
			true
		else
			false
		end
	end

	def thumbnail(w,h)
		upload = self.main_attachment
		if upload != nil
			upload.image.url(:thumb)
		else
			"/location-missing.jpg"
		end
	end

	def thumbnail_old(w,h)
		attachment = self.main_attachment
		if attachment != nil
			attachment.thumbnail(w,h)
		else
			"/location-missing.jpg"
		end
	end

	def main_attachment
		if self.main_attachment_id && Upload.find_by_id(self.main_attachment_id) != nil
			Upload.find_by_id(self.main_attachment_id)
		elsif self.uploads.count > 0
			self.uploads.last
		else
			nil
		end
	end

	def main_attachment_url(style= nil)
		return "/location-missing.jpg" unless main_attachment
		return main_attachment.image.url unless style
		begin
			return main_attachment.image.url(style.to_sym)
		rescue
			return "/location-missing.jpg"
		end
	end

	def user_full_name
		if self.user
			user.try(:full_name)
		else
			nil
		end
	end

	def totalprice
		if !self.fee.nil? && !self.price.nil?
			self.price+self.fee
		else
			self.price
		end
	end

	def price_with_fee
		currency_type = I18n.locale == :es ? :CLP : :USD
		return 0 unless self.price
		price_result = self.price+(self.price*0.15)
		money = price_result.to_money(:CLP)
		converted_money = money.exchange_to(currency_type.to_sym)
		return converted_money
	end

	def has_other_extras?
		extras.select{|e| e == "Otro"}.length > 0
	end

	def has_other_services?
		services.select{|e| e == "Otro"}.length > 0
	end

	def has_date_range_available?(start_time, end_time)
		# Locaciones que aún esten siendo utilizadas cuando comienza la reserva
		self.bookings.where("status>2").where("start_time <= ? AND end_time >=?", end_time, start_time).blank?
	end

	def convert_attachments_to_uploads
		self.attachments.each do |att|
			begin
				self.uploads.create(image: open(att.url))
			rescue => e
				puts "#{att.url} failed"
			end
		end
	end

	def is_new_record?
		status == "draft"
	end

	private
		def set_draft_status
			# status codes:
			# 0=archived,1=draft,2=submitted,3=approved
			self.status="draft"
		end
		def assign_tags
			#@tag_names.split("/\s*,\s*/").map do |name|
			if @tag_names
				self.tags=[]
				@tag_names.split(/, ?/).each do |name|
					self.addtag(name)
					#Tag.find_or_create_by(name: name) if name.present?
				end
			end
		end
end
