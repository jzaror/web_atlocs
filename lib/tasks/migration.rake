task :migratebucket => :environment do
  Attachment.all.each do |a|
    puts a.url
    a.update_attribute(:url,a.url.gsub("atlocs.s3.amazonaws.com","atlocs-us.s3.amazonaws.com"))
    a.update_attribute(:url,a.url.gsub("atlocs.s3-sa-east-1.amazonaws.com","atlocs-us.s3.amazonaws.com"))

    puts a.url

  end
end