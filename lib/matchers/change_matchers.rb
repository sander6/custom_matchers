module Sander6
  module CustomMatchers

    class ChangeMatcher   
      def initialize(meth)
        @meth = meth
        @expected = nil
        @block = Proc.new { }
      end
    
      def to(value)
        @expected = value
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
        if @expected
          @after == @expected
        else
          @after != @before
        end
      end
    
      def failure_message
        if @expected
          "Expected #{@obj.inspect}.#{@meth.to_s} to change value to #{@expected.inspect}, but it was actually #{@after.inspect}."
        else
          "Expected #{@obj.inspect}.#{@meth.to_s} to change value, but it didn't."
        end
      end
    
      def negative_failure_message
        if @expected
          "Expected #{@obj.inspect}.#{@meth.to_s} not to change value to #{@expected.inspect}, but it did."
        else
          "Expected #{@obj.inspect}.#{@meth.to_s} not to change value, but it was actually #{@after.inspect}."
        end      
      end
    end

    def change(meth)
      Sander6::CustomMatchers::ChangeMatcher.new(meth)
    end

  end
end