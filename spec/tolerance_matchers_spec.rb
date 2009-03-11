require File.dirname(__FILE__) + '/../lib/custom_matchers'
require File.dirname(__FILE__) + '/spec_helper'

describe Sander6::CustomMatchers::ToleranceMatcher do

  describe "#be_within" do
    it "should work" do
      1.should be_within(2).of(3)
    end
    
    it "should work for negative matching" do
      1.should_not be_within(2).of(10)
    end
  end
  
end