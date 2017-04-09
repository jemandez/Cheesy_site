require 'dropbox'

if ENV['DROPBOX_TOKEN']
  ::DROPBOX_SECRET = ENV['DROPBOX_TOKEN']
  ::DBX = Dropbox::Client.new(ENV['DROPBOX_ACCESS_TOKEN'])
end
