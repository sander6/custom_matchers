module Sander6
  module CustomMatchers

    class IncrementMatcher       
      def initialize(meth)
        @meth = meth
        @step = 1
        @block = Proc.new { }
      end
    
      def by(step)
        @step = step
        self
      end
    
      def when(&block)
        @block = block
        self
      end
    
      def matches?(obj)
        @obj = obj
        @before = @obj.__send__(@meth)
        @block.call
        @obj.reload if @obj.is_a?(ActiveRecord::Base)
        @after = @obj.__send__(@meth)
        @after == @before + @step
      end
    
      def failure_message
        "Expected ##{@meth.to_s} to increment by #{@step}, but it didn't.\n" +
        "Before: #{@before}\n" +
        "After: #{@after}"
      end
    
      def negative_failure_message
        "Expected ##{@meth.to_s} not to increment by #{@step}, but it did."
      end
    end
  
    class DecrementMatcher
      def initialize(meth)
        @meth = meth
        @step = 1
        @block = Proc.new { }
      end
    
      def by(step)
        @step = step
        self
      end
    
      def when(&block)
        @block = block
        self
      end
    
      def matches?(obj)
        @obj = obj
        @before = @obj.__send__(@meth)
        @block.call
        @obj.reload if @obj.is_a?(ActiveRecord::Base)
        @after = @obj.__send__(@meth)
        @after == @before - @step
      end
    
      def failure_message
        "Expected ##{@meth.to_s} to decrement by #{@step}, but it didn't.\n" +
        "Before: #{@before}\n" +
        "After: #{@after}"
      end
    
      def negative_failure_message
        "Expected ##{@meth.to_s} not to decrement by #{@step}, but it did."
      end
    end
    
    def increment(meth)
      Sander6::CustomMatchers::IncrementMatcher.new(meth)
    end

    def decrement(meth)
      Sander6::CustomMatchers::DecrementMatcher.new(meth)
    end

  end
end