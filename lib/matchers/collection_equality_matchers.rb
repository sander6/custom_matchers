module Sander6
  module CustomMatchers
    
    class CollectionMemberEqualityMatcher
      def initialize
      end
      
      # A singleton set vacuously matches.
      def matches?(collection)
        @collection = collection
        # collection.uniq == collection.first
        collection.all? { |item| item == collection.first }
      end
      
      def failure_message
        "Expected all memebers of #{@collection.inspect} to be the same (using ==), but they weren't."
      end
      
      def negative_failure_message        
        "Expected at least one memeber of #{@collection.inspect} to be different (using ==), but there wasn't one."
      end    
    end

    class NegativeCollectionMemberEqualityMatcher
      def initialize
      end
      
      def matches?(collection)
        @collection = collection
        collection.uniq == collection
      end
      
      def failure_message
        "Expected all memebers of #{@collection.inspect} to be different, but they weren't."
      end
      
      def negative_failure_message        
        "Expected at least one memeber of #{@collection.inspect} to be the same as another, but there wasn't one."
      end    
    end

    def all_be_the_same
      Sander6::CustomMatchers::CollectionMemberEqualityMatcher.new
    end

    def all_not_be_the_same
      Sander6::CustomMatchers::NegativeCollectionMemberEqualityMatcher.new
    end
    alias_method :all_be_different, :all_not_be_the_same
    
  end
end