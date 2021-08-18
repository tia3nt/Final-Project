require_relative "spec_helper"
require_relative "../main.rb"
require_relative "test_helper"
require 'rack/test'




set :environment, :test


def app
    Sinatra::Application
end



RSpec.describe 'MyTwitt' do

before :all do
  Db_Conn.query_only("SET FOREIGN_KEY_CHECKS = 0")
  Db_Conn.query_only("DELETE FROM tbl_user")
  Db_Conn.query_only("ALTER TABLE tbl_user AUTO_INCREMENT = 1")
  Db_Conn.query_only("DELETE FROM tbl_collections")
  Db_Conn.query_only("ALTER TABLE tbl_collections AUTO_INCREMENT = 1")
  Db_Conn.query_only("DELETE FROM tbl_comments")
  Db_Conn.query_only("ALTER TABLE tbl_comments AUTO_INCREMENT = 1")
  Db_Conn.query_only("DELETE FROM tbl_hashtag")
  Db_Conn.query_only("ALTER TABLE tbl_hashtag AUTO_INCREMENT = 1")
  Db_Conn.query_only("SET FOREIGN_KEY_CHECKS = 1")
end


  describe Db_Conn do
      context 'When real database accept queries' do

        before :each do
          Db_Mock = double
          allow(Mysql2::Client).to receive(:new).and_return(Db_Mock)
        end

        it 'mocks database should be abble to take over on test' do

            expect(Db_Mock).to receive(:query).once
            Db_Conn.query_only('Show tables')

        end

        context 'When given valid input' do
          it 'should be able to create new database records' do
            table = 'tbl_user'
            table_columns = ["user_name", "user_email", "user_password", "user_bio"]
            table_values =[["Vanita Rania", "vanita@rania.net", "pass1", "1995-03-20"],
                            ["Meriam Wiranata", "Mwira@gmail.com", "pass2", "2000-01-23"]]

            expect(Db_Mock).to receive(:query).once

              Db_Conn.create(table, table_columns, table_values)

              expect(Mysql2::Result).to be_truthy

          end
        end
      end
      context "When sequential data record is needed, real database should take place" do
          it 'should be able to detect existing data' do
            table = "tbl_user"
            prev_col = ["user_name", "user_email", "user_password", "user_bio"]
            prev_data =[["Vanita Rania", "vanita@rania.net", "pass1", "1995-03-20"],
                        ["Meriam Wiranata", "Mwira@gmail.com", "pass2", "2000-01-23"]]

            Db_Conn.create(table, prev_col, prev_data)

            new_data = {:user_id => 1, :user_email => "Mwira@gmail.com"}

            check = Db_Conn.exist?(table, new_data)
            expect(check).to be_truthy

          end


          it 'should be able to find id of given parameter' do
            table = 'tbl_user'
            data = {:user_email =>"vanita@rania.net", :user_bio => "1995-03-20"}
            operand = 'AND'

            num_id = Db_Conn.find_id(table, data, operand)
            expect(num_id.size).to be > 0
          end

          it 'should be able to edit previously inserted data, based on its id' do
            table = 'tbl_user';
            new_data = {:user_name => "Sabrina Renata"}
            user_id = 1

            Db_Conn.edit(table, new_data,user_id)
            expect(Mysql2::Result).to be_truthy

          end

          it 'should be able to delete records of given parameter' do
            table = 'tbl_user'
            parameter = {"user_name" => "Vanita Rania", "user_bio" => "1995-03-20"}
            operand = 'AND'

            Db_Mock = double
            allow(Mysql2::Client).to receive(:new).and_return(Db_Mock)
            expect(Db_Mock).to receive(:query).once

            Db_Conn.delete(table, parameter, operand)
            expect(Mysql2::Result).to be_truthy
          end

        end
      end


  describe User do
    context 'when given input' do
      it 'should be able to validate input' do
        param = { "user_name" => "Malika Azzahra",
                  "user_password" => "malika123",
                  "user_email" => "malika@gmail.com",
                  "user_bio" => "2012-01-30"}

        user = User.new(param)
        check = user.valid?

        expect(check).to be true
      end

      it 'should be able to check duplicate email registration' do
          new_data= {"user_name" => "Karina Mulia",
                      "user_email" => "Mwira@gmail.com"}

          user= User.new(new_data)
          message= user.create

          expect(message).to eq("Email has been used, please do login instead")
      end

    context 'when given valid and non duplicate input' do
      it 'should be able to record inputed data to database' do
        new_data = {"user_name" => "Teddy Brown",
                    "user_email" => "teddy@brownland.net",
                    "user_password" => "teddy123",
                    "user_bio" => "1990-05-24"}

        user = User.new(new_data)
        message = user.create

        expect(message).to eq("New User has been recorded")
        expect(Mysql2::Result).to be_truthy

      end

      it 'should be able to update changes directed by user_id' do
        old_record ={ "user_id" => 2,
                      "user_name" => "Meriam Wiranata",
                      "user_email" => "MWira@gmail.com",
                      "user_password" => "pass2",
                      "user_bio" => "2000-01-23",
                      "user_timestamp" => "2021-08-18 00:58:27"
                    }
        data_to_change = {"user_name" => "Hamid Wiranata",
                          "user_password" => "test123"}
        user_id = 2

        user = User.new(old_record)
        message = user.edit(data_to_change)
        expect(Mysql2::Result).to be_truthy
        expect(message).to eq("Data has successfully updated")

      end
    end
    context 'when given previously stored data' do
      it 'should be able to return all instance variable related to user_id' do
          user_id = 3

          user_data = User.get_by_id(user_id)
          expect(Mysql2::Result).to be_truthy

      end
    end

    end
  end



  describe 'sinatra running' do
    include Rack::Test::Methods

    xit 'should be abble to handle query and automatically handle rawdata into sinatra previewed-able' do

      get '/'
      expect(last_response).to be_ok

    end

  end
end
