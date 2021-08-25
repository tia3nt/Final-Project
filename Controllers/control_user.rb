class Control_user
def initialize(params)
  @params = params
  @user_password = params["user_password"]
  @password_verify = params["password_verify"]
end
def signup
  return false unless @user_password == @password_verify
  new_user = User.new(@params)
  new_user.create
end


end
