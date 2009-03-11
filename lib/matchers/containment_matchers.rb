module Sander6
  module CustomMatchers
  
    class ContainmentMatcher
      def initialize(collection)
        @expected_collection = collection
        @unexpected_collection = []
      end
    
      def exactly
        CustomMatchers::ExactContainmentMatcher.new(@expected_collection)
      end
      alias_method :and_nothing_else, :exactly
    
      def and(*objs)
        @expected_collection += objs
        self
      end
      alias_method :and_also, :and
    
      def and_not(*objs)
        @unexpected_collection += objs
        self
      end
      alias_method :but_not, :and_not

      def an_element
        Sander6::CustomMatchers::DetectorMatcher.new
      end
      alias_method :some_element, :an_element
    
      def matches?(other)
        # other here can be anything that responds to :include?
        @other = other
        @expected = @expected_collection.all? { |e| @other.include?(e) }
        @unexpected = !@unexpected_collection.any? { |e| @other.include?(e) }
        @expected && @unexpected
      end
    
      def failure_message
        case
        when !@expected && @unexpected
          "Expected #{@other.inspect} to contain #{@expected_collection.join(" and ")}, but it didn't!\n" + 
          "Missing stuff: #{@expected_collection.reject {|e| @other.include?(e) }.join(" and ")}"
        when @expected && !@unexpected
          "Expected #{@other.inspect} not to contain #{@unexpected_collection.join(" and ")}, but it did!\n" + 
          "Extra stuff: #{@unexpected_collection.select {|e| @other.include?(e) }.join(" and ")}"
        when @expected && @unexpected
          "Expected #{@other.inspect} to contain #{@expected_collection.join(" and ")}, " + 
          "and not to contain #{@unexpected_collection.join(" and ")}, but that wasn't the case!\n" + 
          "Missing stuff: #{@expected_collection.reject {|e| @other.include?(e) }.join(" and ")}"
          "Extra stuff: #{@unexpected_collection.select {|e| @other.include?(e) }.join(" and ")}"
        end
      end
    
      def negative_failure_message
        case
        when !@expected && @unexpected
          "Expected #{@other.inspect} not to contain #{@expected_collection.join(" and ")}, but it did!\n" + 
          "Extra stuff: #{@expected_collection.reject {|e| @other.include?(e) }.join(" and ")}"
        when @expected && !@unexpected
          "Expected #{@other.inspect} to contain #{@unexpected_collection.join(" and ")}, but it didn't!\n" + 
          "Missing stuff: #{@unexpected_collection.select {|e| @other.include?(e) }.join(" and ")}"
        when @expected && @unexpected
          "Expected #{@other.inspect} not to contain #{@expected_collection.join(" and ")}, " + 
          "and to contain #{@unexpected_collection.join(" and ")}, but that wasn't the case!\n" + 
          "Missing stuff: #{@unexpected_collection.reject {|e| @other.include?(e) }.join(" and ")}"
          "Extra stuff: #{@expected_collection.select {|e| @other.include?(e) }.join(" and ")}"
        end
      end
    end
  
    class ExactContainmentMatcher 
      def initialize(collection)
        @collection = collection
      end
    
      def matches?(other)
        @other = other
        @missing = @collection.reject { |e| @other.include?(e) }
        @extra = @other.reject { |e| @collection.include?(e) }
        @missing.empty? && @extra.empty?
      end
    
      def failure_message
        "Expected #{@other.inspect} to exactly contain #{@collection.inspect}, but it didn't!\n" +
        "Missing: #{@missing.inspect}\n" +
        "Extra: #{@extra.inspect}"
      end
    
      def negative_failure_message
        "Expected #{@other.inspect} not to exactly contain #{@collection.inspect}, but it did!"
      end
    end
    
    def contain(*elements)
      Sander6::CustomMatchers::ContainmentMatcher.new(elements)
    end
    
    def exactly_contain(*elements)
      Sander6::CustomMatchers::ExactContainmentMatcher.new(elements)
    end
    alias_method :only_contain, :exactly_contain
    
  end
end