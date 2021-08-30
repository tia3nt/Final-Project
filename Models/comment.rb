class Comment
  def initialize(param)
    @post_id = param['post_id']
    @comment_text = param['comment_text']
    @comment_flag = param['comment_flag']
    @user_id = param['user_id']
    @table = 'tbl_comments'
    @header = {
      "comment_id" => @comment_id,
      "post_id" => @post_id,
      "comment_text" => @comment_text,
      "comment_flag" => @comment_flag,
      "user_id" => @user_id
      }
  end
  def limit
    @comment_text = @comment_text[0..999]
  end
  def hashtag_included?
    @comment_text.include?('#')
  end
  def hashtag_detected_records
    hashtag_splitter = Array.new
    hashtag_splitter = @comment_text.split("#")
    @@hashtag_lists = Array.new
    hashtag_splitter.each do |splitted_message|
      next if splitted_message.nil?
      hashtag_end_point = splitted_message.index(" ")
      hashtag_end_point = @comment_text.length unless splitted_message.include?(" ")
      splitted_message =  "##{splitted_message[0..hashtag_end_point-1]}"
      splitted_message.chomp!
      splitted_message.chomp!(".")
      @@hashtag_lists << splitted_message
    end
    @@hashtag_lists.shift unless @comment_text[0] == "#"
    @@hashtag_lists
  end
  def create
    limit
    @header.keep_if{|k, v| v}
    header = @header.keys
    list_data = Array.new
    list_data << @header.values
    Db_Conn.create(@table, header, list_data)
    if hashtag_included?
      hashtag_detected_records
      last_record = Db_Conn.query_only("
        select * from tbl_comments
        order by comment_timestamp desc limit 1")
      last_record = last_record.each
      last_record = last_record[0]
      @comment_id = last_record["comment_id"]
      @comment_timestamp = last_record["comment_timestamp"]
      Hashtag.post_comment(@comment_id, @@hashtag_lists, @comment_timestamp)
    end
  end
  def self.get_id_by_parameter(param)
    conditions = ""
    param.each do |key, value|
      conditions << "#{key} = '#{value}' AND "
    end
    conditions = conditions[0..-6]
    rawData = Db_Conn.query_only("
                        SELECT comment_id
                        FROM tbl_comments
                        WHERE #{conditions}")
    retrieved_data = Db_Conn.data_to_object(rawData)
    retrieved_data = retrieved_data[0]
    comment_id = retrieved_data["comment_id"]
  end
  def self.get_by_id(comment_id)
    return("Comment doesn't exist") unless Db_Conn.exist?("tbl_comments", {"comment_id" => "#{comment_id}"})
    data = Db_Conn.query_only("SELECT * FROM tbl_comments WHERE comment_id = #{comment_id}")
    data = Db_Conn.data_to_object(data)
    data[0]
  end
end
