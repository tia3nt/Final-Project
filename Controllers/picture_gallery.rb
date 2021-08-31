class Picture_Gallery < Gallery
  def initialize(params)
    @file_extention = "*.img *.png *.JPEG *.gif *.bmp"
    @collection_type = params[:collection_picture][:type]
    @collection_id = params["collection_id"]
    @filename = params[:collection_picture][:filename]
    @tempfile = params[:collection_picture][:tempfile]
    @collection_id = params["collection_id"]
  end
  def upload
  ('Extention mismatch') unless @collection_type.include? @file_extention
    File.open("./public/upload/picture/#{@filename}","wb") do |f|
      f.write(@tempfile.read)
    end
    file_path = "/upload/picture/#{@filename}"
    picture_gallery = Collection.get_by_id(@collection_id)
    collection = Collection.new(picture_gallery)
    collection.picture_gallery_setter(file_path)
    collection.update_("picture")
  end
  def show
  end
end
