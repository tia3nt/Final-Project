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

require_relative './Controllers/gallery'
require_relative './Controllers/picture_gallery'
require_relative './Controllers/video_gallery'

# set :bind, '34.101.100.243'
set :port, '2222'
# enable :sessions
# set :sessions, :domain => 'gigih.com', :expire_after => 2500000
# set :session_store, Rack::Session::Pool

PUBLIC_DIR = File.join(File.dirname(__FILE__), 'static')

class App < Sinatra::Base
sinatra_flag = 'start'

 get '/signup' do
   Controller_main.showERB('signup.erb')
 end

 post '/signup' do
   content_type :json
   active_user = Control_user.new(params)
   active_user.signup
   Db_Conn.query_only("select * from tbl_user").to_json
 end

 get '/login' do
   Controller_main.showERB('login.erb')
 end

 post '/login' do
   content_type :json
   input_user = {
     "user_email" => params["user_email"],
     "user_password" => params["user_password"]
   }
   user_id = User.get_id_by_parameter(input_user)
   active_user = User.get_by_id(user_id)
   active_user = User.new(active_user)
   return false unless active_user.getter("user_password") == params["user_password"]
   active_user.to_json
   redirect "/user/#{user_id}"
 end

get '/user/:id?' do
  content_type :json
  user_belongging = Hash.new
  active_user = User.get_by_id(params["id"])
  history = Collection.belong_to(params["id"])
  user_belongging = {
    "user_information" => active_user,
    "user_collections_list" => history}
  user_belongging.to_json
end

post '/new/collection/user/:user_id' do
  content_type :json
  data_input = Collection.new(params)
  new_collection = data_input.create
  new_collection.to_json
end

get "/find/user/:name" do
  content_type :json
  value = params["name"]
  id_list = User.get_id_by_name_like(value)
  "There is no user with that name" if id_list.each.nil?
  datas_found = Array.new
  data_found = Hash.new
  id_list.each do |list|
    user = User.get_by_id(list)
    data = Collection.belong_to(list)
    data_found = {"user_information" => user, "user_collections_list" => data}
    datas_found << data_found
  end
  datas_found.to_json
end

post "/post/comment/user/:user_id/collection/:collection_id" do
  content_type :json
  params.store("post_id", "#{params["collection_id"]}")
  new_data = Comment.new(params)
  records = new_data.create
  records.to_json
end

get "/find/hashtag/:text" do
  content_type :json
  text_to_find = params["text"].downcase
  result = Hashtag.find(text_to_find)
  result.to_json
end

get "/hashtags/trending" do
  content_type :json
  result = Hashtag.topfive
  result.to_json
end
get "/attach/collection/gallery" do
  last_collection_id = Collection.last_record
  renderer = ERB.new(File.read("./views/gallery.erb"))
  renderer.result(binding)
end

post "/attach/collection/picture/:collection_id" do
  content_type :json
  gallery = Picture_Gallery.new(params)
  gallery.upload
  updated_data = Collection.get_by_id(params["collection_id"])
  updated_data.to_json
end

post "/attach/collection/video/:collection_id" do
  content_type :json
  gallery = Video_Gallery.new(params)
  gallery.upload
  updated_data = Collection.get_by_id(params["collection_id"])
  updated_data.to_json
end

post "/attach/collection/file/:collection_id" do
  content_type :json
  gallery = Gallery.new(params)
  gallery.upload
  updated_data = Collection.get_by_id(params["collection_id"])
  updated_data.to_json
end
end
