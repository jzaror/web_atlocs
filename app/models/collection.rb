class Collection < ActiveRecord::Base
	has_many :locations
	acts_as_paranoid
  has_attached_file :image, styles: { medium: "655x450#", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  	def thumbnail(w,h)
  		if self.locations
  			"/missing.png"
  		else 
  			self.locations.sample.attachments.sample.thumbnail(w,h)
  		end
  	end
end
