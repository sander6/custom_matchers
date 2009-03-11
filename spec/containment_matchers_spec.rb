require File.dirname(__FILE__) + '/../lib/custom_matchers'
require File.dirname(__FILE__) + '/spec_helper'

describe Sander6::CustomMatchers::ContainmentMatcher do

  describe "should contain(...)" do

    it "should work for arrays" do
      [1, 2, 3].should contain(1)
    end
    
    it "should work for strings" do
      "peanut butter and jelly".should contain("butt")
    end
    
    it "should work for classes and modules" do
      Object.should contain(Kernel)
    end
    
    it "should accept multiple arguments" do
      [1, 2, 3].should contain(1, 2)
    end

    it "should work for negative matching" do
      [1, 2, 3].should_not contain(0)
    end

    describe "should contain(...).and(...)" do
      it "should add to the expected collection" do
        [1, 2, 3].should contain(1).and(2)
      end
      
      it "should accept multiple arguments" do
        [1, 2, 3].should contain(1).and(2, 3)
      end
      
      it "should be aliases as #and_also" do
        [1, 2, 3].should contain(1).and_also(2)
      end
      
      it "should work for negative matching as well" do
        [1, 2, 3].should_not contain(0).and(4)
      end
    end
    
    describe "should contain(...).and_not(...)" do
      it "should set a negative expectation for containment" do
        [1, 2, 3].should contain(1).and_not(4)
      end
      
      it "should accept multiple arguments" do
        [1, 2, 3].should contain(1, 2, 3).and_not(4, 5, 6)
      end
      
      it "should be aliases as #but_not" do
        [1, 2, 3].should contain(1).but_not(4)
      end
      
      it "should work for negative matching as well" do
        [1, 2, 3].should_not contain(0).and_not(1)
      end
    end
    
    describe "should contain.an_element" do
      it "should return an Outside::CustomMatchers::DetectorMatcher" do
        contain.an_element.should be_an_instance_of(Sander6::CustomMatchers::DetectorMatcher)
      end
      
      it "should work and make nice grammatical sense" do
        [1, 2, 3].should contain.an_element.that.is_an_instance_of(Fixnum)
      end
      
      it "should work for negative matching and make nice grammatical sense" do
        [1, 2, 3].should_not contain.an_element.that.is_an_instance_of(StandardError)
      end
      
      it "should be aliased as #some_element" do
        [1, 2, 3].should contain.some_element.that_is > 2
      end
      
      it "should work for detecting nil" do
        [1, 2, nil].should contain.an_element.that.is_nil
      end
      
      it "should work for negatively detecting nil" do
        [1, 2, 3].should_not contain.an_element.that.is_nil
      end
      
      it "should work for detecting false" do
        [1, 2, false].should contain.an_element.that.is_false
      end
      
      it "should work for negatively detecting false" do
        [1, 2, 3].should_not contain.an_element.that.is_false
      end
    end
  end
  
end

describe Sander6::CustomMatchers::ExactContainmentMatcher do

  describe "should contain(...).exactly" do
    it "should match exact containment for arrays" do
      [1, 2, 3].should contain(2, 1, 3).exactly
    end
  
    it "should match exact containment for strings" do
      "peanut butter and jelly".should contain("peanut butter and jelly").exactly
    end
    
    it "should be aliased as #and_nothing_else" do
      [1, 2, 3].should contain(1, 2, 3).and_nothing_else
    end
  
    it "should work for negative exact matching" do
      [1, 2, 3].should_not contain(1, 2).exactly
    end
  end
  
end