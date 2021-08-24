class Gallery
  def initialize(params)
    @file_extention = "*.*"
     @file_path_to_upload = params['collection_file']
    @collection_type = 'collection_file'
    @uploaded_folder = 'file'
    @tempfile = params['collection_file'][:tempfile]
    @filename = params['collection_file'][:filename]
  end

  def upload
      ('Extention mismatch') unless @file_path_to_upload.include? @file_extention
      File.copy(@tempfile.path, "/upload/#{@uploaded_folder}/#{@filename}")
      Collection.file_gallery_setter("/upload/#{@uploaded_folder}/#{@filename}")
  end

  def show

  end
end
