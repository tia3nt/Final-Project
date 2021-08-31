class Controller_main

  def self.showERB(title)
    renderer = ERB.new(File.read("./views/#{title}"))
    renderer.result(binding)
  end
end
