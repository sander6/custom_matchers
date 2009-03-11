module Sander6
  module CustomMatchers
    
    class DetectorMatcher
      def initialize(&block)
        @detector = block
      end
      
      def where(&block)
        @detector = block
        self
      end
      alias_method :such_that, :where
      alias_method :that_is, :where
      
      # A pass-through method for nice grammar.
      def that
        self
      end
      
      def matches?(collection)
        @collection = collection
        @detected_item = @collection.detect(&@detector)
        !!@detected_item
      end
      
      def failure_message
        if @detector.is_a?(Symbol)
          "Expected the collection to contain an element that is #{@detector.to_s.chomp("?")}, but it didn't!\n"
        else
          "Expected the collection to contain an element with certain criteria, but it didn't!\n"
        end
      end
      
      def negative_failure_message
        if @detector.is_a?(Symbol)
          "Expected the collection not to contain an element that is #{@detector.to_s.chomp("?")}, but it did!\n" +
          "Detected item: #{@detected_item}"
        else
          "Expected the collection not to contain an element with certain criteria, but it did!\n" + 
          "Item: #{@detected_item}"
        end        
      end
      
      def is_a(klass)
        @detector = Proc.new { |o| o.is_a?(klass) }
        self
      end
      alias_method :a, :is_a
      
      def responds_to(meth)
        @detector = Proc.new { |o| o.respond_to?(meth) }
        self
      end
      
      def includes(*elements)
        @detector = Proc.new { |o| elements.all? { |e| o.include?(e) } }
        self
      end
      
      def true
        @detector = Proc.new { |o| !!o }
        self
      end
      alias_method :is_true, :true
      
      def false
        Sander6::CustomMatchers::FalseDetectorMatcher.new
      end
      alias_method :is_false, :false
      
      def nil
        Sander6::CustomMatchers::NilDetectorMatcher.new
      end
      alias_method :is_nil, :nil
      
      def ==(expected)
        @detector = Proc.new { |o| o == expected }
        self
      end
      
      def ===(expected)
        @detector = Proc.new { |o| o === expected }
        self
      end
      
      def <(expected)
        @detector = Proc.new { |o| o < expected }
        self
      end
      
      def <=(expected)
        @detector = Proc.new { |o| o <= expected }
        self
      end
      
      def >(expected)
        @detector = Proc.new { |o| o > expected }
        self
      end
      
      def >=(expected)
        @detector = Proc.new { |o| o >= expected }
        self
      end
      
      def =~(expected)
        @detector = Proc.new { |o| o =~ expected }
        self
      end
      alias_method :matches, :=~
      
      def method_missing(name, *args, &block)
        @detector = case name.to_s 
        when /^is_(an?_)?(.+)$/
          if $2 == "true" || $2 == "false"
            eval($2) ? Proc { |o| !!o } : Proc { |o| !o }
          else
            Proc.new { |o| o.__send__(:"#{$2}?", *args) }
          end
        when /^an?_(.+)$/
          Proc.new { |o| o.__send__(:"#{$1}?", *args) }
        else
          Proc.new { |o| o.__send__(:"#{name}?", *args) }
        end
        self
      end
    end
   
    class NilDetectorMatcher
      def initialize
      end
      
      def matches?(collection)
        @collection = collection
        @collection.any? { |e| e.nil? }
      end
      
      def failure_message
        "Expected the collection to contain an element that is nil, but it didn't!\n"
      end
      
      def negative_failure_message
        "Expected the collection not to contain an element that is nil, but it did!\n"
      end
    end
    
    class FalseDetectorMatcher
      def initialize
      end
      
      def matches?(collection)
        @collection = collection
        @collection.any? { |o| o.object_id == 0 || o.nil? }
      end
      
      def failure_message
        "Expected the collection to contain an element that is false, but it didn't!\n"
      end
      
      def negative_failure_message
        "Expected the collection not to contain an element that is false, but it did!\n"
      end
    end
   
    def have_an_element(&block)
      Sander6::CustomMatchers::DetectorMatcher.new(&block)
    end
    alias_method :have_some_element, :have_an_element
     
  end
end