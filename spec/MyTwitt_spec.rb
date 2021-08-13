require_relative "spec_helper"
require_relative "../main.rb"
require_relative "test_helper"
require 'rack/test'




set :environment, :test_helper


def app
    Sinatra::Application
end


RSpec.describe 'MyTwitt' do
  describe Db_Conn do
      context 'When real database accept queries' do
        it 'mocks database should be abble to take over on test' do
            db_conn_mock = double
            allow(Mysql2::Client).to receive(:new).and_return(db_conn_mock)
                data = Db_Conn.query_only('SHOW TABLES')
            expect(Mysql2::Result).to be_truthy

        end

      end

  end

  describe 'sinatra running' do
    include Rack::Test::Methods
    

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
