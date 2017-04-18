class User < ActiveRecord::Base
  has_many :locations, dependent: :destroy
  has_many :bookings
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, uniqueness: true
  validates :password, :presence => true, :length => {:within => 6..40}, :if => :password
  #validate_uniqueness_of :email
  enum status: [ :banned, :shadowbanned, :unverified, :verified, :moderator, :admin ]

  has_secure_password
  before_create :add_unverified_status
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
      puts self.full_name+" claimed location #"+location.id.to_s
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
    puts "creating booking..."
    if(location.status=="approved" && start_time<end_time)
      booking=location.bookings.where("status>2").where("start_time<?",end_time).where("end_time<?",start_time).first
      if(booking)
        nil
        puts "conflicts with previous booking"
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
          puts booking.inspect

          puts booking.user.full_name+" created booking #"+booking.code
          booking
        else
          puts "error saving booking"
          nil
        end
      end
    else
      puts "location not approved or invalid"
      nil
    end
  end
  private
    def add_unverified_status
      self.status="unverified"
    end
end