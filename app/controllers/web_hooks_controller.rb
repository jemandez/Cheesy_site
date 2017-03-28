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
    changes = dbx.continue_list_folder(cursor)
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
        record = entity.find_by did: item.id
        record ||= entity.new

      if item.class == allowed_type
        record.attributes = kwargs
        record.title = item.name
        record.did = item.id
        record.dpath = item.path_display

        record.save
      end
    end 
  end

  def update_all(dbx, path, entity, allowed_type=Dropbox::FolderMetadata, **kwargs)
      files = dbx.list_folder(path)
      delete_before = Time.current
      white_list = []

      files.each do |meta|
        record = entity.find_by did: meta.id
        white_list.push(meta.id)
        record ||= entity.new

        if meta.class == allowed_type
          record.attributes = kwargs
	  record.title = meta.name
          record.did = meta.id
          record.dpath = meta.path_display
          record.save
          logger.info "validations #{record.errors.messages}" if record.valid?
	end
      end
      #entity.where("updated_at < ?", delete_before).each do |e|
      #  e.destroy unless white_list.index(e.did)
      #end
  end


  def match_schools(dbx)
      update_all(dbx, "/Escuelas", School)
      School.all.each do |school|
        match_generations(dbx, school, Generation)
      end
  end

  def match_generations(dbx, item, entity)
    if item.cursor
       update_with_cursor(dbx, item.cursor, entity, school: item)
    else
       update_all(dbx, item.dpath, entity, school: item)
    end

    entity.all.each do |generation|
       begin
       match_group(dbx, generation, Group)
       rescue Dropbox::ApiError
       generation.destroy
       end
    end

#    new_cursor = dbx.get_latest_list_folder_cursor(item.dpath)
#    item.cursor = new_cursor  if new_cursor != item.cursor
 
#    item.save
  end

  def match_group(dbx, item, entity)
    if item.cursor
       update_with_cursor(dbx, item.cursor, entity, generation: item)
    else
       update_all(dbx, item.dpath, entity, generation: item)
    end

    entity.all.each do |group|
       begin
       match_student(dbx, group, Student)
       rescue Dropbox::ApiError
       group.destroy
       end
    end

#    new_cursor = dbx.get_latest_list_folder_cursor(item.dpath)
#    item.cursor = new_cursor if new_cursor != item.cursor

#    item.save
  end

  def match_student(dbx, item, entity)
    if item.cursor
       update_with_cursor(dbx, item.cursor, entity, Dropbox::FileMetadata, group: item)
    else
       update_all(dbx, item.dpath, entity, Dropbox::FileMetadata, group: item)
    end

#    new_cursor = dbx.get_latest_list_folder_cursor(item.dpath)
#    item.cursor = new_cursor if new_cursor != item.cursor
#    item.save
  end
end
