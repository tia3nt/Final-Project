class Gallery
  def initialize(params)
    @file_extention = "*.*"
    @tempfile = params['collection_file'][:tempfile]
    @filename = params['collection_file'][:filename]
    @collection_id = params["collection_id"]
  end

  def upload

      File.open("./public/upload/file/#{@filename}","wb") do |f|
        f.write(@tempfile.read)
      end
      file_path = "/upload/file/#{@filename}"
      collection = Collection.get_by_id("@collection_id")
      collection = Collection.new(collection)
      collection.file_gallery_setter(gallery_path)
      collection.update_("file")
  end

  def show

  end
end
