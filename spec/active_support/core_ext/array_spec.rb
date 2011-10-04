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
  
  describe "grouping to even sizes" do
    
    it "splits to groups of n" do
      res = [1, 2, 3, 4].in_groups_of(2)
      res.should == [[1, 2], [3, 4]]
    end
    
    it "yields the groups if a block is given" do
      res = []
      [1, 2, 3, 4].in_groups_of(2) { |group| res << group }
      res.should == [[1, 2], [3, 4]]
    end
    
    it "pads the last group if a fill argument is given" do
      res = [1, 2, 3, 4].in_groups_of(3, :fill)
      res.should == [[1, 2, 3], [4, :fill, :fill]]
    end
    
    it "does not pad the last group if the split is even" do
      res = [1, 2, 3, 4].in_groups_of(2, :fill)
      res.should == [[1, 2], [3, 4]]
    end
    
    it "pads with nil if no fill argument is given" do
      res = [1, 2, 3, 4].in_groups_of(3)
      res.should == [[1, 2, 3], [4, nil, nil]]
    end
    
  end
  
  describe "grouping to a number of groups" do
    
    it "splits to n groups of size/n when split evenly" do
      res = [1, 2, 3, 4].in_groups(2)
      res.should == [[1, 2], [3, 4]]
    end

    it "returns n empty arrays if grouping an empty array" do
      [].in_groups(2).should == [[], []]
    end
    
    it "yields the groups if a block is given" do
      res = []
      [1, 2, 3, 4].in_groups(2) { |group| res << group }
      res.should == [[1, 2], [3, 4]]
    end
    
    it "pads the last group when a fill argument is given" do
      res = [1, 2, 3].in_groups(2, :fill)
      res.should == [[1, 2], [3, :fill]]
    end
    
    it "pads with nil when a fill argument is not given" do
      res = [1, 2, 3].in_groups(2)
      res.should == [[1, 2], [3, nil]]
    end
    
    
    it "distributes pad evenly when not split evenly" do
      res = [1, 2, 3, 4].in_groups(3)
      res.should == [[1, 2], [3, nil], [4, nil]]
    end
    
    it "returns groups with pad only when splitting to larger number than the original array" do
      res = [1, 2, 3, 4].in_groups(6)
      res.should == [[1], [2], [3], [4], [nil], [nil]]
    end
    
  end
  
  describe "splitting" do
    
    it "splits from match" do
      res = [1, 2, 3, 4, 5].split(3)
      res.should == [[1, 2], [4, 5]]
    end
    
    it "splits from multiple matches" do
      res = [1, 2, 3, 4, 5, 4, 3, 2, 1].split(3)
      res.should == [[1, 2], [4, 5, 4], [2, 1]]
    end
    
    it "splits by testing block if block is given" do
      res = [1, 2, 3].split { |n| n % 2 == 0 }
      res.should == [[1], [3]]
    end
    
    it "returns an empty array as last if the last item matches" do
      res = [1, 2, 3, 4].split(4)
      res.should == [[1, 2, 3], []]
    end
    
    it "returns an empty array as first if the first item matches" do
      res = [1, 2, 3, 4].split(1)
      res.should == [[], [2, 3, 4]]
    end
    
    it "does not split when there is no match" do
      res = [1, 2, 3, 4].split(5)
      res.should == [[1, 2, 3, 4]]
    end
    
  end
  
end
