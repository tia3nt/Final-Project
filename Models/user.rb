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
  return message
end

def edit(data_to_change)
  return false unless valid?
  return("User not found") unless Db_Conn.exist?("tbl_user", "user_id" => @user_id)
  Db_Conn.edit("tbl_user", data_to_change, @user_id)
  message = "Data has successfully updated"
end
end
