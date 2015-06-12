require 'google/api_client'
require 'google_drive'

# Creates a session.
target = ARGV.shift
access_token = ARGV.shift
session = GoogleDrive.login_with_oauth(access_token)

# Gets list of remote files.
# session.files.each do |file|
#   p file.title
# end
#

def searchAndDeleteCR2(target, pathArray)
  counts = 0
  target.contents do |item|
    counts += 1
    if item.class == GoogleDrive::Collection
      searchAndDeleteCR2(item, [pathArray, item.title]) 
    elsif /cr2$/i === item.title
      puts "Delete: " + [pathArray, item.title].join('/')
      item.delete true
    end
  end
  puts "Target: #{pathArray.join('/')} (Count #{counts})"
end


root = session.collection_by_title(target)

p root.title
searchAndDeleteCR2(root, [])

