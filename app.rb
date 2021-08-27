require 'sinatra'
require 'mysql2'
require 'fileutils'
require 'dotenv/load'
require 'json'
require 'pp'

require_relative './Models/Db_Conn'
require_relative './Models/user'
require_relative './Models/collection'
require_relative './Models/comment'
require_relative './Models/hashtag'
require_relative './Controllers/controller_main'
require_relative './Controllers/control_user'
require_relative './Controllers/control_collection'
require_relative './Controllers/control_comment'
require_relative './Controllers/control_hashtag'
require_relative './Controllers/gallery'
require_relative './Controllers/picture_gallery'
require_relative './Controllers/video_gallery'

# set :bind, '34.101.100.243'
set :port, '2222'
# enable :sessions
# set :sessions, :domain => 'gigih.com', :expire_after => 2500000
# set :session_store, Rack::Session::Pool

PUBLIC_DIR = File.join(File.dirname(__FILE__), 'static')

sinatra_flag = 'start'

 get '/signup' do
   Controller_main.showERB('signup.erb')
 end

 post '/signup' do
   active_user = Control_user.new(params)
   active_user.signup
   content_type :json
   Db_Conn.query_only("select * from tbl_user").to_json
 end

 get '/login' do
   Controller_main.showERB('login.erb')
 end

 post '/login' do
   input_user = {
     "user_email" => params["user_email"],
     "user_password" => params["user_password"]
   }
   user_id = User.get_id_by_parameter(input_user)
   active_user = User.get_by_id(user_id)
   active_user = User.new(active_user)
   return false unless active_user.getter("user_password") == params["user_password"]
   # data_active_user.to_json
   # content_type :json
   redirect "/user/:#{user_id}"
 end
 #
 # get '/:id?' do
 #
 # end
 #
 # post "/collection/:user_id" do
 #    active_user = User.get_by_id(params["user_id"])
 # end
