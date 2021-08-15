require_relative "spec_helper"
require_relative "../main.rb"
require_relative "test_helper"
require 'rack/test'




set :environment, :test


def app
    Sinatra::Application
end



RSpec.describe 'MyTwitt' do

  describe Db_Conn do
      context 'When real database accept queries' do
        before :each do
          Db_Mock = class_double(Db_Conn)
        end

        it 'mocks database should be abble to take over on test' do
            Db_Mock.as_stubbed_const
            expect(Db_Mock).to receive(:query_only).once
            Db_Conn.query_only('Show tables')
        end

        context 'When given valid input' do
          it 'should be able to create new database records' do
            table = 'tbl_user'
            table_columns = ["user_name", "user_email", "user_password", "user_bio"]
            table_values =[["Vanita Rania", "vanita@rania.net", "pass1", "1995-03-20"],
                            ["Meriam Wiranata", "Mwira@gmail.com", "pass2", "2000-01-23"]]

            Db_Mock.as_stubbed_const
            expect(Db_Mock).to receive(:create).with(table, table_columns, table_values)
              Db_Conn.create(table, table_columns, table_values)


          end


          it 'should be able to detect existing data' do
            table = "tbl_user"
            prev_col = ["user_name", "user_email", "user_password", "user_bio"]
            prev_data =[["Vanita Rania", "vanita@rania.net", "pass1", "1995-03-20"],
                        ["Meriam Wiranata", "Mwira@gmail.com", "pass2", "2000-01-23"]]

            Db_Conn.create(table, prev_col, prev_data)

            new_data = {:user_id => 1, :user_email => "Mwira@gmail.com"}

            expect(Db_Conn).to receive(:exist?).with(table, new_data).and_call_original

            check = Db_Conn.exist?(table, new_data)
            expect(check).to be_truthy


          end

          it 'should be able to find id of given parameter' do
          table = 'tbl_user'
          data = {:user_email =>"vanita@rania.net", :user_bio => "1995-03-20"}
          operand = 'AND'

          expect(Db_Conn).to receive(:find_id).with(table, data, operand).and_call_original
          num_id = Db_Conn.find_id(table, data, operand)
          expect(num_id.size).to be > 0
          end

          it 'should be able to edit previously inserted data, based on its id' do
            table = 'tbl_user';
            new_data = {:user_name => "Sabrina Renata"}
            user_id = 25

            Db_Mock.as_stubbed_const
            expect(Db_Conn).to receive(:edit).with(table, new_data, user_id)
            Db_Conn.edit(table, new_data,user_id)

          end

          Db_Conn.query_only("Delete from tbl_user")
        end

      end

  end

  describe 'sinatra running' do
    include Rack::Test::Methods
  #
    it 'should be abble to handle query and automatically handle rawdata into sinatra previewed-able' do
      db_conn_mock = double
      allow(Mysql2::Client).to receive(:new).and_return(db_conn_mock)

      get '/'
      expect(last_response).to be_ok
    end

  end



end




# config.mock_with :dbCOnn do | dbMockConn|
#
#
# end
