module Sander6
  module CustomMatchers

    class InstanceVariableDefinitionMatcher
      def initialize(name)
        @name = name
        @target_value = nil
        @actual_value = nil
        @check_for_value = false
        @ivar_undefined = false
      end
    
      def with_value(value)
        @target_value = value
        @check_for_value = true
        self
      end
    
      def matches?(obj)
        @obj = obj
        unless @obj.instance_variable_defined?(@name)
          @ivar_undefined = true
          return false
        end
        if @check_for_value
          @actual_value = @obj.instance_variable_get(@name)    
          return false unless @actual_value == @target_value
        end
        return true
      end
    
      def failure_message
        message = "Expected #{@name.to_s} to be defined on #{@obj.inspect}"
        return message << ", but it wasn't!" if @ivar_undefined
        message << " with value #{@target_value} " if @check_for_value
        message << ", but it wasn't!"
        message << "\nActual value: #{@actual_value}" if @check_for_value
        return message
      end
    
      def negative_failure_message
        message = "Expected #{@name.to_s} not to be defined on #{@obj.inspect}"
        return message << ", but it was!" unless @ivar_undefined
        message << " with value #{@target_value} " if @check_for_value
        message << ", but it was!"
        message << "\nActual value: #{@actual_value}" if @check_for_value
        return message
      end
    end
  
    class ClassVariableDefinitionMatcher
      def initialize(name)
        @name = name
        @target_value = nil
        @actual_value = nil
        @check_for_value = false
        @cvar_undefined = false
      end
    
      def with_value(value)
        @target_value = value
        @check_for_value = true
        self
      end
    
      def matches?(klass)
        @klass = klass
        unless @klass.class_variable_defined?(@name)
          @cvar_undefined = true
          return false
        end
        if @check_for_value
          @actual_value = @klass.__send__(:class_variable_get, @name)
          return false unless @actual_value == @target_value
        end
        return true
      end
    
      def failure_message
        message = "Expected #{@name.to_s} to be defined on #{@klass.name}"
        return message << ", but it wasn't!" if @cvar_undefined
        message << " with value #{@target_value} " if @check_for_value
        message << ", but it wasn't!"
        message << "\nActual value: #{@actual_value}" if @check_for_value
        return message
      end
    
      def negative_failure_message
        message = "Expected #{@name.to_s} not to be defined on #{@klass.name}"
        return message << ", but it was!" unless @cvar_undefined
        message << " with value #{@target_value} " if @check_for_value
        message << ", but it was!"
        message << "\nActual value: #{@actual_value}" if @check_for_value
        return message
      end
    end
  
    class ConstantDefinitionMatcher
      def initialize(name)
        @name = name
        @target_value = nil
        @actual_value = nil
        @check_for_value = false
        @const_undefined = false
      end
    
      def with_value(value)
        @target_value = value
        @check_for_value = true
        self
      end
    
      def matches?(klass)
        @klass = klass
        unless @klass.const_defined?(@name)
          @const_undefined = true
          return false
        end
        if @check_for_value
          @actual_value = @klass.__send__(:const_get, @name)
          return false unless @actual_value == @target_value
        end
        return true
      end
    
      def failure_message
        message = "Expected #{@name.to_s} to be defined on #{@klass.name}"
        return message << ", but it wasn't!" if @const_undefined
        message << " with value #{@target_value} " if @check_for_value
        message << ", but it wasn't!"
        message << "\nActual value: #{@actual_value}" if @check_for_value
        return message
      end
    
      def negative_failure_message
        message = "Expected #{@name.to_s} not to be defined on #{@klass.name}"
        return message << ", but it was!" unless @const_undefined
        message << " with value #{@target_value} " if @check_for_value
        message << ", but it was!"
        message << "\nActual value: #{@actual_value}" if @check_for_value
        return message
      end
    end
    
    def have_instance_variable(ivar)
      Sander6::CustomMatchers::InstanceVariableDefinitionMatcher.new(ivar)
    end
    alias_method :have_ivar, :have_instance_variable

    def have_class_variable(cvar)
      Sander6::CustomMatchers::ClassVariableDefinitionMatcher.new(cvar)
    end
    alias_method :have_cvar, :have_class_variable

    def have_constant(const)
      Sander6::CustomMatchers::ConstantDefinitionMatcher.new(const)
    end
    alias_method :have_const, :have_constant
    
  end
end