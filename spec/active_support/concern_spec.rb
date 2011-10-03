require 'spec_helper'
require 'active_support/concern'

module Foo
  extend ActiveSupport::Concern
  
  included do
    class_eval do
      def foo_callback_block_method
      end
    end
  end
  
  module ClassMethods
    def foo_class_method
      true
    end
  end
  
  module InstanceMethods
    def foo_instance_method
      true
    end
  end
end

module Bar
  extend ActiveSupport::Concern
  include Foo
  
  included do
    class_eval do
      def bar_callback_block_method
      end
    end
  end
  
  module ClassMethods
    def bar_class_method
      true
    end
  end
  
  module InstanceMethods
    def bar_instance_method
      true
    end
  end
end

class ClassWithFoo
  include Foo
end

class ClassWithBar
  include Bar
end

describe "ActiveSupport Concern" do
  
  it "extends the class with the contents of the ClassMethods module" do
    ClassWithFoo.should respond_to(:foo_class_method)
  end
  
  it "extends instances of the object with the contents of the InstanceMethods module" do
    ClassWithFoo.new.should respond_to(:foo_instance_method)
  end
    
  it "executes the included block when included" do
    ClassWithFoo.new.should respond_to(:foo_callback_block_method)
  end
  
  it "handles dependencies" do
    ClassWithBar.should respond_to(:foo_class_method)
    ClassWithBar.new.should respond_to(:foo_instance_method)
  end
  
  it "calls included block for dependencies" do
    ClassWithBar.new.should respond_to(:bar_callback_block_method)
    ClassWithBar.new.should respond_to(:foo_callback_block_method)
  end
  
end
