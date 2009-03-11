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
        "Inheritance chain: #{inheritance_chain(@subklass).collect(&:name).join(" < ")}"
      end
    
      def negative_failure_message
        "Expected #{@subklass.name} not to be a#{"n immediate" if @immediate} subclass of #{@klass.name}, but it was.\n" + 
        "Inheritance chain: #{inheritance_chain(@subklass).collect(&:name).join(" < ")}"
      end
    
      private
      def inheritance_chain(klass)
        chain = [klass]
        parent_class = klass.superclass
        while parent_class do
          chain << parent_class
          parent_class = parent_class.superclass
        end
        return chain.compact
      end
    end
    
    def descend_from(klass)
      Sander6::CustomMatchers::SubClassMatcher.new(klass)
    end  
    
  end
end