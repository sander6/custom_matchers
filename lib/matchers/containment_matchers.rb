module Sander6
  module CustomMatchers

    module ContainmentMatcherSharedMethods
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
    end

    module ContainmentMatcherMultiplierMethods
      
      def once
        MultipleContainmentMatcher.new(
          [@expected_collection, {:times => 1}],
          [@unexpected_collection, {:times => 1, :unexpected => true}]
        )
      end
      
      def twice
        MultipleContainmentMatcher.new(
          [@expected_collection, {:times => 2}],
          [@unexpected_collection, {:times => 2, :unexpected => true}]
        )
      end
      
      def thrice
        MultipleContainmentMatcher.new(
          [@expected_collection, {:times => 3}],
          [@unexpected_collection, {:times => 3, :unexpected => true}]
        )
      end
      
      def more_than(number = nil)
        opts = number.nil? ? { :expect_more_than => true } : { :lower => number + 1 }
        MultipleContainmentMatcher.new(
          [@expected_collection, opts],
          [@unexpected_collection, opts.merge({:unexpected => true})]
        )
      end
      
      def less_than(number = nil)
        opts = number.nil? ? { :expect_less_than => true } : { :upper => number - 1 }
        MultipleContainmentMatcher.new(
          [@expected_collection, opts],
          [@unexpected_collection, opts.merge({:unexpected => true})]          
        )
      end
      
      def at_least(number = nil)
        opts = number.nil? ? { :expect_at_least => true } : { :lower => number }
        MultipleContainmentMatcher.new(
          [@expected_collection, opts],
          [@unexpected_collection, opts.merge({:unexpected => true})]
        )
      end
      alias_method :no_less_than, :at_least
      
      def at_most(number = nil)
        opts = number.nil? ? { :expect_at_most => true } : { :upper => number }
        MultipleContainmentMatcher.new(
          [@expected_collection, opts],
          [@unexpected_collection, opts.merge({:unexpected => true})]
        )
      end
      alias_method :no_more_than, :at_most    
    end
  
    class ContainmentMatcher
      include ContainmentMatcherSharedMethods
      include ContainmentMatcherMultiplierMethods
      
      def initialize(collection)
        @expected_collection = collection
        @unexpected_collection = []
      end
    
      def exactly(number = nil)
        unless number
          CustomMatchers::ExactContainmentMatcher.new(@expected_collection)
        else
          MultipleContainmentMatcher.new(
            [@expected_collection, {:times => number}],
            [@unexpected_collection, {:times => number, :unexpected => true}]
          )
        end
      end
      alias_method :and_nothing_else, :exactly
    
      def in_order
        CustomMatchers::OrderedContainmentMatcher.new(@expected_collection)
      end
      
      def successively
        CustomMatchers::SuccessiveContainmentMatcher.new(@expected_collection)
      end

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
      include ContainmentMatcherSharedMethods
      include ContainmentMatcherMultiplierMethods
      
      def initialize(collection)
        @collection = collection
      end
      
      def in_order
        ExactSuccessiveContainmentMatcher.new(@collection)
      end
      alias_method :successively, :in_order
      
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
    
    class OrderedContainmentMatcher
      def initialize(collection)
        @collection = collection
      end
      
      def exactly
        ExactSuccessiveContainmentMatcher.new(@collection)
      end
      alias_method :and_nothing_else, :exactly
      
      def matches?(other)
        @other = other
        idx = 0
        @collection.all? do |elem|
          if @other[idx..-1].include?(elem)
            idx = @other.index(elem)
          else
            false
          end
        end
      end
      
      def failure_message
        "Expected #{@other.inspect} to contain #{@collection.inspect} in order, but it didn't!"
      end
      
      def negative_failure_message
        "Expected #{@other.inspect} not to contain #{@collection.inspect} in order, but it did!"        
      end
    end
    
    class SuccessiveContainmentMatcher
      def initialize(collection)
        @collection = collection
      end
      
      def exactly
        ExactSuccessiveContainmentMatcher.new(@collection)
      end
      alias_method :and_nothing_else, :exactly
      
      def matches?(other)
        @other = other
        successively_contains?(@collection, @other)
      end
      
      def successively_contains?(collection, other)
        idx = other.index(collection.first)
        if idx
          if other[idx,collection.size] == collection
            true
          else
            successively_contains?(collection, other[idx+1..-1])
          end
        else
          false
        end
      end
      
      def failure_message
        "Expected #{@other.inspect} to contain #{@collection.inspect} successively, but it didn't!"
      end
      
      def negative_failure_message
        "Expected #{@other.inspect} not to contain #{@collection.inspect} successively, but it did!"
      end
    end
    
    class ExactSuccessiveContainmentMatcher
      def initialize(collection)
        @collection = collection
      end
      
      def matches?(other)
        @other = other
        @other == @collection
      end
      
      def failure_message
        "Expected #{@other.inspect} to exactly contain #{@collection.inspect} successively, but it didn't!"
      end
      
      def negative_failure_message
        "Expected #{@other.inspect} not to exactly contain #{@collection.inspect} successively, but it did!"
      end      
    end
    
    class MultipleContainmentMatcher
      
      def initialize(*expectations)
        @expectations = []
        expectations.collect { |collection, opts| add_expectation(collection, opts) }
        @current_expectation = @expectations.last
      end
      
      def exactly(number)
        @current_expectation.times(number)
        self
      end
      
      def once
        @current_expectation.times(1)
        self
      end
      
      def twice
        @current_expectation.times(2)
        self
      end
      
      def thrice
        @current_expectation.times(3)
      end
            
      def times(number = nil)
        self
      end      
      alias_method :time, :times
   
      def and(*objs)
        add_expectation(objs, :times => 1)
        self
      end
      alias_method :and_also, :and
      
      def and_not(*objs)
        add_expectation(objs, :times => 1, :unexpected => true)
        self
      end
      alias_method :but_not, :and_not
      
      def matches?(other)
        @other = other
        @expectations.all? { |exp| exp.matches?(other) }
      end
      
      def failure_message
        "Bzzzt!"
      end
      
      def negative_failure_message
        "Bzzzt!"
      end
      
      private
      
      def add_expectation(collection, opts = {})
        exp = MultipleContainmentMatcherExpectation.new(collection, opts)
        @expectations << exp
        @current_expectation = exp
      end
    end
    
    class MultipleContainmentMatcherExpectation
      def initialize(collection, opts = {})
        @collection = collection
        @times      = opts.delete(:times) || 1
        @unexpected = opts.delete(:unexpected).nil? ? false : opts.delete(:unexpected)
        @lower      = opts.delete(:lower)
        @upper      = opts.delete(:upper)
        @opts       = opts
      end
      
      def times(number)
        if @opts[:expect_more_than]
          @lower = number - 1
        elsif @opts[:expect_less_than]
          @upper = number + 1
        elsif @opts[:expect_at_least]
          @lower = number
        elsif @opts[:expect_at_most]
          @upper = number
        else
          @times = number
        end
      end
      
      def matches?(other)
        if !@lower && !@upper
          @collection.all? { |e| other.select { |o| o == e}.size == @times}
        elsif !@lower && @upper
          @collection.all? { |e| other.select { |o| o == e}.size <= @upper}
        elsif @lower && !@upper
          @collection.all? { |e| other.select { |o| o == e}.size >= @lower}          
        else
          @collection.all? { |e| (@lower..@upper) === other.select { |o| o == e }.size }
        end
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