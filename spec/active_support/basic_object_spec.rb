require 'spec_helper'
require 'active_support/basic_object'

describe "ActiveSupport BasicObject" do
  
  before do
    @object = ActiveSupport::BasicObject.new
  end
  
  it "cannot be checked for equality using ==" do
    expect { @object == "something" }.to raise_error(NoMethodError)
  end
  
  it "cannot be checked for equality using equal?" do
    expect { @object.equal?("something") }.to raise_error(NoMethodError)
  end
  
  it "can be negated" do
    negated = @object.!
    negated.should be_false
  end
  
end
