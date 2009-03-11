require File.dirname(__FILE__) + '/../lib/custom_matchers'
require File.dirname(__FILE__) + '/spec_helper'

describe Sander6::CustomMatchers::CollectionMemberEqualityMatcher do

  describe "should all_be_the_same" do
    it "should work" do
      [1, 1, 1].should all_be_the_same
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not all_be_the_same
    end
  end

end

describe Sander6::CustomMatchers::NegativeCollectionMemberEqualityMatcher do
  
  describe "should all_not_be_the_same" do
    it "should work" do
      [1, 2, 3].should all_not_be_the_same
    end
    
    it "should work for negative matching" do
      [1, 1, 1].should_not all_not_be_the_same
    end
    
    it "should be aliased as all_be_different" do
      [1, 2, 3].should all_be_different
    end
  end

end