require File.dirname(__FILE__) + '/../lib/custom_matchers'
require File.dirname(__FILE__) + '/spec_helper'

describe Sander6::CustomMatchers::ChangeMatcher do

  describe "should change(...).when(...)" do
    before(:each) do
      @thing = OpenStruct.new({ :name => "Joe" })
    end
    
    it "should match for any change to the value" do
      @thing.should change(:name).when { @thing.name = nil }
    end
    
    it "should match for a specified change to the value" do
      @thing.should change(:name).to("Bob").when { @thing.name = "Bob" }
    end
    
    it "should work for a negative match" do
      @thing.should_not change(:name).when { @thing.appellation = "Bob" }
    end
    
    it "should work for a negative match for a specified change to the value" do
      @thing.should_not change(:name).to("Bob").when { @thing.name = "Danny" }
    end
    
    it "should reload ActiveRecord::Base objects before comparing the before- and after-block values" do
      @thing.stubs(:is_a?).with(ActiveRecord::Base).returns(true)
      @thing.expects(:reload)
      @thing.should change(:name).when { @thing.name = "Bob" }
    end
  end
  
end