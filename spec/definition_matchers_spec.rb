require File.dirname(__FILE__) + '/../lib/custom_matchers'
require File.dirname(__FILE__) + '/spec_helper'

describe Sander6::CustomMatchers::InstanceVariableDefinitionMatcher do

  describe "should have_instance_variable(...)" do
    before(:each) do
      @thing = OpenStruct.new({ :name => "Bumpy" })
      @thing.instance_variable_set(:@chum, 10)
    end
    
    it "should work" do
      @thing.should have_instance_variable(:@chum)
    end
    
    it "should work for negative matching" do
      @thing.should_not have_instance_variable(:@zoobazz)
    end

    it "should be aliased as #have_ivar" do
      @thing.should have_ivar(:@chum)
    end
    
    describe "chaining expectations" do
      before do
        @borko = [1, 2, 3]
        class << @borko
          def funtimes!
            self.first
          end
        end
        @thing.instance_variable_set(:@chum, @borko)
      end
      
      it "should work" do
        @thing.should have_instance_variable(:@chum).that.is_an_instance_of(Array).and.contains(1, 2).and.responds_to(:funtimes!)
      end
      
      it "should work for negative matching" do
        @thing.should_not have_instance_variable(:@chum).that.is_an_instance_of(Array).and.contains(0).and.responds_to(:funtimes!)
      end
    end
    
    describe "with class matching" do      
      describe "with is_a(klass)" do
        it "should work" do
          @thing.should have_instance_variable(:@chum).that.is_a(Fixnum)
        end
        
        it "should work for negative matching" do
          @thing.should_not have_instance_variable(:@chum).that.is_a(Hash)
        end
      end
      
      describe "with is_an_instance_of(klass)" do
        it "should work" do
          @thing.should have_instance_variable(:@chum).that.is_an_instance_of(Fixnum)
        end
        
        it "should work for negative matching" do
          @thing.should_not have_instance_variable(:@chum).that.is_an_instance_of(Hash)
        end
      end

      describe "with is_a_kind_of(klass)" do
        it "should work" do
          @thing.should have_instance_variable(:@chum).that.is_a_kind_of(Fixnum)
        end
        
        it "should work for negative matching" do
          @thing.should_not have_instance_variable(:@chum).that.is_a_kind_of(Hash)
        end
      end
    end
    
    describe "with containment matching" do
      before do
        @thing.instance_variable_set(:@wootles, [ 1, 2, 3])
      end
      
      it "should work" do
        @thing.should have_instance_variable(:@wootles).that.includes(1)
      end
      
      it "should work for negative matching" do
        @thing.should_not have_instance_variable(:@wootles).that.includes(0)
      end
      
      it "should be aliased as #contains" do
        @thing.should have_instance_variable(:@wootles).that.contains(1)
      end
      
      it "should work for multiple arguments" do
        @thing.should have_instance_variable(:@wootles).that.contains(1, 2, 3)
      end
    end
    
    describe "with method response matching" do
      it "should work" do
        @thing.should have_instance_variable(:@chum).that.responds_to(:+)
      end
      
      it "should work for negative matching" do
        @thing.should_not have_instance_variable(:@chum).that.responds_to(:stringify_keys!)
      end
    end
    
    describe "with value matching" do
      describe "with ==" do
        it "should work" do
          @thing.should have_instance_variable(:@chum) == 10
        end
        
        it "should work for negative matching" do
          @thing.should_not have_instance_variable(:@chum) == 2694
        end
        
        it "should be aliased as #with_value" do
          @thing.should have_instance_variable(:@chum).with_value(10)
        end
      end

      describe "with ===" do
        it "should work" do
          @thing.should have_instance_variable(:@chum) === 10
        end
        
        it "should work for negative matching" do
          @thing.should_not have_instance_variable(:@chum) === 2694
        end
      end

      describe "with <" do
        it "should work" do
          @thing.should have_instance_variable(:@chum) < 2694
        end
        
        it "should work for negative matching" do
          @thing.should_not have_instance_variable(:@chum) < 3
        end
      end

      describe "with <=" do
        it "should work" do
          @thing.should have_instance_variable(:@chum) <= 10
        end
        
        it "should work for negative matching" do
          @thing.should_not have_instance_variable(:@chum) <= 3
        end
      end

      describe "with >" do
        it "should work" do
          @thing.should have_instance_variable(:@chum) > 3
        end
        
        it "should work for negative matching" do
          @thing.should_not have_instance_variable(:@chum) > 2694
        end
      end

      describe "with >=" do
        it "should work" do
          @thing.should have_instance_variable(:@chum) >= 10
        end
        
        it "should work for negative matching" do
          @thing.should_not have_instance_variable(:@chum) >= 2694
        end
      end
    end
    
    describe "with string matching" do
      before do
        @thing.instance_variable_set(:@wootles, "butterscotch")
      end
      
      it "should work" do
        @thing.should have_instance_variable(:@wootles).that =~ /^butt/
      end
      
      it "should work for negative matching" do
        @thing.should_not have_instance_variable(:@wootles).that =~ /butt$/
      end
    end
    
    describe "with arbitrary condition matching" do
      it "should work" do
        @thing.should have_instance_variable(:@chum).that { |o| o + 10 <= 100 }
      end
      
      it "should work for negative matching" do
        @thing.should_not have_instance_variable(:@chum).that { |o| o + 0 != o }
      end
      
      it "should work with symbols" do
        @thing.should_not have_instance_variable(:@chum).that.is(&:zero?)
      end
    end    
  end  
end

describe Sander6::CustomMatchers::ClassVariableDefinitionMatcher do

  describe "#have_class_variable(...)" do
    before(:each) do
      String.__send__(:class_variable_set, :@@chum, 10)
    end

    it "should work" do
      String.should have_class_variable(:@@chum)
    end

    it "should work for negative matching" do
      String.should_not have_class_variable(:@@zoobazz)
    end

    it "should be aliased as #have_cvar" do
      String.should have_cvar(:@@chum)
    end

    describe "with class matching" do      
      describe "with is_a(klass)" do
        it "should work" do
          String.should have_class_variable(:@@chum).that.is_a(Fixnum)
        end

        it "should work for negative matching" do
          String.should_not have_class_variable(:@@chum).that.is_a(Hash)
        end
      end

      describe "with is_an_instance_of(klass)" do
        it "should work" do
          String.should have_class_variable(:@@chum).that.is_an_instance_of(Fixnum)
        end

        it "should work for negative matching" do
          String.should_not have_class_variable(:@@chum).that.is_an_instance_of(Hash)
        end
      end

      describe "with is_a_kind_of(klass)" do
        it "should work" do
          String.should have_class_variable(:@@chum).that.is_a_kind_of(Fixnum)
        end

        it "should work for negative matching" do
          String.should_not have_class_variable(:@@chum).that.is_a_kind_of(Hash)
        end
      end
    end

    describe "with containment matching" do
      before do
        String.__send__(:class_variable_set, :@@wootles, [ 1, 2, 3])
      end

      it "should work" do
        String.should have_class_variable(:@@wootles).that.includes(1)
      end

      it "should work for negative matching" do
        String.should_not have_class_variable(:@@wootles).that.includes(0)
      end

      it "should be aliased as #contains" do
        String.should have_class_variable(:@@wootles).that.contains(1)
      end

      it "should work for multiple arguments" do
        String.should have_class_variable(:@@wootles).that.contains(1, 2, 3)
      end
    end

    describe "with method response matching" do
      it "should work" do
        String.should have_class_variable(:@@chum).that.responds_to(:+)
      end

      it "should work for negative matching" do
        String.should_not have_class_variable(:@@chum).that.responds_to(:stringify_keys!)
      end
    end

    describe "with value matching" do
      describe "with ==" do
        it "should work" do
          String.should have_class_variable(:@@chum) == 10
        end

        it "should work for negative matching" do
          String.should_not have_class_variable(:@@chum) == 2694
        end

        it "should be aliased as #with_value" do
          String.should have_class_variable(:@@chum).with_value(10)
        end
      end

      describe "with ===" do
        it "should work" do
          String.should have_class_variable(:@@chum) === 10
        end

        it "should work for negative matching" do
          String.should_not have_class_variable(:@@chum) === 2694
        end
      end

      describe "with <" do
        it "should work" do
          String.should have_class_variable(:@@chum) < 2694
        end

        it "should work for negative matching" do
          String.should_not have_class_variable(:@@chum) < 3
        end
      end

      describe "with <=" do
        it "should work" do
          String.should have_class_variable(:@@chum) <= 10
        end

        it "should work for negative matching" do
          String.should_not have_class_variable(:@@chum) <= 3
        end
      end

      describe "with >" do
        it "should work" do
          String.should have_class_variable(:@@chum) > 3
        end

        it "should work for negative matching" do
          String.should_not have_class_variable(:@@chum) > 2694
        end
      end

      describe "with >=" do
        it "should work" do
          String.should have_class_variable(:@@chum) >= 10
        end

        it "should work for negative matching" do
          String.should_not have_class_variable(:@@chum) >= 2694
        end
      end
    end

    describe "with string matching" do
      before do
        String.__send__(:class_variable_set, :@@wootles, "butterscotch")
      end

      it "should work" do
        String.should have_class_variable(:@@wootles).that =~ /^butt/
      end

      it "should work for negative matching" do
        String.should_not have_class_variable(:@@wootles).that =~ /butt$/
      end
    end

    describe "with arbitrary condition matching" do
      it "should work" do
        String.should have_class_variable(:@@chum).that { |o| o + 10 <= 100 }
      end

      it "should work for negative matching" do
        String.should_not have_class_variable(:@@chum).that { |o| o + 0 != o }
      end

      it "should work with symbols" do
        String.should_not have_class_variable(:@@chum).that.is(&:zero?)
      end
    end    
  end  
end

describe Sander6::CustomMatchers::ConstantDefinitionMatcher do
  
  describe "should have_constant(...)" do
    before(:each) do
      String.__send__(:const_set, :CHUM, 10) unless String.const_defined?(:CHUM)
    end

    it "should work" do
      String.should have_constant(:CHUM)
    end

    it "should work for negative matching" do
      String.should_not have_constant(:ZOOBAZZ)
    end

    it "should be aliased as #have_const" do
      String.should have_const(:CHUM)
    end

    describe "with class matching" do      
      describe "with is_a(klass)" do
        it "should work" do
          String.should have_constant(:CHUM).that.is_a(Fixnum)
        end

        it "should work for negative matching" do
          String.should_not have_constant(:CHUM).that.is_a(Hash)
        end
      end

      describe "with is_an_instance_of(klass)" do
        it "should work" do
          String.should have_constant(:CHUM).that.is_an_instance_of(Fixnum)
        end

        it "should work for negative matching" do
          String.should_not have_constant(:CHUM).that.is_an_instance_of(Hash)
        end
      end

      describe "with is_a_kind_of(klass)" do
        it "should work" do
          String.should have_constant(:CHUM).that.is_a_kind_of(Fixnum)
        end

        it "should work for negative matching" do
          String.should_not have_constant(:CHUM).that.is_a_kind_of(Hash)
        end
      end
    end

    describe "with containment matching" do
      before do
        String.__send__(:const_set, :WOOTLES, [ 1, 2, 3]) unless String.const_defined?(:WOOTLES)
      end

      it "should work" do
        String.should have_constant(:WOOTLES).that.includes(1)
      end

      it "should work for negative matching" do
        String.should_not have_constant(:WOOTLES).that.includes(0)
      end

      it "should be aliased as #contains" do
        String.should have_constant(:WOOTLES).that.contains(1)
      end

      it "should work for multiple arguments" do
        String.should have_constant(:WOOTLES).that.contains(1, 2, 3)
      end
    end

    describe "with method response matching" do
      it "should work" do
        String.should have_constant(:CHUM).that.responds_to(:+)
      end

      it "should work for negative matching" do
        String.should_not have_constant(:CHUM).that.responds_to(:stringify_keys!)
      end
    end

    describe "with value matching" do
      describe "with ==" do
        it "should work" do
          String.should have_constant(:CHUM) == 10
        end

        it "should work for negative matching" do
          String.should_not have_constant(:CHUM) == 2694
        end

        it "should be aliased as #with_value" do
          String.should have_constant(:CHUM).with_value(10)
        end
      end

      describe "with ===" do
        it "should work" do
          String.should have_constant(:CHUM) === 10
        end

        it "should work for negative matching" do
          String.should_not have_constant(:CHUM) === 2694
        end
      end

      describe "with <" do
        it "should work" do
          String.should have_constant(:CHUM) < 2694
        end

        it "should work for negative matching" do
          String.should_not have_constant(:CHUM) < 3
        end
      end

      describe "with <=" do
        it "should work" do
          String.should have_constant(:CHUM) <= 10
        end

        it "should work for negative matching" do
          String.should_not have_constant(:CHUM) <= 3
        end
      end

      describe "with >" do
        it "should work" do
          String.should have_constant(:CHUM) > 3
        end

        it "should work for negative matching" do
          String.should_not have_constant(:CHUM) > 2694
        end
      end

      describe "with >=" do
        it "should work" do
          String.should have_constant(:CHUM) >= 10
        end

        it "should work for negative matching" do
          String.should_not have_constant(:CHUM) >= 2694
        end
      end
    end

    describe "with string matching" do
      before do
        String.__send__(:const_set, :NOODLES, "butterscotch") unless String.const_defined?(:NOODLES)
      end

      it "should work" do
        String.should have_constant(:NOODLES).that =~ /^butt/
      end

      it "should work for negative matching" do
        String.should_not have_constant(:NOODLES).that =~ /butt$/
      end
    end

    describe "with arbitrary condition matching" do
      it "should work" do
        String.should have_constant(:CHUM).that { |o| o + 10 <= 100 }
      end

      it "should work for negative matching" do
        String.should_not have_constant(:CHUM).that { |o| o + 0 != o }
      end

      it "should work with symbols" do
        String.should_not have_constant(:CHUM).that.is(&:zero?)
      end
    end    
  end
end