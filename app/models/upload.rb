class Upload < ActiveRecord::Base
	belongs_to :location, :polymorphic => true
	has_attached_file :image, styles: {
		thumb: '350x230#',
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

	def image_remote_url(url_value)
    self.image = URI.parse(url_value)
    # Assuming url_value is http://example.com/photos/face.png
    # avatar_file_name == "face.png"
    # avatar_content_type == "image/png"
    @avatar_remote_url = url_value
  end

  def is_main_attachment
  	location = Location.find_by_id(location_id)
  	return false if location.nil?
  	location.main_attachment == self
	end

end