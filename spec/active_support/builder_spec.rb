require 'spec_helper'

describe "ActiveSupport Builder" do

  it "only requires builder and is probably only here for backwards compatibility" do
    require 'active_support/builder'
    Builder.should_not be_nil
  end
  
end
