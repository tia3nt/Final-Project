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
            Db_Conn.query_only("Delete from tbl_user")

          end
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

  # after :all do
  #   allow(Db_Conn).to receive(:query_only).with("Delete From tbl_user")
  #   allow(Db_Conn).to receive(:query_only).with("Delete From tbl_collections")
  #   allow(Db_Conn).to receive(:query_only).with("Delete From tbl_comments")
  #   allow(Db_Conn).to receive(:query_only).with("Delete From tbl_hashtag")
  # end

end




# config.mock_with :dbCOnn do | dbMockConn|
#
#
# end
