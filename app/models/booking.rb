class Booking < ActiveRecord::Base
	enum status: [:archived,:waiting,:accepted,:paid]
	belongs_to :location
	belongs_to :user
	before_create :generatecode

	def generatecode
		self.code=SecureRandom.hex[0..8] if self.code==nil
		self.save if self.id!=nil
		return self.code
	end

	def statusnames
		["Cancelada","Pendiente","Esperando Pago","Confirmada"]
	end
	def statusname
		return statusnames[self.read_attribute('status')]
	end
	def updateprice
		puts "updating price..."
		puts self.start_time
		puts self.end_time
		days=(self.end_time.to_date-self.start_time.to_date).to_i
		puts "days: "+days.to_s
		puts self.location.price.to_s
		puts self.location.price*days
		price=self.location.price*days
		puts "price: "+price.to_s
		self.price=price
	end
	def accept
		if(self.status=="waiting")
			puts self.location.user.full_name+" accepts booking request #"+self.id.to_s+" ($"+self.price.to_s+")"
			self.update_attribute(:status,"accepted")
			true
		else
			false
		end
	end
	def archive
		if(self.status=="waiting")
			self.update_attribute(:status,"archived")
			true
		else
			false
		end
	end
	def totaldays
		days=(self.end_time.to_date-self.start_time.to_date).to_i
		if days>0
			return days
		else
			return 1
		end
	end
	def confirm_payment
		puts "confirming payment for #"+self.id.to_s
		if(self.status=="accepted")
			self.update_attribute(:status,3)
			true
		else
			false
		end
	end
end