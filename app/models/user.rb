class User < ActiveRecord::Base
  has_many :locations, dependent: :destroy
  has_many :bookings, dependent: :destroy
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, uniqueness: true
  validates :password, :presence => true, :length => {:within => 6..40}, :if => :password
  devise :confirmable, :omniauthable

  #validate :atleast_one_is_checked

  #validate_uniqueness_of :email
  enum status: [ :banned, :shadowbanned, :unverified, :verified, :moderator, :admin ]

  has_secure_password
  before_create :add_unverified_status
  before_save :set_tenant, unless: :owning || :tenant
  acts_as_paranoid

  def full_name
    if self.first_name && self.last_name
      self.first_name+" "+self.last_name
    elsif self.first_name
      self.first_name
    else
      self.email
    end
  end

  def claim(location)
    if(location.user_id==nil && self.id!=nil)
      location.update_attribute(:user_id,self.id)
      true
    else
      false
    end
  end

  def notifications(tag)
    if REDIS.get(tag+"_notifications_"+self.id.to_s)
      REDIS.get(tag+"_notifications_"+self.id.to_s).to_i
    else
      REDIS.set(tag+"_notifications_"+self.id.to_s,"0")
      0
    end
  end

  def notify(tag)
    if REDIS.get(tag+"_notifications_"+self.id.to_s)

      REDIS.set(tag+"_notifications_"+self.id.to_s,(REDIS.get(tag+"_notifications_"+self.id.to_s).to_i+1).to_s)
    else
      REDIS.set(tag+"_notifications_"+self.id.to_s,"1")
    end
  end

  def book(location,start_time,end_time)
    if(location.status=="approved" && start_time<end_time)
      booking=location.bookings.where("status>2").where("start_time<?",end_time).where("end_time<?",start_time).first
      if(booking)
        nil
      else
        booking=Booking.new
        booking.start_time=start_time
        booking.end_time=end_time
        booking.location_id=location.id
        booking.user_id=self.id

        booking.status="waiting"
        if booking.save
          REDIS.lpush("booking#{booking.code}",{:datetime=>Time.now.to_i,:text=>"Reserva creada",:action=>"created"}.to_json)
          booking.updateprice
          booking.save

          booking
        else
          nil
        end
      end
    else
      nil
    end
  end

  def atleast_one_is_checked
    errors.add(:base, "Selecciona al menos uno") unless owning || tenant
  end

  def self.confirm_token
		loop do
	  	token = SecureRandom.urlsafe_base64
	     break token unless User.exists?(confirmation_token: token)
		end
	end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user.present?
      return user
    else
      registered_user = User.where(email: auth.info.email)
      deleted_user = User.with_deleted.find_by(email: auth.info.email) unless registered_user.present?
      if registered_user.present?
        registered_user.provider = auth.provider
        registered_user.uid = auth.uid
        registered_user.save!
        return registered_user
      elsif deleted_user.present?
        deleted_user.recover
        deleted_user.provider = auth.provider
        deleted_user.uid = auth.uid
        deleted_user.save!
        return deleted_user
      else
        User.create do |user|
          user.email = auth.info.email
          user.password = Devise.friendly_token[0,20]
          user.name = auth.info.name
          user.provider = auth.provider
          user.uid = auth.uid
          user.status = 'verified'
          user.skip_confirmation!
        end
      end
    end
  end

  def set_tenant
    self.tenant = true
  end

  private
    def add_unverified_status
      self.status="unverified"
    end
end
