# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'faker'

flickr_rss = Urss.at("http://www.flickr.com/services/feeds/photos_public.gne?format=rss_200")


i=0;
tagnames=[]
10.times do
	tagnames.push(Faker::Lorem.word)
end
10.times do
	collection=Collection.new
	collection.name=Faker::Lorem.sentence
	collection.save
end
32.times do
	password=Faker::Internet.password
	User.create(
		first_name: Faker::Name.first_name,
		last_name: Faker::Name.last_name,
		password: password,
		avatar_url: Faker::Avatar.image,
		password_confirmation: password,
		email: Faker::Internet.email
	)
end
10.times do
	location=Location.new
	location.lat=Faker::Address.latitude
	location.lng=Faker::Address.longitude
	location.street_address=Faker::Address.street_address
	location.city=Faker::Address.city
	location.title=Faker::Lorem.sentence
	location.description=Faker::Lorem.paragraph
	location.price=rand(10000..250000)
	location.collection_id=Collection.all.sample.id
	location.user_id=User.order("RANDOM()").first.id
	location.fee = 100
	puts location.user_id
	puts User.order("RANDOM()").first.id
	location.save
	puts "submitting location #{location.id}: #{location.submit}"
	rand(0..10).times do
		location.addtag(tagnames.sample)
	end

	rand(8..16).times do
		# adds random images from the interwebs

		attachment=Attachment.new
		attachment.location_id=location.id
		attachment.url=flickr_rss.entries.sample.medias.first.content_url
		attachment.save
		puts "saving attachment #{attachment.id}"
	end


end

# creates admin user
admin=User.new
password="macoy123"
admin.password=password
admin.password_confirmation=password
admin.email="hello@mego.cl"
admin.first_name=Faker::Name.first_name
admin.last_name=Faker::Name.last_name
admin.avatar_url=Faker::Avatar.image
#admin.owning=true
#admin.tenant=true
admin.status = 'admin'
admin.save
admin.update_attribute(:status,"admin")
# approves 16 locations
Location.where(:status=>2).limit(16).each do |location|
	puts "aprobando locacion #{location.id}"
	location.approve
	# Collection.all.sample.add(location)
end
# 8 locations get booking requests for 10 new users each
Location.where(:status=>3).limit(8).each do |location|
	4.times do
		# create new user for booking
		user=User.new
		password=Faker::Internet.password
		user.first_name=Faker::Name.first_name
		user.last_name=Faker::Name.last_name
		user.avatar_url=Faker::Avatar.image
		user.password=password
		user.password_confirmation=password
		user.email=Faker::Internet.email
		user.save
		# try random bookings for the next 10 days
		10.times do
			from=rand(0..10).days.from_now
			to=from+rand(0..8).hours
			user.book(location,from,to)
		end
	end
end
# 5 bookings get accepted, rest gets ignored
i=0
Booking.order("RANDOM ()").each do |booking|
	if(i<5)
		booking.accept
	else
		booking.archive
	end
	i=i+1
end
