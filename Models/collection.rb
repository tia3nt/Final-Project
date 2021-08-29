class Collection
@@hashtag_lists
  def initialize(param)
    @collection_id = param["collection_id"]
    @collection_messages = param["collection_messages"]
    @collection_picture = param["collection_picture"]
    @collection_video = param["collection_video"]
    @collection_file = param["collection_file"]
    @collection_flag = param["collection_flag"]
    @collection_timestamp = param["collection_timestamp"]
    @user_id = param["user_id"]
  end

def limit_text
  @collection_messages = @collection_messages[0..999]
end

def hashtag_included?
  @collection_messages.include?('#')
end

def hashtag_counter
  @collection_messages.count "#"
end

def hashtag_detected_records
  hashtag_splitter = Array.new
  hashtag_splitter = @collection_messages.split("#")
  @@hashtag_lists = Array.new
  hashtag_splitter.each do |splitted_message|
    next if splitted_message.empty?
    hashtag_end_point = splitted_message.index(" ")
    splitted_message =  "##{splitted_message[0..hashtag_end_point-1]}"
    splitted_message.chomp!
    splitted_message.chomp!(".")
    @@hashtag_lists << splitted_message
  end
  @@hashtag_lists.shift unless @collection_messages[0] == "#"
  @@hashtag_lists
end

def self.picture_gallery_setter(filepath)
  @collection_picture = filepath
end

def self.video_gallery_setter(filepath)
  @collection_video = filepath
end

def self.file_gallery_setter(filepath)
  @collection_file = filepath
end

def create
  limit_text
  table = 'tbl_collections'
  source =  {'user_id' => @user_id,
            'collection_messages' => @collection_messages,
            'collection_picture' => @collection_picture,
            'collection_video' => @collection_video,
            'collection_file' => @collection_file,
            'collection_flag' => @collection_flag}
  source.keep_if{| k , v | v}
  data = Array.new
  header = source.keys
  data << source.values
  Db_Conn.create(table, header, data)
  if hashtag_included?
     hashtag_detected_records
     new_record = Db_Conn.query_only("select * from
       tbl_collections order by collection_id desc limit 1")
     new_record = new_record.each
     new_record = new_record[0]
     @collection_id = new_record["collection_id"]
     @collection_timestamp = new_record["collection_timestamp"]
    Hashtag.post_collection(@collection_id, @@hashtag_lists, @collection_timestamp)
  end
end

  def self.get_id_by_parameter(param)
    conditions = ""
    param.each do |key, value|
      conditions << "#{key} = '#{value}' AND "
    end
    conditions = conditions[0..-6]
    collection_ids = Array.new
    rawData = Db_Conn.query_only("
      SELECT collection_id
      FROM tbl_collections
      WHERE #{conditions}
      ")
      return false if rawData.each.empty?
  retrieved_array = Db_Conn.data_to_object(rawData)
  retrieved_array.each do |list|
    collection_ids << list["collection_id"]
  end
  collection_ids
  end

  def self.get_by_id(collection_id)
    return("No such collection on post") unless Db_Conn.exist?("tbl_collections",
      {"collection_id" => "#{collection_id}"})

    data = Db_Conn.query_only("
      SELECT * FROM tbl_collections
      WHERE collection_id = #{collection_id}")
    data = Db_Conn.data_to_object(data)
    data[0]
  end

  def self.belong_to(user_id)
    rawData = Db_Conn.query_only("
      SELECT tbl_user.user_name as 'Post Owner',
      tbl_collections.collection_messages as 'Post Text',
      tbl_collections.collection_picture as 'Gallery image',
      tbl_collections.collection_video as 'Gallery Video',
      tbl_collections.collection_file as 'Gallery file',
      tbl_collections.collection_timestamp as 'Post date',
      tbl_comments.user_id as 'Response By',
      tbl_comments.comment_text as 'Comment'
      FROM tbl_collections
      JOIN tbl_user ON tbl_user.user_id = tbl_collections.user_id
      LEFT JOIN tbl_comments ON tbl_comments.post_id = tbl_collections.collection_id
      where
      tbl_collections.user_id = '#{user_id}'
      ")
    collections_data = Db_Conn.data_to_object(rawData)
  end

  def self.delete(param)
    data_list = self.get_id_by_parameter(param)
    unless data_list.nil?
      condition = ""

      data_list.each do |list|
        condition << "collection_id = #{list} OR "
      end
      condition = condition[0..-5]
      condition2 = condition.gsub("collection_id","post_id")
      unless condition == ""
        table_list = ['tbl_collections', 'tbl_comments', 'tbl_hashtag']
        condition_list =[condition, condition2, condition2]
        [0..2].each do |i|
          Db_Conn.query_only("DELETE FROM #{tbl_list[i]} WHERE #{condition_list[i]}")
        end
      end
    end

  end

end
