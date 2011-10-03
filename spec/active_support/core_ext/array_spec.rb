require 'spec_helper'
require 'active_support/core_ext/array'

class NonExtractableHash < Hash
end

class ExtractableHash < Hash
  def extractable_options?
    true
  end
end

describe "ActiveSupport Array extensions" do
  
  describe "access" do
    
    it "returns tail items from given position" do
      [1, 2, 3, 4].from(2).should == [3, 4]
      [1, 2, 3, 4].from(0).should == [1, 2, 3, 4]
    end
    
    it "returns no tail items when getting with a larger index than we have" do
      [1, 2, 3, 4].from(5).should be_empty
    end
    
    it "returns no tail items for an empty array" do
      [].from(1).should be_empty
    end
    
    it "returns head items until a given position" do
      [1, 2, 3, 4].to(1).should == [1, 2]
      [1, 2, 3, 4].to(3).should == [1, 2, 3, 4]
    end
    
    it "returns whole array when getting more head items than we have" do
      [1, 2, 3, 4].to(5).should == [1, 2, 3, 4]
    end
    
    it "return no head items for an empty array" do
      [].to(2).should be_empty
    end
    
    it "should have helper methods for getting second, third, fourth, fifth, and forty-second elements" do
      arr = (1..50).to_a
      
      arr.second.should == 2
      arr.third.should == 3
      arr.fourth.should == 4
      arr.fifth.should == 5
      expect { arr.sixth }.to raise_error(NoMethodError)
      arr.forty_two.should == 42
    end
    
  end
  
  describe "conversions" do
    
    it "is waiting for further specs"
    
  end
  
  describe "option extraction" do
    
    it "removes and returns the last item if it is a hash" do
      arr = [1, 2, {opt: 4}]
      
      returned = arr.extract_options!
      
      arr.should == [1, 2]
      returned.should == {opt: 4}
    end
        
    it "does not remove anything and return an empty hash if the last item is not a hash" do
      arr = [1, 2, 3]
      
      returned = arr.extract_options!
      
      arr.should == [1, 2, 3]
      returned.should == {}
    end
    
    it "returns an empty hash if the array is empty" do
      arr = []
      
      returned = arr.extract_options!
      
      arr.should == []
      returned.should == {}
    end
    
    it "does not remove anything and return an empty hash if the last item is a subclass of hash" do
      arr = [1, 2, 3, NonExtractableHash.new]
      
      returned = arr.extract_options!
      
      arr.size.should == 4
      returned.should == {}
    end
    
    
    it "removes and returns the last item if it is a subclass of hash that overrides extractable_options?" do
      arr = [1, 2, 3, ExtractableHash[:opt, 4]]
    
      returned = arr.extract_options!
    
      arr.size.should == 3
      returned.should == {opt: 4}
    end
    
  end
  
end
