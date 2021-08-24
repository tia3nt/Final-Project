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


def self.create

  table = 'tbl_collections'
  header =  ['user_id',
            'collection_messages',
            'collection_picture',
            'collection_video',
            'collection_file',
            'collection_flag']
  data =  [[@user_id,
            @collection_messages,
            @collection_picture,
            @collection_video,
            @collection_file,
            @collection_flag]]

  Db_Conn.create(table, header, data)
  Hashtag.post_collection(@collection_id, @@hashtag_lists, @collection_timestamp)
end
  def self.get_id_by_parameter(param)
    conditions = ""
    param.each do |key, value|
      conditions << "#{key} = '#{value}' AND "
    end
    conditions = conditions[0..-6]

    rawData = Db_Conn.query_only("
      SELECT collection_id
      FROM tbl_collections
      WHERE #{conditions}
      ")
  retrieved_array = Db_Conn.data_to_object(rawData)

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
