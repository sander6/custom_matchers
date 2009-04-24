module Sander6
  module CustomMatchers

    class AbstractDefintionMatcher
      def initialize(name)
        @name = name
        @undefined = false
        @conditions = []
        @expectation_strings = []
        @actual_proc = Proc.new { |o| o }
        @actual_string = "value"
        @actual = nil
        @didnt = false
      end

      def matches?(obj)
        @obj = obj
        unless @obj.__send__(@checker_method, @name)
          @undefined = true
          return false
        end
        unless @conditions.empty?
          if @conditions.all? { |condition| condition.to_proc.call(@obj.__send__(@getter_method, @name)) }
            return true
          elsif @actual_proc
            @actual = @actual_proc.call(@obj.__send__(@getter_method, @name))
            return false
          else
            return false
          end
        else
          return true
        end
      end
      
      def failure_message
        message = "Expected #{@name.to_s} to be defined on #{@obj.inspect}"
        if @undefined
          message << ", but it wasn't!"
          return message
        end
        if @conditions
          message << " and #{@expectation_strings.join(' and ')}, but it #{@didnt ? "didn't" : "wasn't"}!"
          message << "\nActual: #{@actual}"
        end
        return message
      end
    
      def negative_failure_message
        message = "Expected #{@name.to_s}"
        unless @undefined
          message << " not to be defined on #{@obj.inspect}, but it was!"
          return message
        end
        message << " not to #{@expectation_strings.join(' and ')}, but it #{@didnt ? "did" : "was"}!" if @conditions
        return message
      end
      
      def is_true
        @expectation_strings << "be true"
        @actual_proc = nil
        @actual_string = nil
        @conditions << Proc.new { |o| !!o }
        self
      end

      def is_false        
        @expectation_strings << "be false"
        @actual_proc = nil
        @actual_string = nil
        @conditions << Proc.new { |o| !o }
        self
      end

      def is_a(klass)
        @conditions << Proc.new { |o| o.is_a?(klass) }
        @expectation_strings << "be a #{klass.name}"
        @actual_proc = Proc.new { |o| o.class }
        @actual_string = "class"
        self
      end
      
      def is_an_instance_of(klass)
        @conditions << Proc.new { |o| o.instance_of?(klass) }
        @expectation_strings << "be an instance of #{klass.name}"
        @actual_proc = Proc.new { |o| o.class }
        @actual_string = "class"        
        self
      end
      
      def is_a_kind_of(klass)
        @conditions << Proc.new { |o| o.kind_of?(klass) }
        @expectation_strings << "be a kind of #{klass.name}"
        @actual_proc = Proc.new { |o| o.class }
        @actual_string = "class"
        self
      end
      
      def contains(*elements)
        @conditions << Proc.new { |o| elements.all? { |e| o.include?(e) } }
        @expectation_strings << "contain #{elements.join(' and ')}"
        @actual_proc = Proc.new { |o| o.join(', ') }
        @actual_string = "elements"
        @didnt = true
        self
      end
      alias_method :includes, :contains

      def responds_to(name)
        @conditions << Proc.new { |o| o.respond_to?(name) }
        @expectation_strings << "respond to #{name}"
        @actual_proc = nil
        @actual_string = nil
        @didnt = true
        self
      end

      def ==(expected)
        @conditions << Proc.new { |o| o == expected }
        @expectation_strings << "equal #{expected.inspect}"
        @predicate_string = " (using ==)"
        @didnt = true
        self
      end
      alias_method :with_value, :==
      
      def ===(expected)
        @conditions << Proc.new { |o| o === expected }
        @expectation_strings << "equal #{expected.inspect}"
        @predicate = " (using ===)"
        @didnt = true
        self
      end
      
      def <(expected)
        @conditions << Proc.new { |o| o < expected }
        @expectation_strings << "be less than #{expected}"
        self
      end
      
      def <=(expected)
        @conditions << Proc.new { |o| o <= expected }
        @expectation_strings << "be less than or equal to #{expected}"
        self
      end
      
      def >(expected)
        @conditions << Proc.new { |o| o > expected }
        @expectation_strings << "be greater than #{expected}"
        self
      end
      
      def >=(expected)
        @conditions << Proc.new { |o| o >= expected }
        @expectation_strings << "be greated than or equal to #{expected}"
        self
      end
      
      def =~(expected)
        @conditions << Proc.new { |o| o =~ expected }
        @expectation_strings << "match #{expected.inspect}"
        @didnt = true
        self
      end
      alias_method :matches, :=~
      
      def is(&block)
        if block_given?
          @conditions << block
          @expectation_strings << "satisfy the given conditions"
          @didnt = true
        end
        self
      end
      alias_method :that, :is
      # Aliasing #is as #that helps make good grammatical sense. Trust me.
      
      # For chaining condition expectations
      def and
        self
      end
      
      # Gives access to a number of handy, Englishy constuctions such as
      # should have_instance_variable(:@chumpy).that.is_true
      # should have_instance_variable(:@chumpy).that.is_empty
      # should have_instance_variable(:@chumpy).that.has_key(:key)
      # should have_instance_variable(:@chumpy).that.respond_to(:method)
      # should have_instance_variable(:@chumpy).that.include(object)
      def method_missing(name, *args, &block)
        case name.to_s
        when /^is_(an?_)?(.+)$/
          @expectation_strings << "be #{$2}"
          @actual_proc = nil
          @actual_string = nil
          @conditions << Proc.new { |o| o.__send__(:"#{$2}?", *args) }
        when /^has_(.+)$/
          @expectation_strings << "have #{$1} #{args.join(', ')}"
          @actual_proc = nil
          @actual_string = nil
          @didnt = true
          @conditions << Proc.new { |o| o.__send__(:"has_#{$1}?", *args) }
        else
          @expectation_strings << "#{$1} #{args.join(', ')}"
          @actual_proc = nil
          @actual_string = nil
          @didnt = true
          @conditions << Proc.new { |o| o.__send__(:"#{name}?", *args) }
        end
        self
      end   
    end

    class InstanceVariableDefinitionMatcher < AbstractDefintionMatcher
      def matches?(obj)
        @checker_method = :instance_variable_defined?
        @getter_method  = :instance_variable_get
        super
      end
    end
  
    class ClassVariableDefinitionMatcher < AbstractDefintionMatcher
      def matches?(obj)
        @checker_method = :class_variable_defined?
        @getter_method  = :class_variable_get
        super
      end
    end
  
    class ConstantDefinitionMatcher < AbstractDefintionMatcher
      def matches?(obj)
        @checker_method = :const_defined?
        @getter_method  = :const_get
        super
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