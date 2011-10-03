require 'spec_helper'
require 'active_support/base64'

describe "ActiveSupport Base64" do
  
  it "encodes a string" do
    unencoded = 'not encoded'
    encoded = Base64.encode64(unencoded)
    encoded.should_not be_nil
  end
  
  it "inserts newlines to what it encodes" do
    unencoded = (1..100).map { |i| "something something "}.join
    encoded = Base64.encode64(unencoded)
    encoded.should include("\n")
  end
  
  it "can decode something it has itself encoded" do
    unencoded = 'not encoded'
    encoded = Base64.encode64(unencoded)
    decoded = Base64.decode64(encoded)
    decoded.should == 'not encoded'
  end
  
  it "can decode something encoded elsewhere" do
    encoded = "bXkgaG92ZXJjcmFmdCBpcyBmdWxsIG9mIGVlbHM="
    decoded = Base64.decode64(encoded)
    decoded.should == 'my hovercraft is full of eels'
  end
  
  it "encodes without newlines when told so" do
    unencoded = 'not encoded'
    encoded = Base64.encode64s(unencoded)
    encoded.should_not be_nil
    encoded.should_not include("\n")
  end
  
  it "can decode something encoded without newlines" do
    unencoded = 'a string that, when encoded, should have some newlines in it since it is long enough'
    encoded = Base64.encode64s(unencoded)
    decoded = Base64.decode64(encoded)
    decoded.should == unencoded
  end
  
end
