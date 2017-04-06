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

  def update_photo(item, type, force=false)
     return if type != Dropbox::FileMetadata
     if item.photo_timestamp.nil? or (item.photo_timestamp + 3.hours) > Time.current or force
         item.url = ::DBX.get_temporary_link(item.dpath)[1]
         item.photo_timestamp = Time.current
     end
  end


  def update_with_cursor(dbx, cursor, entity, allowed_type=Dropbox::FolderMetadata, **kwargs)
    changes = dbx.continue_list_folder(cursor)
    delete = changes.select  { |item|  item.class == Dropbox::DeletedMetadata }
    update_or_create = changes.select  { |item|  item.class != Dropbox::DeletedMetadata }

    delete.each do |item|
      record = entity.find_by dpath: item.path_display
      if record
        exists = update_or_create.select { |item| item.id == record.did }
        record.destroy if not exists or exists == []
      end
    end

    update_or_create.each do |item|
        record = entity.find_by did: item.id
        record ||= entity.new

      if item.class == allowed_type
	  record.title = item.name if item.name != record.title
          record.did = item.id if item.id != record.did
          record.dpath = item.path_display if item.path_display != record.dpath

          if record.changed?
            record.attributes = kwargs
            update_photo(record, allowed_type, force: true)
            record.save
          end
      end
    end 
  end

  def update_all(dbx, path, elements, entity, allowed_type=Dropbox::FolderMetadata, **kwargs)
      files = dbx.list_folder(path)
      delete_before = Time.current
      white_list = []

      files.each do |meta|
        record = elements.find_by did: meta.id
        white_list.push(meta.id)
        record ||= entity.new

        if meta.class == allowed_type
	  record.title = meta.name if meta.name != record.title
          record.did = meta.id if meta.id != record.did
          record.dpath = meta.path_display if meta.path_display != record.dpath
          if record.changed?
            update_photo(record, allowed_type, force: true)
            record.attributes = kwargs
            record.save
          end
          logger.info "validations #{record.errors.messages}" if record.valid?
	end
      end
      elements.where("did NOT IN (?)", white_list).destroy_all
  end


  def match_schools(dbx)
      update_all(dbx, "/Escuelas", School.all, School)
      School.all.each do |school|
	begin
          match_generations(dbx, school, Generation)
        rescue Dropbox::ApiError
          school.destroy
        end
      end
  end

  def match_generations(dbx, item, entity)
    changes = []
    if item.cursor
       update_with_cursor(dbx, item.cursor, entity, school: item)
       changes = dbx.continue_list_folder(item.cursor)
    else
       update_all(dbx, item.dpath, item.generations, entity, school: item)
    end

    item.generations.each do |generation|
       begin
       match_group(dbx, generation, Group)
       rescue Dropbox::ApiError
         generation.destroy
       end
    end


    if changes != []
      new_cursor = dbx.get_latest_list_folder_cursor(item.dpath)
      item.cursor = new_cursor
      item.save if item.changed? and item.persisted?
    end

  end

  def match_group(dbx, item, entity)
    changes = []
    if item.cursor
       update_with_cursor(dbx, 	item.cursor, entity, generation: item)
       changes = dbx.continue_list_folder(item.cursor)
    else
       update_all(dbx, item.dpath, item.groups, entity, generation: item)
    end

    item.groups.each do |group|
       begin
         match_student(dbx, group, Student)
       rescue Dropbox::ApiError
         group.delete
       end
    end

    if changes != []
      new_cursor = dbx.get_latest_list_folder_cursor(item.dpath)
      item.cursor = new_cursor
      item.save if item.changed? and item.persisted?
    end
  end

  def match_student(dbx, item, entity)
    changes = []
    if item.cursor
       update_with_cursor(dbx, item.cursor, entity, Dropbox::FileMetadata, group: item)
       changes = dbx.continue_list_folder(item.cursor)
    else
       update_all(dbx, item.dpath, item.students, entity, Dropbox::FileMetadata, group: item)
    end

    if changes != []
      new_cursor = dbx.get_latest_list_folder_cursor(item.dpath)
      item.cursor = new_cursor
      item.save if item.changed? and item.persisted?
    end
  end
end
