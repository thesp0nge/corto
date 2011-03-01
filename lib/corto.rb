require 'rubygems'
require 'sqlite3'

class Corto
  
  attr_accessor :db_name
  attr_reader :db
  
  def initialize (options={})
    @db_name= options["db_name"]
    @db_name= './db/corto.db' unless options.has_key? "db_name"
    init_db
  end
  
  
  def purge
    if File.exists?(@db_name)
      File.delete(@db_name)
    end
    @db = SQLite3::Database.new(@db_name)
    @db.execute("CREATE TABLE urls (id integer primary key, url varchar2(256), original varchar2(256));")
    @db.close
  end
  
  def count
    @db = SQLite3::Database.new(@db_name)
    count = @db.execute("SELECT COUNT(*) FROM urls;")
    @db.close
    
    # output is an array of arrays... so [[int]]
    count.first.first
  end
  
  def shrink(url)
    uri = URI::parse(url)
    return nil unless uri.kind_of? URI::HTTP or uri.kind_of? URI::HTTPS
    
    @db = SQLite3::Database.new(@db_name)
    count = @db.execute("SELECT COUNT(*) FROM urls WHERE url='" +url.hash.abs.to_s(36)+"'")
    if count.first.first == 0
      @db.execute("INSERT INTO urls (url, original) VALUES ('"+url.hash.abs.to_s(36)+ "', '"+url+"')")
    end
    @db.close
    
    url.hash.abs.to_s(36)
  end
  
  def deflate(shrunk_url)
    @db = SQLite3::Database.new(@db_name)
    result = @db.execute("SELECT original FROM urls WHERE url='" +shrunk_url+"'")
    (! result.first.nil?) ? result.first.first : nil
  end
  
  private
    def init_db
      if ! File.exists?(@db_name)
        @db = SQLite3::Database.new(@db_name)
        @db.execute("CREATE TABLE urls (id integer primary key, url varchar2(256), original varchar2(256));")
        @db.close
      end
    end
end