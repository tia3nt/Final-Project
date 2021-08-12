require 'sinatra'
require 'mysql2'
require './Models/dbcon'


set :bind, 'localhost'
set :port, '2222'

 get '/' do
   puts (Db_Conn.query_only('show tables'))
 end
