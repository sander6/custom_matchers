require File.dirname(__FILE__) + '/../lib/custom_matchers'
require File.dirname(__FILE__) + '/spec_helper'

describe Sander6::CustomMatchers::DetectorMatcher do

  describe "should have_an_element(...)" do
    it "should work" do
      [1, 2, 3].should have_an_element { |e| e > 2 }
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not have_an_element { |e| e > 10 }
    end
    
    it "should be aliased as #have_some_element" do
      [1, 2, 3].should have_some_element { |e| e > 2 }
    end
  end
  
  describe "should have_an_element.where(...)" do
    it "should work" do
      [1, 2, 3].should have_an_element.where { |e| e > 2 }
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not have_an_element.where { |e| e > 10 }
    end
    
    it "should be aliased as #such_that" do
      [1, 2, 3].should have_an_element.such_that { |e| e > 2 }
    end
    
    it "should be aliased as #that_is" do
      [1, 2, 3].should have_an_element.that_is { |e| e > 2 }
    end
    
    it "should accept a symbol aliased to facilitate nice grammar" do
      [0, 1, 2].should have_an_element.that_is(&:zero?)
    end
  end
  
  describe "should have_an_element.that(...)" do
    it "should simply return self" do
      matcher = have_an_element
      matcher.should eql(matcher.that)
    end
  end
  
  describe "should have_an_element.that.is_a(...)" do
    it "should work" do
      [1, 2, nil].should have_an_element.that.is_a(Fixnum)
    end
    
    it "should work for negative matching" do
      [1, 2, nil].should_not have_an_element.that.is_a(String)
    end
    
    it "should be aliased as #a to facilitate nice grammar" do
      [1, 2, nil].should have_an_element.that_is.a(Fixnum)
    end
  end
  
  describe "should have_an_element.that.responds_to(...)" do
    it "should work" do
      [1, 2, nil].should have_an_element.that.responds_to(:+)      
    end
    
    it "should work for negative matching" do
      [1, 2, nil].should_not have_an_element.that.responds_to(:extract_options!)
    end
  end
  
  describe "should have_an_element.that.includes(...)" do
    it "should work" do
      ["sunshine", "bubbles", "firecracker", "licorice"].should have_an_element.that.includes("crack")
    end
    
    it "should work for negative matching" do
      ["sunshine", "bubbles", "firecracker", "licorice"].should_not have_an_element.that.includes("lumps")
    end
  end
  
  describe "should have_an_element.that_is.true" do
    it "should work" do
      [1, 2, nil].should have_an_element.that_is.true      
    end
    
    it "should work for negative matching" do
      [nil, nil, false].should_not have_an_element.that_is.true
    end
  end
  
  describe "should have_an_element.that_is.false" do
    it "should work" do
      [1, 2, false].should have_an_element.that_is.false
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not have_an_element.that_is.false
    end
  end
  
  describe "should have_an_element.that_is ==" do
    it "should work" do
      [1, 2, 3].should have_an_element.that_is == 1
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not have_an_element.that_is == 10
    end
  end
  
  describe "should have_an_element.that_is ===" do
    it "should work" do
      [Fixnum, Hash, StandardError].should have_an_element.that_is === 1
    end
    
    it "should work for negative matching" do
      [Class, Hash, RuntimeError].should_not have_an_element.that_is === 10
    end
  end
  
  describe "should have_an_element.that_is <" do
    it "should work" do
      [1, 2, 3].should have_an_element.that_is < 2
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not have_an_element.that_is < 0
    end
  end
  
  describe "should have_an_element.that_is <=" do
    it "should work" do
      [1, 2, 3].should have_an_element.that_is <= 1
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not have_an_element.that_is <= 0
    end
  end
  
  describe "should have_an_element.that_is >" do
    it "should work" do
      [1, 2, 3].should have_an_element.that_is > 2
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not have_an_element.that_is > 10
    end
  end
  
  describe "should have_an_element.that_is >=" do
    it "should work" do
      [1, 2, 3].should have_an_element.that_is >= 3
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not have_an_element.that_is >= 10
    end
  end
  
  describe "should have_an_element.that_is =~" do
    it "should work" do
      ["sunshine", "bubbles", "firecracker", "licorice"].should have_an_element.that_is =~ /rice/
    end
    
    it "should work for negative matching" do
      ["sunshine", "bubbles", "firecracker", "licorice"].should_not have_an_element.that_is =~ /^$/
    end
    
    it "should be aliased as #matches" do
      ["sunshine", "bubbles", "firecracker", "licorice"].should have_an_element.that.matches(/rice/)
    end
  end

  describe "should have_an_element.that.is_(...)" do
    it "should work" do
      [{ :sunshine => "bubbles"}, { :firecracker => "licorice"}, {}].should have_an_element.that.is_empty
    end
    
    it "should work for negative matching" do
      ["sunshine", "bubbles", "firecracker", "licorice"].should_not have_an_element.that.is_empty
    end        
  end
  
  describe "should have_an_element.that_is.an?_(...)" do
    it "should work" do
      [1, 2, nil].should have_an_element.that_is.an_instance_of(Fixnum)
    end
    
    it "should work for negative matching" do
      [1, 2, nil].should_not have_an_element.that_is.an_instance_of(String)
    end
  end
  
  describe "should have_an_element.that.(...)" do
    it "should work" do
      [{ :sunshine => "bubbles"}, { :firecracker => "licorice"}, {}].should have_an_element.that.has_key(:firecracker)
    end
    
    it "should work for negative matching" do
      [{ :sunshine => "bubbles"}, { :firecracker => "licorice"}, {}].should_not have_an_element.that.has_key(:gumdrops)
    end
  end
end