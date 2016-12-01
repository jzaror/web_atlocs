puts "OHAI"
require 'rails_helper'
require 'faker'

RSpec.describe Location, :type => :model do
	admin=nil
	it "creates locations and users" do
		i=0;
		tagnames=[]
		10.times do
			tagnames.push(Faker::Lorem.word)
		end
		while i<100
			location=Location.new
			location.save
			location.lat=Faker::Address.latitude
			location.lng=Faker::Address.longitude
			location.street_address=Faker::Address.street_address
			location.city=Faker::Address.city
			location.title=Faker::Lorem.sentence
			location.description=Faker::Lorem.paragraph
			location.price=rand(10000..250000)
			location.save
			expect(location.status).to eq("draft")
			rand(0..10).times do
				location.addtag(tagnames.sample)
			end
			# 80% of users create accounts and submit their location
			if(i<80)
				user=User.new
				password=Faker::Internet.password
				user.first_name=Faker::Name.first_name
				user.last_name=Faker::Name.last_name
				user.password=password
				user.password_confirmation=password
				user.email=Faker::Internet.email
				user.save
				expect(user.status).to eq("unverified")
				# user claims location
				expect(user.claim(location)).to be(true)
				expect(location.submit).to be(true)
			end
			i=i+1
		end
		expect(Location.all.count).to be(100)
		expect(User.all.count).to be(80)
		# creates admin user
		admin=User.new
		password=Faker::Internet.password
		admin.password=password
		admin.password_confirmation=password
		admin.email=Faker::Internet.email
		admin.first_name=Faker::Name.first_name
		admin.last_name=Faker::Name.last_name
		admin.save
		admin.update_attribute(:status,"admin")
		# approves 50 locations
		Location.where(:status=>2).limit(50).each do |location|
			location.approve
		end
		# 25 locations get booking requests for 10 new users each
		Location.where(:status=>3).limit(25).each do |location|
			20.times do
				# create new user for booking
				user=User.new
				password=Faker::Internet.password
				user.first_name=Faker::Name.first_name
				user.last_name=Faker::Name.last_name
				user.password=password
				user.password_confirmation=password
				user.email=Faker::Internet.email
				user.save
				# try random bookings for the next 10 days
				20.times do
					from=rand(0..10).days.from_now
					to=from+rand(0..8).hours
					user.book(location,from,to)
				end
			end
		end
		# 50 bookings get accepted, rest gets ignored
		i=0
		Booking.order("RANDOM ()").each do |booking|
			if(i<50)
				booking.accept
			else
				booking.archive
			end
			i=i+1
		end
		expect(Booking.where(:status=>2).count).to be(50)
		# 
	end




end