class Controller_main
  def self.show_home

    redirect '/login' if sinatra_flag = 'start'
    # redirect '/login' if @request.session[:message].nil?
    renderer = ERB.new(File.read("./views/index.erb"))
    renderer.result(binding)
  end

  def self.show_login
    renderer = ERB.new(File.read("./views/login.erb"))
    renderer.result(binding)
  end
end
