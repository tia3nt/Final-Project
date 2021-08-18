class Collection

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
          Db_Conn.query_only("DELETE FROM tbl_collections WHERE #{condition}")
          Db_Conn.query_only("DELETE FROM tbl_comments WHERE #{condition2}")
          Db_Conn.query_only("DELETE FROM tbl_hashtag WHERE #{condition2}")
      end
    end

  end

end
