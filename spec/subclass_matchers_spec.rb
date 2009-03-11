require File.dirname(__FILE__) + '/../lib/custom_matchers'
require File.dirname(__FILE__) + '/spec_helper'

describe Sander6::CustomMatchers::SubClassMatcher do

  describe "should descend_from(...)" do
    before(:each) do
      class Zam < Hash; end
    end
    
    it "should work" do
      Zam.should descend_from(Hash)
    end
    
    it "should work for negative matching" do
      Zam.should_not descend_from(String)
    end
    
  end

  describe "should descend_from(...).immediately" do
    before(:each) do
      class Zam < Hash; end
      class Fot < Zam; end
    end
    
    it "should work" do
      Fot.should descend_from(Zam).immediately
    end
    
    it "should work for negative matching when the class does not descend at all" do
      Fot.should_not descend_from(String).immediately
    end
    
    it "should work for negative matching when the class does not descend immediately" do
      Fot.should_not descend_from(Hash).immediately
    end
  end
  
end