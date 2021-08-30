class Picture_Gallery < Gallery
  def initialize(params)
    @file_extention = "*.img *.png *.JPEG *.gif *.bmp"
    @file_to_upload = params[:collection_picture][:tempfile]
    @filename       = params[:collection_picture][:filename]
    @collection_type = params[:collection_picture][:type]
    @uploaded_folder = 'picture'
  end
  def upload
    ('Extention mismatch') unless @collection_type.include? @file_extention
    File.new("/picture/#{@filename}", 'wb') do |gallery_file|
      gallery_file.write(@file_to_upload.read)
      file_path_to_upload = "/upload/picture/#{@filename}"
    end
    file_path_to_upload
  end
  def show
  end
end
