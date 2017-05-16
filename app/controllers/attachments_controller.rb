class AttachmentsController < ApplicationController
	load_and_authorize_resource
	skip_before_action :verify_authenticity_token

	def destroy
		attachment=Attachment.find(params[:id])
		attachment.destroy
		render :json=>"OK"
	end

	def create
	  storage = Google::Cloud::Storage.new :project => 'master-tuner-150318', :keyfile => 'google.json'
	  @location=Location.find(params[:location])
	  name = @location.id.to_s+"/"+SecureRandom.hex+File.extname(params[:file].original_filename)
	  bucket = storage.bucket("atlocs")
	  policy = {
	      :conditions => [
	         {acl: "public-read"}
	      ]
	  }
	  obj = bucket.create_file params[:file].path, name
		obj.acl.publicRead!
		obj.refresh!
		attachment=Attachment.new
		attachment.url=obj.public_url
		attachment.location_id=@location.id
		attachment.save
		render :json=>{:files=>{:name=>params[:file].original_filename,:url=>obj.public_url,:deleteUrl=>attachment.id.to_s}}
	end
end
