require 'spec_helper'
require 'active_support/backtrace_cleaner'

describe "ActiveSupport Backtrace Cleaner" do
  
  before do
    @cleaner = ::ActiveSupport::BacktraceCleaner.new
  end
  
  it "passes each line in the backtrace through a provided filter block" do
    @cleaner.add_filter { |line| line.upcase }
    
    result = @cleaner.clean(['a', 'b', 'c'])
    
    result.should == ['A', 'B', 'C']
  end
    
  it "removes each line that matches a given silencer block" do
    @cleaner.add_silencer { |line| line == 'b' }
    
    result = @cleaner.clean(['a', 'b', 'c'])
    
    result.should == ['a', 'c']
  end
  
  it "keeps only lines that match a given silencer block when invoked with :noise" do
    @cleaner.add_silencer { |line| line == 'b' }
    
    result = @cleaner.clean(['a', 'b', 'c'], :noise)
    
    result.should == ['b']
  end
  
  it "applies silencers after filters" do
    @cleaner.add_filter { |line| line.upcase }
    @cleaner.add_silencer { |line| line == 'A' }
        
    result = @cleaner.clean(['a', 'b', 'c'])
    
    result.should == ['B', 'C']
  end
  
  it "supports multiple filters at a time" do
    @cleaner.add_filter { |line| line.upcase }
    @cleaner.add_filter { |line| line + '!'}
        
    result = @cleaner.clean(['a', 'b', 'c'])
    
    result.should == ['A!', 'B!', 'C!']
  end
  
  it "supports multiple cleaners at a time" do
    @cleaner.add_silencer { |line| line == 'a' }
    @cleaner.add_silencer { |line| line == 'c' }
        
    result = @cleaner.clean(['a', 'b', 'c'])
    
    result.should == ['b']
  end
  
  it "can be later reconfigured by removing all filters" do
    @cleaner.add_filter { |line| line.upcase }
    @cleaner.remove_filters!
    
    result = @cleaner.clean(['a', 'b', 'c'])
    
    result.should == ['a', 'b', 'c']
  end
  
  
  it "can be later reconfigured by removing all silencers" do
    @cleaner.add_silencer { |line| line == 'b' }
    @cleaner.remove_silencers!
    
    result = @cleaner.clean(['a', 'b', 'c'])
    
    result.should == ['a', 'b', 'c']
  end
  
  
end
