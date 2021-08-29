class Comment
  def initialize(param)
    @post_id = param['post_id']
    @comment_text = param['comment_text']
    @comment_flag = param['comment_flag']
    @user_id = param['user_id']
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
