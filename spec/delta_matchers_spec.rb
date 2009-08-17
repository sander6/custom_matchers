require File.dirname(__FILE__) + '/../lib/custom_matchers'
require File.dirname(__FILE__) + '/spec_helper'

describe Sander6::CustomMatchers::IncrementMatcher do

  describe "should increment(...).when(...)" do
    before(:each) do
      @thing = OpenStruct.new({ :value => 1 })
    end
    
    it "should work" do
      @thing.should increment(:value).when { @thing.value += 1 }
    end
    
    it "should accept a value to increment by" do
      @thing.should increment(:value).by(3).when { @thing.value += 3 }
    end
    
    it "should reload ActiveRecord::Base objects before comparing the before- and after-block values" do
      unless defined?(ActiveRecord)
        module ActiveRecord; class Base; end; end
      end
      @thing.stubs(:is_a?).with(ActiveRecord::Base).returns(true)
      @thing.expects(:reload)
      @thing.should increment(:value).by(3).when { @thing.value += 3 }
    end
    
    it "should not raise an error if ActiveRecord isn't defined" do
      Object.stubs(:const_defined?).with(:ActiveRecord).returns(false)
      lambda { @thing.should increment(:value).by(3).when { @thing.value += 3 } }.should_not raise_error
    end    
  end
  
end

describe Sander6::CustomMatchers::DecrementMatcher do

  describe "should decrement(...).when(...)" do
    before(:each) do
      @thing = OpenStruct.new({ :value => 10 })
    end
    
    it "should work" do
      @thing.should decrement(:value).when { @thing.value -= 1 }
    end
    
    it "should accept a value to increment by" do
      @thing.should decrement(:value).by(3).when { @thing.value -= 3 }
    end
    
    it "should reload ActiveRecord::Base objects before comparing the before- and after-block values" do
      unless defined?(ActiveRecord)
        module ActiveRecord; class Base; end; end
      end
      @thing.stubs(:is_a?).with(ActiveRecord::Base).returns(true)
      @thing.expects(:reload)
      @thing.should decrement(:value).by(3).when { @thing.value -= 3 }
    end

    it "should not raise an error if ActiveRecord isn't defined" do
      Object.stubs(:const_defined?).with(:ActiveRecord).returns(false)
      lambda { @thing.should decrement(:value).by(3).when { @thing.value -= 3 } }.should_not raise_error
    end
  end
  
end