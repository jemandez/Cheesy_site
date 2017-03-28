require 'openssl'

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

     if Admin.first.cursor
        match_dropbox ::DBX, Admin.first
     else
        match_dropbox ::DBX, :all
     end

    end

    head :ok, content_type: "text/html"
  end

  protected
  def update_with_cursor(dbx, cursor, entity, allowed_type=Dropbox::FolderMetadata)
    changes = dbx.continue_list_folder(entity.cursor)
    delete = changes.select  { |item|  item.class == Dropbox::DeletedMetadata }
    update_or_create = changes.select  { |item|  item.class != Dropbox::DeletedMetadata }
  end

  def update_all(dbx, path, entity, allowed_type=Dropbox::FolderMetadata)
      files = dbx.list_folder(path)
      delete_before = Time.current

      files.each do |meta|
        record = entity.find_by did: meta.id
        record ||= entity.new

        if meta.class == type
	  record.title = meta.name
          record.did = meta.id
          record.dpath = meta.path_display
          new_instance.save
	end
      end

      entity.where("updated_at < ?", delete_before).destroy_all
  end


  def match_root(dbx)
         
  end

  def match_events(dbx, entity)
  end

  def match_schools(dbx, entity)
    
  end

  def match_generations(db, entity)
  end

  def match_group(db, entity)
  end
end
