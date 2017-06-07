class Booking < ActiveRecord::Base
	enum status: [:archived,:waiting,:accepted,:paid]
	belongs_to :location
	belongs_to :user
	before_create :generatecode
	acts_as_paranoid

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
		days=(self.end_time.to_date-self.start_time.to_date).to_i
		price=self.location.price*days
		self.price=price
	end
	def accept
		if(self.status=="waiting")
			self.update_attribute(:status,"accepted")
			true
		else
			false
		end
	end
	def archive
		if self.status=="waiting" || self.status == 'accepted'
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
		if(self.status=="accepted")
			self.update_attribute(:status,3)
			true
		else
			false
		end
	end
end
