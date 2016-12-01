class CollectionMembership < ActiveRecord::Base
	validates :collection_id, uniqueness: { scope: :location_id }
end
