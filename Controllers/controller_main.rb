class Controller_main
  def self.show_home

     data =Db_Conn.query_only('show tables')
     data = Db_Conn.data_to_object(data)

        renderer = ERB.new(File.read("./views/index.erb"))
    renderer.result(binding)

  end
end
