class User

  def initialize(param)
    @user_id = param["user_id"]
    @user_name = param["user_name"]
    @user_email = param["user_email"]
    @user_password = param["user_password"]
    @user_bio = param["user_bio"]
    @user_timestamp = param["user_timestamp"]
  end

  def getter(header)
    data = {
            "user_id" => @user_id,
            "user_name" => @user_name,
            "user_email" => @user_email,
            "user_password" => @user_password,
            "user_bio" => @user_bio,
            "user_timestamp" => @user_timestamp
          }
          return data[header]

  end

def setter(key, value)
  case key
      when "user_id"
        @user_id = value
      when "user_name"
        @user_name = value
      when "user_email"
        @user_email = value
      when "user_password"
        @user_password = value
      when "user_bio"
        @user_bio = value
      when "user_timestamp"
        @user_timestamp = value
  end

end

  def valid?
    return false if @user_name.nil?
    return false if @user_email.nil?

    if @user_email.match(/\W/)
      return false unless @user_email.include?("@")
      return false unless @user_email.include?(".")
    end
    true
  end

def create
  return false unless valid?
  return ("Email has been used, please do login instead") if Db_Conn.exist?("tbl_user",{"user_email" => @user_email})

  data = {"user_id" => @user_id,
          "user_name" => @user_name,
          "user_email" => @user_email,
          "user_password" => @user_password,
          "user_bio" => @user_bio,
          "user_timestamp" => @user_timestamp
        }
  data.keep_if{| k , v | v}
  list_data = Array.new
  header = data.keys
  list_data << data.values

  Db_Conn.create('tbl_user', header, list_data)
  message = "New User has been recorded"

end

def edit(data_to_change)
  return false unless valid?
  return("User doesn't exist") unless Db_Conn.exist?("tbl_user", {"user_id" => @user_id})
  Db_Conn.edit("tbl_user", data_to_change, @user_id)
  message = "Data has successfully updated"
end

def self.get_by_id(user_id)
  return("User doesn't exist") unless Db_Conn.exist?("tbl_user", {"user_id" => "#{user_id}"})
  data = Db_Conn.query_only("SELECT * FROM tbl_user WHERE user_id = #{user_id}")
  data = Db_Conn.data_to_object(data)
  data[0]
end

def self.get_id_by_parameter(param)
  conditions = ""
  param.each do |key, value|
    conditions << "#{key} = '#{value}' AND "
  end
  conditions = conditions[0..-6]
  rawData = Db_Conn.query_only("
                      SELECT user_id
                      FROM tbl_user
                      WHERE #{conditions}")
  return false if rawData.each.empty?
  retrieved_data = Db_Conn.data_to_object(rawData)
  retrieved_data = retrieved_data[0]
  user_id = retrieved_data["user_id"]
end
def self.get_id_by_name_like(name)
  rawData = Db_Conn.query_only("
    SELECT user_id from tbl_user
    WHERE user_name like '%#{name}%'
    ")
    return false if rawData.each.nil?
  id_list = Array.new
  rawData.each do |list|
    id_list << list["user_id"]
  end
  id_list
end
def self.delete(user_id)
  return false if self.get_by_id(user_id) == "User doesn't exist"
  Db_Conn.delete('tbl_user', {"user_id"=> user_id}, "")
  Collection.delete({"user_id" => user_id}) unless Collection.get_id_by_parameter({"user_id" => user_id}) == false
  message = "User Record has successfully deleted"
end

end
