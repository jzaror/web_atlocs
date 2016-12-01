class AttachmentsController < ApplicationController
	load_and_authorize_resource
	skip_before_action :verify_authenticity_token
	def destroy
		attachment=Attachment.find(params[:id])
		
		attachment.destroy
		render :json=>"OK"
	end
	def create
		@location=Location.find(params[:location])
		s3 = Aws::S3::Resource.new(
		  region: ENV['AWS_REGION']
		)
		# Make an object in your bucket for your upload
	    obj = s3.bucket(ENV['AWS_S3_BUCKET']).object(@location.id.to_s+"/"+SecureRandom.hex+File.extname(params[:file].original_filename))

	    # Upload the file
	    obj.upload_file params[:file].path, {acl: 'public-read'}

	    puts "Created an object in S3 at:"
		puts obj.public_url
		puts "\nUse this URL to download the file:"
		puts obj.presigned_url(:get)
		attachment=Attachment.new
		attachment.url=obj.public_url
		attachment.location_id=@location.id
		puts attachment.inspect
		attachment.save
		puts attachment.inspect
		puts @location.inspect
		render :json=>{:files=>{:name=>params[:file].original_filename,:url=>obj.public_url,:deleteUrl=>attachment.id.to_s}}
		
	end
end
