require 'sinatra'
require 'mysql2'
require 'fileutils'
require 'dotenv/load'
require 'down'
require 'sinatra/contrib'

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
