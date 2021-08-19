
class Db_Conn
  @@idset= {  "tbl_user"=> "user_id",
              "tbl_collections" => "collection_id",
              "tbl_comments" => "comment_id",
              "tbl_hashtag" => "hash_id"}
  def self.connect
    client = Mysql2::Client.new(
      :host => 'localhost',
      :username => ENV['DB_Username'],
      :password => ENV['DB_Password'],
      :database => 'gigih_twitt_db'
    )
  end


  def self.query_only(query_line)
    client = self.connect
    rawData = client.query(query_line)
  end

  def self.data_to_object(rawdata)
       lists = Array.new
       rawdata.each do
         |list|
         lists << list
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
    self.query_only("
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

    rawData = self.query_only("
          select * from #{table} where #{condition}")
    check = rawData.count

    return check>0
  end

def self.find_id(table, data, operand)

idset = @@idset["#{table}"]
conditions =""
length = (operand.size + 2)*-1
    data.each do
      |key, value|
      if value.include?("%")
        conditions << "#{key} LIKE '#{value}' #{operand} "
      else
        conditions << "#{key} = '#{value}' #{operand} "
      end
    end
  conditions = conditions[0..length]

  rawData = self.query_only("
    select #{idset} from #{table} where #{conditions}")
    return rawData.each
end

def self.edit(table, new_data, id)
  idset = @@idset["#{table}"]
  toset= ""
  new_data.each do
    |key, value|
    toset << "#{key} = '#{value}', "
  end
  toset = toset[0..-3]

  self.query_only("
      UPDATE #{table}
      SET #{toset}
      WHERE #{idset} = #{id}
      ")
end


def self.delete(table, parameter, operand)
  condition = ""
  length = (operand.size + 2)* -1
  parameter.each do |key, value|
    if value.to_s.include?("%")
        condition << "#{key} LIKE '#{value}' #{operand} "
      else
        condition << "#{key} = '#{value}' #{operand} "
    end
  end
  condition = condition[0..length]

  self.query_only("
    DELETE FROM #{table} WHERE #{condition}")
end

end
