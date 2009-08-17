require File.dirname(__FILE__) + '/../lib/custom_matchers'
require File.dirname(__FILE__) + '/spec_helper'

describe Sander6::CustomMatchers::ChangeMatcher do

  describe "should change.when(...)" do
    before(:each) do
      @thing = OpenStruct.new({ :name => "Joe" })
    end
    
    it "should work for any change to the object's 'inspect' value" do
      @thing.should change.when { @thing.name = "Bob" }
    end
    
    it "should work for negative matching for any change to the object's 'inspect' value" do
      @thing.should_not change.when { @thing.name = "Joe" }
    end
    
    it "should reload ActiveRecord::Base objects before comparing the before- and after-block values" do
      unless defined?(ActiveRecord)
        module ActiveRecord; class Base; end; end
      end
      
      @thing.stubs(:is_a?).with(Proc).returns(false)
      @thing.stubs(:is_a?).with(ActiveRecord::Base).returns(true)
      @thing.expects(:reload)
      @thing.should change(:name).when { @thing.name = "Bob" }
    end
    
    it "should not raise an error if ActiveRecord isn't defined" do
      Object.stubs(:const_defined?).with(:ActiveRecord).returns(false)
      lambda { @thing.should change(:name).when { @thing.name = "Bob" } }.should_not raise_error
    end
    
    describe "should change(message).when(...)" do
      before(:each) do
        @thing.job = "Shark Wrestler"
      end
      
      it "should work for any change to the return value of the message" do
        @thing.should change(:name).when { @thing.name = "Jimmy John" }
      end
      
      it "should work for negative matching for any change to the return value of the message" do
        @thing.should_not change(:name).when { @thing.job = "Train Robber" }
      end
    end
    
    describe "should change(&proc).when(...)" do
      before(:each) do
        @thing.quote = "Go hang a salami! I'm a lasagna hog!"
      end
      
      it "should work for any change to the return value of the block" do
        @thing.should change { @thing.quote.gsub(/[^\w]/, '').downcase }.when { @thing.quote = "I like bees." }
      end
      
      it "should work for negative matching to the return value of the block" do
        @thing.should_not change { @thing.quote.gsub(/[^\w]/, '').downcase }.when { @thing.quote = @thing.quote.gsub(/[^\w]/, '').downcase.reverse }
      end
    end
    
    describe "should change(...).to(value).when(...)" do
      it "should work a change to the expected value when sent the given message" do
        @thing.should change(:name).to("Bill").when { @thing.name = "Bill" }
      end
      
      it "should work for negative matching when the value does not change at all" do
        @thing.should_not change(:name).to("Bill").when { @thing.job = "Shadow Boxer" }
      end
      
      it "should work for negative matching when the value does not change to the expected value" do
        @thing.should_not change(:name).to("Bill").when { @thing.name = "Henry" }
      end
    end
    
    describe "should change(...).from(value).when(...)" do
      it "should work for a change from the initial value when sent the given message" do
        @thing.should change(:name).from("Joe").when { @thing.name = "Bill" }
      end
      
      it "should work for negative matching when the value does not change at all" do
        @thing.should_not change(:name).from("Joe").when { @thing.job = "Crab Wrangler" }
      end
      
      it "should work for negative matching when the value was not what was initially expected" do
        @thing.should_not change(:name).from("Ted").when { @thing.job = "Crab Wrangler" }
      end
    end
    
    describe "should change(...).by(amount).when(...)" do
      before(:each) do
        @thing.value = 100
      end
      
      it "should work for a change to the value by the specified amount" do
        @thing.should change(:value).by(10).when { @thing.value = 110 }
      end
      
      it "should work for negative matching when the value does not change at all" do
        @thing.should_not change(:value).by(10).when { @thing.name = "Jimmy Joe Bob" }
      end
      
      it "should work for negative matching when the value does not change by the specified amount" do
        @thing.should_not change(:value).by(10).when { @thing.value = 99 }
      end
      
      describe "should change(...).by_at_least(value).when(...)" do
        it "should work for a change at least as large as the given value" do
          @thing.should change(:value).by_at_least(10).when { @thing.value = 200 }
        end
        
        it "should work for negative matching when the value does not change at all" do
          @thing.should_not change(:value).by_at_least(10).when { @thing.name = "Cajun Pizza Box" }
        end
        
        it "should work for negative matching when the value does not change by enough" do
          @thing.should_not change(:value).by_at_least(10).when { @thing.value = 99 }
        end
      end

      describe "should change(...).by_at_most(value).when(...)" do
        it "should work for a change at most as large as the given value" do
          @thing.should change(:value).by_at_most(10).when { @thing.value = 101 }
        end
        
        it "should work for negative matching when the value does not change at all" do
          @thing.should_not change(:value).by_at_most(10).when { @thing.name = "Cajun Pizza Box" }
        end
        
        it "should work for negative matching when the value does not change by enough" do
          @thing.should_not change(:value).by_at_most(10).when { @thing.value = 0 }
        end
      end      
    end
  end
  
  describe "backward compatibility with the regular RSpec matcher" do
    before(:each) do
      @thing = OpenStruct.new({ :name => "Joe", :value => 100 })
    end
    
    it "should work as expected" do
      lambda { @thing.name = "The Heap" }.should change(@thing, :name)
    end
    
    it "should work as expected when given to" do
      lambda { @thing.name = "Cajun Pizza Box" }.should change(@thing, :name).to("Cajun Pizza Box")
    end
    
    it "should work as expected when given from" do
      lambda { @thing.name = "Cajun Pizza Box" }.should change(@thing, :name).from("Joe").to("Cajun Pizza Box")
    end
    
    it "should work as expected when given by" do
      lambda { @thing.value = 110 }.should change(@thing, :value).by(10)
    end
    
    it "should work as expected when given by_at_least" do
      lambda { @thing.value = 200 }.should change(@thing, :value).by_at_least(10)
    end
    
    it "should work as expected when given by_at_most" do
      lambda { @thing.value = 101 }.should change(@thing, :value).by_at_most(10)
    end    
  end
end