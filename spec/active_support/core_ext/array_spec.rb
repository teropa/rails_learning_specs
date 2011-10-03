require 'spec_helper'
require 'active_support/core_ext/array'

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
  
end
