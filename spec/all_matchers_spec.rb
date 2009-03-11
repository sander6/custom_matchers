require File.dirname(__FILE__) + '/../lib/custom_matchers'
require File.dirname(__FILE__) + '/spec_helper'

describe Sander6::CustomMatchers::AllMatcher do

  describe "should all(...)" do
    it "should work" do
      [1, 2, 3].should all { |v| v < 10 }
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not all { |v| v < 3 }
    end
    
    it "should work when sent a symbol" do
      [nil, nil, nil].should all(&:nil?)
    end
    
    it "should work for negative matching when sent a symbol" do
      [nil, nil, 1].should_not all(&:nil?)
    end
  end
  
  describe "should all.be_the_same" do
    it "should return an Sander6::CustomMatchers::CollectionMemberEqualityMatcher" do
      all.be_the_same.should be_an_instance_of(Sander6::CustomMatchers::CollectionMemberEqualityMatcher)
    end
  end
  
  describe "should all.be_different" do
    it "should return an Sander6::CustomMatchers::NegativeCollectionMemberEqualityMatcher" do
      all.be_different.should be_an_instance_of(Sander6::CustomMatchers::NegativeCollectionMemberEqualityMatcher)
    end
  end
  
  describe "should all.be(...)" do
    it "should accept the dummy method #be to make nice grammatical sense when sent a symbol" do
      [nil, nil, nil].should all.be(&:nil?)
    end
    
    it "should work for negative matching" do
      [nil, nil, 0].should_not all.be(&:nil?)
    end
  end

  describe "should all.be_(...)" do
    it "should work" do
      [nil, nil, nil].should all.be_nil
    end
    
    it "should work for negative matching" do
      [nil, nil, 1].should_not all.be_nil
    end
  end
  
  describe "should all.be_true" do
    it "should work" do
      [1, true, :thing, "butter"].should all.be_true
    end
    
    it "should work for negative_matching" do
      [1, true, false, "butter"].should_not all.be_true
    end
  end
  
  describe "should all.be_false" do
    it "should work" do
      [false, nil, nil].should all.be_false
    end
    
    it "should work for negative matching" do
      [false, false, 1].should_not all.be_false
    end
  end
  
  describe "should all.have_(...)" do
    it "should work" do
      [{ :boogers => 1 }, { :boogers => 2 }, { :boogers => 3 }].should all.have_key(:boogers)
    end
    
    it "should work for negative matching" do
      [{ :boogers => 1 }, { :boogers => 2 }, { :tubers => 3 }].should_not all.have_key(:boogers)
    end
  end
  
  describe "should all.contain(...)" do
    it "should work" do
      ["butterscotch", "flying buttress", "rebuttal"].should all.contain("butt")
    end
    
    it "should accept multiple arguments" do
      ["butterscotch", "flying buttress", "rebuttal"].should all.contain("butt", "tt")
    end
    
    it "should work for negative matching" do
      ["butterscotch", "flying buttress", "rebuttal"].should_not all.contain("scotch")
    end

    it "should accept multiple arguments for negative matching" do
      ["butterscotch", "flying buttress", "rebuttal"].should_not all.contain("scotch", "lumps")
    end    
  end
  
  describe "should all ==" do
    it "should work" do
      [1, 1, 1].should all == 1
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not all == 1
    end
  end
  
  describe "should all ===" do
    it "should work" do
      [Fixnum, Integer, Numeric].should all === 1
    end
    
    it "should work for negative matching" do
      [Fixnum, Integer, Hash].should_not all === 1
    end
  end

  describe "should all >" do
    it "should work" do
      [1, 2, 3].should all.be > 0
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not all.be > 1
    end
  end

  describe "should all >=" do
    it "should work" do
      [1, 2, 3].should all.be >= 1
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not all.be >= 3
    end
  end

  describe "should all <" do
    it "should work" do
      [1, 2, 3].should all.be < 10
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not all.be < 1
    end
  end

  describe "should all <=" do
    it "should work" do
      [1, 2, 3].should all.be <= 3
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not all.be <= 1
    end
  end

  describe "should all =~" do
    it "should work" do
      ["butterscotch", "flying buttress", "rebuttal"].should all =~ /butt/
    end
    
    it "should work for negative matching" do
      ["butterscotch", "flying buttress", "rebuttal"].should_not all =~ /^butt$/
    end
    
    it "should be aliased as #match" do
      ["butterscotch", "flying buttress", "rebuttal"].should all.match(/butt/)
    end
  end

  describe "should all.be_a(...)" do
    it "should work" do
      [1, 1, 1].should all.be_a(Fixnum)
    end
    
    it "should work for negative matching" do
      [1, 2, "three"].should_not all.be_a(String)
    end
  end

  describe "should all.be_an_instance_of" do
    it "should work" do
      [1, 1, 1].should all.be_an_instance_of(Fixnum)
    end
    
    it "should work for negative matching" do
      [1, 2, "three"].should_not all.be_an_instance_of(String)
    end
    
    it "should be aliased as #be_instances_of" do
      [1, 2, 3].should all.be_instances_of(Fixnum)
    end
  end
  
end

describe Sander6::CustomMatchers::NegativeAllMatcher do

  describe "should all.not(...)" do
    it "should work" do
      [1, 2, 3].should all.not { |v| v > 10 }
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not all.not { |v| v > 2 }
    end
    
    it "should work when sent a symbol" do
      [1, 2, 3].should all.not(&:nil?)
    end
    
    it "should work for negative matching when sent a symbol" do
      [1, 2, nil].should_not all.not(&:nil?)
    end
  end
  
  describe "should all.not.be_the_same" do
    it "should return an Sander6::CustomMatchers::NegativeCollectionMemberEqualityMatcher" do
      all.not.be_the_same.should be_an_instance_of(Sander6::CustomMatchers::NegativeCollectionMemberEqualityMatcher)
    end
  end
    
  describe "should all.not.be_different" do
    it "should return an Sander6::CustomMatchers::CollectionMemberEqualityMatcher" do
      all.not.be_different.should be_an_instance_of(Sander6::CustomMatchers::CollectionMemberEqualityMatcher)
    end
  end

  describe "should all.not.be(...)" do
    it "should accept the dummy method #be to make nice grammatical sense" do
      [1, 2, 3].should all.not.be(&:nil?)
    end
    
    it "should work for negative matching" do
      [nil, nil, nil].should_not all.not.be(&:nil?)
    end
  end

  describe "should all.not.be_(...)" do
    it "should work" do
      [1, 1, 1].should all.not.be_nil
    end
    
    it "should work for negative matching" do
      [nil, 1, 1].should_not all.not.be_nil
    end
  end
  
  describe "should all.not.have_(...)" do
    it "should work" do
      [{ :boogers => 1 }, { :boogers => 2 }, { :boogers => 3 }].should all.not.have_key(:tubers)
    end
    
    it "should work for negative matching" do
      [{ :boogers => 1 }, { :boogers => 2 }, { :tubers => 3 }].should_not all.not.have_key(:boogers)
    end
  end

  describe "should all.not.contain(...)" do
    it "should work" do
      ["butterscotch", "flying buttress", "rebuttal"].should all.not.contain("lumps")
    end
    
    it "should accept multiple arguments" do
      ["butterscotch", "flying buttress", "rebuttal"].should all.not.contain("lumps", "dingleberry")
    end
    
    it "should work for negative matching" do
      ["butterscotch", "flying buttress", "rebuttal"].should_not all.not.contain("scotch")
    end
    
    it "should accept multiple arguments for negative matching" do
      ["butterscotch", "flying buttress", "rebuttal"].should_not all.not.contain("butt", "flying")
    end
  end  
  
  describe "should all.not ==" do
    it "should work" do
      [1, 1, 1].should all.not == 0
    end
    
    it "should work for negative matching" do
      [1, 1, 1].should_not all.not == 1
    end
  end
  
  describe "should all.not ===" do
    it "should work" do
      [Hash, String, Class].should all.not === 1
    end
    
    it "should work for negative matching" do
      [Hash, String, Integer].should_not all.not === 1
    end
  end

  describe "should all.not >" do
    it "should work" do
      [1, 2, 3].should all.not.be > 10
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not all.not.be > 1
    end
  end

  describe "should all.not >=" do
    it "should work" do
      [1, 2, 3].should all.not.be >= 10
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not all.not.be >= 3
    end
  end

  describe "should all.not <" do
    it "should work" do
      [1, 2, 3].should all.not.be < 0
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not all.not.be < 2
    end
  end

  describe "should all.not <=" do
    it "should work" do
      [1, 2, 3].should all.not.be <= 0
    end
    
    it "should work for negative matching" do
      [1, 2, 3].should_not all.not.be <= 1
    end
  end

  describe "should all.not =~" do
    it "should work" do
      ["butterscotch", "flying buttress", "rebuttal"].should all.not =~ /lumps/
    end
    
    it "should work for negative matching" do
      ["butterscotch", "flying buttress", "rebuttal"].should_not all.not =~ /butt.?r/
    end
    
    it "should be aliased as #match" do
      ["butterscotch", "flying buttress", "rebuttal"].should all.not.match(/lumps/)
    end
  end

  describe "should all.not.be_a(...)" do
    it "should work" do
      [1, 1, 1].should all.not.be_a(String)
    end
    
    it "should work for negative matching" do
      [1, 2, "three"].should_not all.not.be_a(String)
    end
  end

  describe "should all.not.be_an_instance_of" do
    it "should work" do
      [1, 1, 1].should all.not.be_an_instance_of(String)
    end
    
    it "should work for negative matching" do
      [1, 2, "three"].should_not all.not.be_an_instance_of(String)
    end
    
    it "should be aliased as #be_instances_of" do
      [1, 2, 3].should all.not.be_instances_of(String)
    end
  end
  
end