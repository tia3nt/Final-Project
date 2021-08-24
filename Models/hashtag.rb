class Hashtag
  def self.post_collection(collection_id, hashtag_lists, timestamp)
    table = 'tbl_hashtag'
    header = ['post_id', 'hash_text', 'hash_timestamp']

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
end
