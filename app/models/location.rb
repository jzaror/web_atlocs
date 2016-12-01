class Location < ActiveRecord::Base
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
	
	#IMAGES 
	has_attached_file :image, styles: {
		thumb: '100x100>',
		square: '200x200#',
		medium: '300x300>',
		large: '1280x400#'
	}


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
		puts upload
		if upload
		  upload.update_columns(location_id: self.id)
		  upload.save
		  puts "foto asociada a: "+upload.location_id.to_s
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
			puts "location #"+self.id.to_s+" approved"
			true
		else
			false
		end
	end
	def archive
		self.update_attribute(:status,"archived")
		puts "location #"+self.id.to_s+" archived"
		true
	end
	def submit
		if self.user && self.status=="draft"
			self.update_attribute(:status,"submitted")
			puts self.user.full_name+" submitted location #"+self.id.to_s
			true
		else
			false
		end
	end
	def thumbnail(w,h)
		if self.attachments.count>0 && self.attachments[0].url
			self.attachments[0].thumbnail(w,h)
		else
			"/location-missing.jpg"
		end
	end
	def totalprice
		if !self.fee.nil?
			self.price+self.fee
		else
			self.price
		end
	end
	def price_with_fee
		if self.price
			self.price+(self.price*0.15)
		else
			0
		end
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
					puts "Adding tag: #{name}"
					self.addtag(name)
					#Tag.find_or_create_by(name: name) if name.present?
				end
			end
		end
end
