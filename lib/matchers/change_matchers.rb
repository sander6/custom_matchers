module Sander6
  module CustomMatchers

    class ChangeMatcher   
      def initialize(meth = nil, compatibility_message = nil, &block)
        @compatibility_object = meth
        @compatibility_message = compatibility_message
        @method = meth
        @value_proc = if block_given?
          block
        elsif @method.is_a?(Symbol)
          lambda { |obj| obj.__send__(@method || :inspect) }
        elsif @method.nil?
          lambda { |obj| obj.inspect }
        else
          lambda { @compatibility_object.__send__(@compatibility_message) }
        end
        @expected = nil
        @event_proc = Proc.new { }
      end

      def from(value)
        @initial = value
        self
      end
    
      def to(value)
        @expected = value
        self
      end
      
      def by(amount)
        @amount = amount
        self
      end
      
      def by_at_least(amount)
        @minimum = amount
        self
      end
      
      def by_at_most(amount)
        @maximum = amount
        self
      end
    
      def when(&block)
        @event_proc = block
        self
      end
    
      def matches?(obj)
        @obj = obj

        # Retain backward compatibility for the regular RSpec change matcher.
        if @obj.is_a?(Proc)
          matcher = Spec::Matchers::Change.new(@compatibility_object, @compatibility_message, &@value_proc)
          matcher.to(@expected) if @expected
          matcher.from(@initial) if @initial
          matcher.by(@amount) if @amount
          matcher.by_at_least(@minimum) if @minimum
          matcher.by_at_most(@maximum) if @maximum
          return matcher.matches?(@obj)
        end
        
        @before = @value_proc.call(@obj)
        @event_proc.call
        @obj.reload if Object.const_defined?(:ActiveRecord) && @obj.is_a?(ActiveRecord::Base)
        @after = @value_proc.call(@obj)
        
        @delta = (@after - @before).abs if @after.respond_to?(:-)
        
        return (@expected = false) if @initial unless @initial == @before
        return false if @expected unless @expected == @after
        return false if @delta == 0
        return (@delta == @amount) if @amount
        return (@delta >= @minimum) if @minimum
        return (@delta <= @maximum) if @maximum        
        return @before != @after
      end
    
      def failure_message
        if @expected
          "Expected #{@obj.inspect}#{'.' + @method.to_s if @method} to change value#{' from' + @initial.inspect if @initial} to #{@expected.inspect}, but it was actually #{@after.inspect}."
        elsif @initial
          "Expected #{@obj.inspect}#{'.' + @method.to_s if @method} to change value from #{@initial.inspect}, but it didn't."
        elsif @amount          
          "Expected #{@obj.inspect}#{'.' + @method.to_s if @method} to change value by #{@amount}, but it actually changed by #{@delta}."
        elsif @maximum
          "Expected #{@obj.inspect}#{'.' + @method.to_s if @method} to change value by no more than #{@maximum}, but it actually changed by #{@delta}."
        elsif @minimum
          "Expected #{@obj.inspect}#{'.' + @method.to_s if @method} to change value by no less than #{@minimum}, but it actually changed by #{@delta}."          
        else
          "Expected #{@obj.inspect}#{'.' + @method.to_s if @method} to change value, but it didn't."
        end
      end
    
      def negative_failure_message
        if @expected
          "Expected #{@obj.inspect}#{'.' + @method.to_s if @method} not to change value#{' from' + @initial.inspect if @initial} to #{@expected.inspect}, but it did."
        elsif @initial
          "Expected #{@obj.inspect}#{'.' + @method.to_s if @method} not to change value from #{@initial.inspect}, but it did."
        elsif @amount          
          "Expected #{@obj.inspect}#{'.' + @method.to_s if @method} not to change value by #{@amount}, but it did."
        elsif @maximum
          "Expected #{@obj.inspect}#{'.' + @method.to_s if @method} not to change value by any more than #{@maximum}, but it actually changed by #{@delta}."
        elsif @minimum
          "Expected #{@obj.inspect}#{'.' + @method.to_s if @method} not to change value by any less than #{@minimum}, but it actually changed by #{@delta}."          
        else
          "Expected #{@obj.inspect}#{'.' + @method.to_s if @method} not to change value, but it did."
        end
      end
    end

    def change(meth = nil, message = nil, &block)
      Sander6::CustomMatchers::ChangeMatcher.new(meth, message, &block)
    end

  end
end