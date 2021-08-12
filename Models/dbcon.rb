class Db_Conn
  def self.connect
    client = Mysql2::Client.new(
      :host => 'localhost',
      :username => ENV['DB_Username'],
      :password => ENV['DB_Password'],
      :database => 'gigih_twitt_db'
    )
  end
    @@client = self.connect

  def self.query_only(query_line)
    rawData = @@client.query(query_line)
  end
end
