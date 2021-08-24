class Video_Gallery < Gallery
def initialize(params)
  @file_extention ="*.mp4 *.MOV *.3gp *.AVI *.FLV"
  @file_path_to_upload=params['collection_video']
  @collection_type = 'collection_video'
  @uploaded_folder = 'video'
end
def upload
  ('Extention mismatch') unless @file_path_to_upload.include? @file_extention
  File.copy(@tempfile.path, "/upload/#{@uploaded_folder}/#{@filename}")
  Collection.video_gallery_setter("/upload/#{@uploaded_folder}/#{@filename}")
end
def show
end
end
