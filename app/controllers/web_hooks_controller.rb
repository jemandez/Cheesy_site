require 'openssl'
require 'dropbox_sync'

class WebHooksController < ApplicationController
  skip_before_action :verify_authenticity_token


  def index
    render text: params[:challenge]
  end

  def modifications
    signature = request.headers['X-Dropbox-Signature']
    key = ::DROPBOX_SECRET

    digest = OpenSSL::Digest.new('sha256')
    validate_signature = OpenSSL::HMAC.hexdigest(digest, key, request.raw_post)

    if validate_signature == signature
      logger.info "list folder #{params[:list_folder]["accounts"]}"

      DropboxSync.match_schools ::DBX

    end

    head :ok, content_type: "text/html"
  end
end
