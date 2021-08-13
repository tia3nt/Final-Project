class Controller_main
  def self.show_home

    data =Db_Conn.query('show tables')
        renderer = ERB.new(File.read("./views/index.erb"))
    renderer.result(binding)

  end
end
