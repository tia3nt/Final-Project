class Hashtag
  def initialize(param)
    @post_id = param["post_id"]
    @comment_id = param["comment_id"]
    @hash_text = param["hash_text"]
    @hash_timestamp = param["hash_timestamp"]
  end
  def self.post_collection(collection_id, hashtag_lists, timestamp)
    table = 'tbl_hashtag'
    timestamp = timestamp.to_datetime
    header = ['post_id', 'hash_text', 'hash_timestamp']
    return false if hashtag_lists.nil?
    hashtag_lists.uniq.each do |list|
      data = [["#{collection_id}","#{list}","#{timestamp}"]]
      return false if self.hash_collection_exist?(collection_id, list)
      Db_Conn.create(table, header, data)
    end
  end
  def self.hash_collection_exist?(collection_id, data)
    data_checker =  Db_Conn.query_only("
      SELECT * FROM tbl_hashtag WHERE post_id = '#{collection_id}'
      AND LOWER(hash_text) = '#{data.downcase!}'")
    data_checker.each.nil?
  end
  def self.get_id_by_parameter(param)
    conditions = ""
    param.each do |key, value|
      conditions << "#{key} = '#{value}' AND "
    end
    conditions = conditions[0..-6]
    rawData = Db_Conn.query_only("
                        SELECT hash_id
                        FROM tbl_hashtag
                        WHERE #{conditions}")
    retrieved_data = Db_Conn.data_to_object(rawData)
    retrieved_data = retrieved_data[0]
    hash_id = retrieved_data["hash_id"]
  end
  def self.get_by_id(hash_id)
    return("No such hashtag") unless Db_Conn.exist?("tbl_hashtag", {"hash_id" => "#{hash_id}"})
    data = Db_Conn.query_only("SELECT * FROM tbl_hashtag WHERE hash_id = #{hash_id}")
    data = Db_Conn.data_to_object(data)
    data[0]
  end
  def self.post_comment(comment_id, hashtag_list, timeline)
    table = 'tbl_hashtag'
    timestamp = timeline.to_datetime
    header = ['comment_id', 'hash_text', 'hash_timestamp']
    return false if hashtag_list.nil?
    hashtag_list.uniq.each do |list|
      data = [["#{comment_id}","#{list}","#{timestamp}"]]
      return false if self.hash_comment_exist?(comment_id, list)
      Db_Conn.create(table, header, data)
    end
  end
  def self.hash_comment_exist?(comment_id, data)
    data_checker =  Db_Conn.query_only("
      SELECT * FROM tbl_hashtag WHERE comment_id = '#{comment_id}'
      AND LOWER(hash_text) = '#{data.downcase!}'")
    data_checker.each.nil?
  end
end
