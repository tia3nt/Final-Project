class User
  def initialize(param)
    @user_id = param["user_id"],
    @user_name = param["user_name"],
    @user_email = param["user_email"],
    @user_password = param["user_password"],
    @user_bio = param["user_bio"],
    @user_timestamp = param["user_timestamp"]
  end

  def getter(header)

    case header
      when "user_id"
        @user_id
      when "user_name"
        @user_name
      when "user_email"
        @user_email
      when "user_password"
        @user_password
      when "user_bio"
        @user_bio
      when "user_timestamp"
        @user_timestamp
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

end
