 require 'sinatra'
require 'mysql2'
require 'fileutils'
require 'dotenv/load'
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

set :bind, 'localhost'
set :port, '2222'


PUBLIC_DIR = File.join(File.dirname(__FILE__), 'static')

 get '/' do
   Controller_main.show_home
 end
