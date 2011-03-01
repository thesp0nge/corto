require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Corto" do
  let(:corto) {Corto.new({"db_name"=>'spec/data/test_db.db'})}
  it "should recreate a shortned url db" do
    corto.purge
    corto.count.should == 0
  end
  
  it "should shrink an url" do
    a = corto.shrink('http://www.armoredcode.com')
    a.should.nil? == false
  end
  
  it "should able to reverse a shrink" do
    a = corto.shrink('http://www.armoredcode.com')
    b = corto.deflate(a)
    b.should == "http://www.armoredcode.com"
  end
  
  it "should handle a non existing shrink" do
    a = corto.deflate('this can not be a valid shrinked url')
    a.should.nil? == true
  end
  
end
