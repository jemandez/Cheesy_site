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

      match_schools ::DBX

    end

    head :ok, content_type: "text/html"
  end

  protected

  def update_with_cursor(dbx, cursor, entity, allowed_type=Dropbox::FolderMetadata, **kwargs)
    changes = dbx.continue_list_folder(entity.cursor)
    delete = changes.select  { |item|  item.class == Dropbox::DeletedMetadata }
    update_or_create = changes.select  { |item|  item.class != Dropbox::DeletedMetadata }

    delete.each do |item|
      record = entity.find_by dpath: item.path_display
      if record
        exists = update_or_create.select { |item| item.id == record.did }
        record.destroy unless exists
      end
    end

    update_or_create.each do |item|
      record.attributes = kwargs
      record = entity.find_by did: item.id
      record ||= entity.new

      record.name = item.name
      record.did = item.id
      record.dpath = item.path_display

      record.save
    end if item.class == allowed_type
  end

  def update_all(dbx, path, entity, allowed_type=Dropbox::FolderMetadata, **kwargs)
      files = dbx.list_folder(path)
      delete_before = Time.current

      files.each do |meta|
        record = entity.find_by did: meta.id
        record ||= entity.new

        if meta.class == type
          record.attributes = kwargs
	  record.title = meta.name
          record.did = meta.id
          record.dpath = meta.path_display
          new_instance.save
	end
      end

      entity.where("updated_at < ?", delete_before).destroy_all
  end


  def match_schools(dbx)
      update_all(dbx, "/Escuelas", School)
      School.all.each do |school|
        match_generation(dbx, school, Generation)
      end
  end

  def match_generations(db, item, entity)
    if item.cursor
       update_with_cursor(dbx, item.cursor, entity, school: item)
    else:
       update_all(dbx, item.dpath, entity, school: item)
    end

    entity.all.each do |group|
       match_group(dbx, group, Group)
    end
  end

  def match_group(db, item, entity)
    if item.cursor
       update_with_cursor(dbx, item.cursor, entity, Dropbox::FileMetadata, group: item)
    else:
       update_all(dbx, item.dpath, entity, Dropbox::FileMetadata, group: item)
    end
  end
end
