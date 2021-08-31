class Video_Gallery < Gallery
def initialize(params)
  @file_extention ="*.mp4 *.MOV *.3gp *.AVI *.FLV"
  @filename = params[:collection_video][:filename]
  @tempfile = params[:collection_video][:tempfile]
  @collection_type = params[:collection_video][:type]
  @collection_id = params["collection_id"]
  @uploaded_folder = 'video'
end
def upload
  ('Extention mismatch') unless @collection_type.include? @file_extention
    File.open("./public/upload/video/#{@filename}","wb") do |f|
      f.write(@tempfile.read)
    end
    file_path = "/upload/video/#{@filename}"
    collection = Collection.get_by_id(@collection_id)
    collection = Collection.new(collection)
    collection.video_gallery_setter(file_path)
    collection.update_("video")
end
def show
end
end
