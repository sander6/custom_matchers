require File.dirname(__FILE__) + '/../lib/custom_matchers'
require File.dirname(__FILE__) + '/spec_helper'

describe Sander6::CustomMatchers::InstanceVariableDefinitionMatcher do

  describe "should have_instance_variable(...)" do
    before(:each) do
      @thing = OpenStruct.new({ :name => "Bumpy" })
      @thing.instance_variable_set(:@chum, "dog")
    end
    
    it "should work" do
      @thing.should have_instance_variable(:@chum)
    end
    
    it "should work for negative matching" do
      @thing.should_not have_instance_variable(:@zoobazz)
    end
    
    it "should check for value" do
      @thing.should have_instance_variable(:@chum).with_value("dog")
    end
    
    it "should work for negative matching with value checking" do
      @thing.should_not have_instance_variable(:@chum).with_value("hacko")
    end
    
    it "should be aliased as #have_ivar" do
      @thing.should have_ivar(:@chum)
    end
  end
  
end

describe Sander6::CustomMatchers::ClassVariableDefinitionMatcher do

  describe "#have_class_variable(...)" do
    before(:each) do
      String.__send__(:class_variable_set, :@@bumpy, "huzzah!")
    end
    
    it "should work" do
      String.should have_class_variable(:@@bumpy)
    end
    
    it "should work for negative matching" do
      String.should_not have_class_variable(:@@doodletown)
    end
    
    it "should check for value" do
      String.should have_class_variable(:@@bumpy).with_value("huzzah!")
    end
    
    it "should work for negative matching with value checking" do
      String.should_not have_class_variable(:@@bumpy).with_value("woozle wazzle!")
    end
    
    it "should be aliased as #have_cvar" do
      String.should have_cvar(:@@bumpy)
    end
  end 
  
end

describe Sander6::CustomMatchers::ConstantDefinitionMatcher do
  
  describe "should have_constant(...)" do
    before(:each) do
      class String
        THING = 10 unless defined?(String::THING) # This cuts out warnings about the constant already being defined.
      end
    end
    
    it "should work" do
      String.should have_constant(:THING)
    end
    
    it "should work for negative matching" do
      String.should_not have_constant(:CRUMBLOR)
    end
    
    it "should check for value" do
      String.should have_constant(:THING).with_value(10)
    end
    
    it "should work for negative matching with value checking" do
      String.should_not have_constant(:THING).with_value("pumpkins")
    end
    
    it "should be aliases as #have_const" do
      String.should have_const(:THING)
    end
  end
  
end