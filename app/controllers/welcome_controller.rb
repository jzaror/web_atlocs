class WelcomeController < ApplicationController

	def index
		@tags=Tag.joins(:locations).where("locations.status = ?",3).order("RANDOM()").limit(4)
		@collections=Collection.order(updated_at: :desc).limit(9)
		@locations=Location.where(:status=>3).order(created_at: :desc).limit(6)
		#@locations=Location.where(:status=>3).order("RANDOM()").limit(6)
	end

	def about
	end
end
