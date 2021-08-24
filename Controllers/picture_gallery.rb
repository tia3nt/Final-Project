class Picture_Gallery < Gallery
  def initialize(params)
    @file_extention = "*.img *.png *.JPEG *.gif *.bmp"
    @file_path_to_upload =params['collection_picture']
    @collection_type = 'collection_picture'
    @uploaded_folder = 'picture'
  end
  def upload
    ('Extention mismatch') unless @file_path_to_upload.include? @file_extention
    File.copy(@tempfile.path, "/upload/#{@uploaded_folder}/#{@filename}")
    Collection.picture_gallery_setter("/upload/#{@uploaded_folder}/#{@filename}")
  end
  def show
  end
end
