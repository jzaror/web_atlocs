class Attachment < ActiveRecord::Base
	belongs_to :location
	acts_as_paranoid
	def filename
		require 'uri'
		uri = URI.parse(self.url)
		return File.basename(uri.path)
	end

	def is_main_attachment
		location != nil && ( (self.id == location.main_attachment_id) || (location.main_attachment_id == nil && self == location.attachments[0]))
	end

	def thumbnail(w,h)
		if self.url
     	return self.url
		  crypto = Thumbor::CryptoURL.new '1234567890qwerty'
		  thumb = crypto.generate :width => w, :height => h, :image => URI::encode(self.url.gsub("https://","")), :smart => true
		  # return "http://dx466tb009xgb.cloudfront.net"+thumb
		  return "http://s.bigcho.co"+thumb
		else
			"/location-missing.jpg"
		end
	end
end
