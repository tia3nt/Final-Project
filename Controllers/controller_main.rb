class Controller_main

  def self.showERB(title)
    renderer = ERB.new(File.read("./views/#{title}"))
    renderer.result(binding)
  end

  def self.show_home
    content_type :json


  end

  def self.show_login

  end
end
