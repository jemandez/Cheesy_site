require 'dropbox_sync'

namespace :cheesy do
  desc "Match db state with dropbox state"
  task seed_db: :environment do
    DropboxSync.match_schools ::DBX
  end

  desc "Update students photos links"
  task update_photos: :environment do
     Student.all.each do |student|
       begin
         DropboxSync.update_photo(student, Dropbox::FileMetadata)
       rescue
         student.destroy
       end


        student.save if not student.nil? and student.url_changed?
     end
  end
end
