module Sander6
  module CustomMatchers

    class SubClassMatcher
      def initialize(klass)
        @klass = klass
        @immediate = false
      end
    
      def immediately
        @immediate = true
        self
      end
    
      def matches?(subklass)
        @subklass = subklass
        @immediate ? @subklass.superclass == @klass : @subklass.ancestors.include?(@klass)
      end

      def failure_message
        "Expected #{@subklass.name} to be a#{"n immediate" if @immediate} subclass of #{@klass.name}, but it wasn't.\n" +
        "Inheritance chain: #{@subklass.ancestors.collect(&:name).join(" < ")}"
      end
    
      def negative_failure_message
        "Expected #{@subklass.name} not to be a#{"n immediate" if @immediate} subclass of #{@klass.name}, but it was.\n" + 
        "Inheritance chain: #{@subklass.ancestors.collect(&:name).join(" < ")}"
      end

    end
    
    def descend_from(klass)
      Sander6::CustomMatchers::SubClassMatcher.new(klass)
    end  
    
  end
end