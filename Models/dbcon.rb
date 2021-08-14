
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

  def self.query(query_line)
    rawData = self.query_only(query_line)
    lists = Array.new
    rawData.each do |list|
      lists.push(list)
    end
    lists
  end

  def self.create(table, col, data)
    column_text = ""
    col.each do |list|
      column_text << list
      column_text << ", "
    end
    column_text=column_text[0..-3]

    data_text = ""
    data.each do |lists|
      data_text << "("
      lists.each do |list|
        data_text << '"'
        data_text << list
        data_text << '", '
      end
      data_text=data_text[0..-3]
      data_text << "), "
    end
    data_text=data_text[0..-3]
    
    @@client.query("
      INSERT INTO #{table}
      (#{column_text})
      VALUES #{data_text}
      ")
  end

  def self.exist?(table, param)
    condition = ""
    param.each do
      |key, value|
      condition << "#{key} = '#{value}' OR "
    end
    condition = condition[0..-5]

    rawData = @@client.query("
          select * from #{table} where #{condition}")
    check = rawData.count

    return check>0
  end
end
