require 'sinatra'
require 'mysql2'
require_relative './Models/dbcon'
require_relative './Models/user'
require_relative './Controllers/controller_main'


set :bind, 'localhost'
# set :port, '2222'


PUBLIC_DIR = File.join(File.dirname(__FILE__), 'static')

 get '/' do
   Controller_main.show_home
 end
