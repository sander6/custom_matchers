module Sander6
  module CustomMatchers

    module AllMatcherExtensions
      # Some more handy aliases for common things.

      def be_a(klass)
        @conditions = Proc.new { |o| o.is_a?(klass) }
        self
      end

      def be_an_instance_of(klass)
        @conditions = Proc.new { |o| o.instance_of?(klass) }
        self
      end
      alias_method :be_instances_of, :be_an_instance_of

      def contain(*elements)
        @conditions = Proc.new { |o| elements.all? { |e| o.include?(e) } }
        self
      end

      def ==(expected)
        @conditions = Proc.new { |o| o == expected }
        self
      end
      
      def ===(expected)
        @conditions = Proc.new { |o| o === expected }
        self
      end
      
      def <(expected)
        @conditions = Proc.new { |o| o < expected }
        self
      end
      
      def <=(expected)
        @conditions = Proc.new { |o| o <= expected }
        self
      end
      
      def >(expected)
        @conditions = Proc.new { |o| o > expected }
        self
      end
      
      def >=(expected)
        @conditions = Proc.new { |o| o >= expected }
        self
      end
      
      def =~(expected)
        @conditions = Proc.new { |o| o =~ expected }
        self
      end
      alias_method :match, :=~
      
      # Gives access to a number of handy, Englishy constuctions such as
      # should all.be_true
      # should all.be_empty
      # should all.have_key(:key)
      # should all.respond_to(:method)
      # should all.include(object)
      def method_missing(name, *args, &block)
        @conditions = case name.to_s
        when /^be_(an?_)?(.+)$/
          if $2 == "true" || $2 == "false"
            eval($2) ? Proc.new { |o| !!o } : Proc.new { |o| !o } # This line is cute.
          else
            Proc.new { |o| o.__send__(:"#{$2}?", *args) }
          end
        when /^have_(.+)$/
          Proc.new { |o| o.__send__(:"has_#{$1}?", *args) }
        else
          Proc.new { |o| o.__send__(:"#{name}?", *args) }
        end
        self
      end
    end

    class AllMatcher
      include Sander6::CustomMatchers::AllMatcherExtensions
      
      def initialize(&conditions)
        @include_be = false
        @conditions = conditions
      end
    
      def be(&block)
        @include_be = true
        @conditions = block
        self
      end
      
      def be_the_same
        Sander6::CustomMatchers::CollectionMemberEqualityMatcher.new
      end
      
      def be_different
        Sander6::CustomMatchers::NegativeCollectionMemberEqualityMatcher.new
      end
    
      def not(&block)
        Sander6::CustomMatchers::NegativeAllMatcher.new(&block)
      end
    
      def matches?(collection)
        @collection = collection
        @collection.all?(&@conditions)
      end
          
      def failure_message
        if @conditions.is_a?(Symbol)
          "Expected #{@collection.inspect} to all #{"be " if @include_be}#{@conditions.to_s.chomp("?")}, but that wasn't the case.\n" +
          "Failing items: #{@collection.reject(&@conditions).inspect}"
        else
          "Expected #{@collection.inspect} to all pass, but that wasn't the case.\n" +
          "Failing items: #{@collection.reject(&@conditions).inspect}"        
        end
      end
    
      def negative_failure_message
        if @conditions.is_a?(Symbol)
          "Expected #{@collection.inspect} to not all #{"be " if @include_be}#{@conditions.to_s.chomp("?")}, but that wasn't the case.\n" +
          "Passing items: #{@collection.select(&@conditions).inspect}"
        else
          "Expected at least one item in #{@collection.inspect} to fail, but that wasn't the case.\n" +
          "Passing items: #{@collection.select(&@conditions).inspect}"
        end
      end
      
    end
  
    class NegativeAllMatcher   
      include Sander6::CustomMatchers::AllMatcherExtensions

      def initialize(&conditions)
        @include_be = false
        @conditions = conditions
      end
    
      def be(&block)
        @include_be = true
        @conditions = block
        self
      end
    
      def be_the_same
        Sander6::CustomMatchers::NegativeCollectionMemberEqualityMatcher.new
      end

      def be_different
        Sander6::CustomMatchers::CollectionMemberEqualityMatcher.new
      end
        
      def matches?(collection)
        @collection = collection
        !@collection.any?(&@conditions)
      end
    
      def failure_message
        if @conditions.is_a?(Symbol)
          "Expected at least one item in #{@collection.inspect} to not #{"be " if @include_be}#{@conditions.to_s.chomp("?")}, but that wasn't the case.\n" +
          "Passing items: #{@collection.reject(&@conditions).inspect}"
        else
          "Expected #{@collection.inspect} to all fail, but that wasn't the case.\n" +
          "Passing items: #{@collection.reject(&@conditions).inspect}"        
        end
      end
    
      def negative_failure_message
        if @conditions.is_a?(Symbol)
          "Expected #{@collection.inspect} to all #{"be " if @include_be}#{@conditions.to_s.chomp("?")}, but that wasn't the case.\n" +
          "Passing items: #{@collection.select(&@conditions).inspect}"
        else
          "Expected at least one item in #{@collection.inspect} to pass, but that wasn't the case.\n" +
          "Passing items: #{@collection.select(&@conditions).inspect}"
        end
      end
    end
    
    def all(&block)
      Sander6::CustomMatchers::AllMatcher.new(&block)
    end
    
    def all_not(&block)
      Sander6::CustomMatchers::NegativeAllMatcher.new(&block)
    end
    
  end
end