class Upload < ActiveRecord::Base
	belongs_to :location, :polymorphic => true
	has_attached_file :image, styles: {
		thumb: '350x230#',
		square: '200x200#',
		medium: '300x300>',
		large: '1280x400#',
	}
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

	def thumbnail(w,h)
		if self.url
     	return self.url
		else
			"/location-missing.jpg"
		end
	end

end