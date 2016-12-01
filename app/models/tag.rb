class Tag < ActiveRecord::Base
	has_many :taggings, dependent: :destroy
	has_many :locations, through: :taggings

	def taggings_count
		self.locations.count
	end
end
