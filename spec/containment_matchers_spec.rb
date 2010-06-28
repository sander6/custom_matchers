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
  
    it "should be aliased as #and_nothing_else" do
      [1, 2, 3].should contain(1, 2, 3).and_nothing_else
    end
  
    it "should work for negative exact matching" do
      [1, 2, 3].should_not contain(1, 2).exactly
    end
  end
  
end

describe Sander6::CustomMatchers::OrderedContainmentMatcher do
  describe "should contain(...).in_order" do
    it "should match in-order containment for arrays" do
      [1,2,3,4,5].should contain(1,3,5).in_order
    end
    
    it "should work for negative matching" do
      [1,2,3,4,5].should_not contain(2,1,3).in_order
    end
  end
  
  describe "should contain(...).in_order.and_nothing_else" do
    it "should match in-order exact containment" do
      [1,2,3].should contain(1,2,3).in_order.and_nothing_else
    end
    
    it "should work for negative matching when the elements are not in order" do
      [1,2,3].should_not contain(2,1,3).in_order.and_nothing_else
    end
    
    it "should work for negative matching when there are missing elements" do
      [1,2,3].should_not contain(1,2,3,4).in_order.and_nothing_else
    end
    
    it "should work for negative matching when there are extra elements" do
      [1,2,3,4].should_not contain(1,2,3).in_order.and_nothing_else
    end
  end
end

describe Sander6::CustomMatchers::SuccessiveContainmentMatcher do
  describe "should contain(...).successively" do
    it "should match successive-ordered containment for arrays" do
      [1,2,3,4,5].should contain(2,3,4).successively
    end
    
    it "should work for negative matching" do
      [1,2,3,4,5].should_not contain(2,1,3).successively
    end
  end
  
  describe "should contain(...).successively.and_nothing_else" do
    it "should match in-order successive containment" do
      [1,2,3].should contain(1,2,3).successively.and_nothing_else
    end
    
    it "should work for negative matching when the elements are not in order" do
      [1,2,3].should_not contain(2,1,3).successively.and_nothing_else
    end
    
    it "should work for negative matching when there are missing elements" do
      [1,2,3].should_not contain(1,2,3,4).successively.and_nothing_else
    end
    
    it "should work for negative matching when there are extra elements" do
      [1,2,3,4].should_not contain(1,2,3).successively.and_nothing_else
    end
  end
end

describe Sander6::CustomMatchers::MultipleContainmentMatcher do
  
  describe "should contain(...).once" do
    it "should work" do
      [1, 2, 3].should contain(1).once
    end
    
    it "should work for negative matching" do
      [1, 1, 2].should_not contain(1).once
    end
    
    it "should work with multiple values" do
      [1, 2, 3].should contain(1, 2).once
    end
    
    it "should work with multiple values for negative matching" do
      [1, 1, 2, 2].should_not contain(1, 2).once
    end
  end
  
  describe "should contain(...).twice" do
    it "should work" do
      [1, 1, 3].should contain(1).twice
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not contain(1).twice
    end
    
    it "should work with multiple values" do
      [1, 1, 2, 2].should contain(1, 2).twice
    end
    
    it "should work with multiple values for negative matching" do
      [1, 1, 2, 3].should_not contain(1, 2).twice
    end
  end
  
  
  describe "should contain(...).thrice" do
    it "should work" do
      [1, 1, 1].should contain(1).thrice
    end
    
    it "should work for negative matching" do
      [1, 1, 2].should_not contain(1).thrice
    end
    
    it "should work with multiple values" do
      [1, 1, 1, 2, 2, 2].should contain(1, 2).thrice
    end
    
    it "should work with multiple values for negative matching" do
      [1, 1, 1, 2, 2].should_not contain(1, 2).thrice
    end
  end
  
  describe "should contain(...).exactly(#).times" do
    it "should work" do
      [1, 1, 1, 1].should contain(1).exactly(4).times
    end
    
    it "should work for negative matching" do
      [1, 2, 2, 2].should_not contain(1).exactly(4).times
    end
    
    it "should work with multiple values" do
      [1, 1, 1, 1, 2, 2, 2, 2].should contain(1, 2).exactly(4).times
    end
    
    it "should work with multiple values for negative matching" do
      [1, 1, 1, 2, 2, 2].should_not contain(1, 2).exactly(4).times
    end
  end
  
  describe "should contain(...).more_than(#).times" do
    it "should work" do
      [1, 1, 1, 2, 2, 3].should contain(1).more_than(2).times
    end
    
    it "should work for negative matching" do
      [1, 2, 2, 3, 3, 3].should_not contain(1).more_than(2).times
    end
    
    it "should work with multiple values" do
      [1, 1, 1, 2, 2, 2, 3].should contain(1, 2).more_than(2).times
    end
    
    it "should work with multiple values for negative matching" do
      [1, 1, 2, 2, 3, 3, 3].should_not contain(1, 2).more_than(2).times
    end
  end
  
  describe "should contain(...).less_than(#).times" do
    it "should work" do
      [1, 2, 2, 3, 3, 3].should contain(1).less_than(2).times
    end
    
    it "should work for negative matching" do
      [1, 1, 1, 2, 3].should_not contain(1).less_than(2).times
    end
    
    it "should work with multiple values" do
      [1, 1, 2, 2, 3, 3].should contain(1, 2).less_than(3).times
    end
    
    it "should work with multiple values for negative matching" do
      [1, 1, 1, 2, 2, 2, 3].should_not contain(1, 2).less_than(3).times
    end
  end
  
  describe "should contain(...).at_least(#).times" do
    it "should work" do
      [1, 1, 1, 2, 2].should contain(1).at_least(3).times
      [1, 1, 1, 1, 2].should contain(1).at_least(3).times
    end
    
    it "should work for negative matching" do
      [1, 1, 2, 2].should_not contain(1).at_least(3).times
    end
    
    it "should work with multiple values" do
      [1, 1, 1, 2, 2, 2].should contain(1, 2).at_least(3).times
    end
    
    it "should work with multiple values for negative matching" do
      [1, 1, 2, 2].should_not contain(1, 2).at_least(3).times
    end
  end
  
  describe "should contain(...).at_most(#).times" do
    it "should work" do
      [1, 1, 1, 2, 2, 3].should contain(1).at_most(3).times
    end
    
    it "should work for negative matching" do
      [1, 1, 1, 1, 2, 2].should_not contain(1).at_most(3).times
    end
    
    it "should work with multiple values" do
      [1, 1, 2, 2, 2].should contain(1, 2).at_most(3).times
    end
    
    it "should work with multiple values for negative matching" do
      [1, 1, 1, 1, 2, 2].should_not contain(1, 2).at_most(3).times
    end
  end
  
  describe "chaining counting expectations together" do
    it "should work" do
      [1, 1, 2, 2, 2, 3].should contain(1).at_least(2).times.and_also(2).exactly(3).times
    end
  end
end