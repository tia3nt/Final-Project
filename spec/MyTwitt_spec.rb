require_relative "spec_helper"
require_relative "../app.rb"

require_relative "test_helper"
require 'rack/test'

set :environment, :test
include Rack::Test::Methods

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

      it 'should be able to delete existing data records based on given user_id' do
        user_id_to_delete = 1
        message = User.delete(user_id_to_delete)
        expect(Mysql2::Result).to be_truthy
        expect(message).to eq("User Record has successfully deleted")
      end
    end

    end
  end

  describe Collection do
    context 'when user post collections of their thought' do

      it 'should limitate text length into 1000 characters only' do
        collection_messages =
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit.
              Maecenas ipsum enim, maximus nec molestie ut, fermentum sed augue.
              Sed porta elementum varius. Sed sit amet aliquam justo.
              Donec ut scelerisque elit. Fusce nisl magna, rutrum sit amet ornare
              id, bibendum vitae magna. Nullam eget finibus turpis. Sed faucibus
              hendrerit leo nec cursus. Integer at augue vel ex porttitor feugiat.
              In nulla magna, pretium eleifend nunc vitae, congue consequat justo.
              Ut et ultrices magna. Quisque purus quam, ullamcorper ac eros id,
              malesuada hendrerit velit. Curabitur sed finibus magna. Aenean sit
               amet condimentum ipsum. Praesent dui enim, feugiat quis quam ac,
               volutpat tristique augue.

              Aenean ornare tellus augue, nec sollicitudin ante mattis nec.
              Phasellus sollicitudin, mauris sit amet tempor lacinia, libero
              sapien dignissim massa, id sollicitudin purus enim non velit.
              Etiam eu fermentum mi. Phasellus aliquet leo tincidunt massa
              tincidunt, quis ullamcorper lacus dapibus. Cras placerat mi
              elementum luctus ultricies. Quisque aliquet iaculis turpis at
              hendrerit. Sed ultrices dolor vitae sem rhoncus, nec semper quam
              sollicitudin. Proin sed sem at augue sagittis hendrerit vel in
              purus. Donec aliquam ipsum ac semper malesuada. Nunc non consectetur
              dolor. In at porta diam, vitae facilisis risus."

        user_input = {"collection_messages" => collection_messages}
        collection1 = Collection.new(user_input)
        message = collection1.limit_text
        expect(message.length).to be <= 1000

      end

      it 'should be able to detect hashtags and record it' do
        collection_messages =
        "#Lorem ipsum dolor sit amet, consectetur adipiscing elit.
        Maecenas ipsum enim, maximus nec molestie ut, fermentum sed augue.
        Sed porta #elementum varius. Sed sit amet aliquam justo.
        Donec ut scelerisque elit. Fusce nisl magna, rutrum sit amet ornare
        id, bibendum vitae magna. Nullam eget finibus turpis. Sed faucibus
        hendrerit leo nec cursus. Integer at augue vel ex #PorttitorFeugiat.
        In nulla magna, pretium eleifend nunc vitae, congue consequat justo.
        Ut et ultrices magna. Quisque purus quam, ullamcorper ac eros id,
        malesuada hendrerit velit. Curabitur sed finibus magna. Aenean sit
         amet condimentum ipsum. Praesent dui enim, feugiat quis quam ac,
         volutpat tristique augue."

         user_input = {"collection_messages" => collection_messages,
                        "user_id" => 1}
        collection1 = Collection.new(user_input)
        checker = collection1.hashtag_included?
        expect(checker).to be true

        counter = collection1.hashtag_counter
        expect(counter).to eq(3)

        hashtag_found = collection1.hashtag_detected_records
        expect(hashtag_found).to eq(['#Lorem', '#elementum', '#PorttitorFeugiat'])
      end

      xit 'should be able to upload a picture files' do
        params = {collection_picture: {filename: "Screenshot_2.png",
          type: "image/png", name: "collection_picture",
          tempfile: "#<Tempfile:C:/Users/Eka/AppData/Local/Temp/RackMultipart20210825-11304-13jpafn.png>",
          head: "Content-Disposition: form-data; name=\"collection_picture\";
          filename=\"Screenshot_2.png\"\r\nContent-Type: image/png\r\n"}}

        collection1 = Picture_Gallery.new(params)
        picture_gallery_path = collection1.upload
        expect(picture_gallery_path).to eq("/upload/picture/Screenshot_2.png")
      end

      xit 'should be able to upload a video files' do

      end

      xit 'should be able to upload a files' do

      end

      xit 'should be able to create new collections records' do
        new_message = "Hello #DuniaTanpaBatas"
        new_image = ''
      end

      xit 'should be able to view uploaded gallery collection' do

      end


    end

  end
  describe Hashtag do
    context 'when a user create a collection messages, that contain some hashtags' do
      it 'should be able to detect previously recorded existance' do
        Db_Conn.query_only("DELETE FROM tbl_hashtag")
        Db_Conn.query_only("ALTER TABLE tbl_hashtag AUTO_INCREMENT = 1")

        check = Hashtag.hash_collection_exist?(1,'#Lorem')
        expect(check).to be false
      end
      xit 'should be recorded onto hashtag tables, with its related collection id' do
        collection_id = 1
        hashtag_lists = ['#Lorem', '#elementum', '#PorttitorFeugiat']
        collection_timestamp = Time.now.getutc
        Hashtag.post_collection(collection_id, hashtag_lists, collection_timestamp)
        expect(Mysql2::Client).to receive(:query).thrice
      end
    end
  end

  describe 'sinatra running' do
    context 'when user first use/start session on the application' do
      it 'should be able to show signup new user page' do
        get '/signup'
        expect(last_response).to be_ok
      end
      it 'should be able to register new user' do
        params = {
          "user_name" => "Cinderella",
          "user_email"=> "cinder@ela.com",
          "user_password" => "upikabu123",
          "password_verify" => "upikabu123",
          "user_bio" => "1950-01-27"}

        post '/signup'
        user = User.new(params)
        user.create
        expect(last_response).to be_ok
        expect(Mysql2::Result).to be_truthy
      end

      it 'should be able to show login screen' do
        get '/login'
        expect(last_response).to be_ok
      end

      it 'available user should be able to login' do
        params = {
          "user_email" => "MWira@gmail.com",
          "user_password" => "test123"
        }
        user_id = User.get_id_by_parameter(params)
        post '/login'
        expect(last_response).to be_redirect
      end

    end


  end
end
