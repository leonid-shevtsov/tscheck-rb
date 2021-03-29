module TSCheck
  module RSpec
    module Matchers
      class TSTypeMatcher
        def initialize(type, options)
          @type = type
          @options = options
        end

        def description
          "match TypeScript type #{@type}"
        end

        def matches?(actual)
          @actual_string = actual.is_a?(String) ? actual : actual.to_json
          @ts_error = TSCheck::RSpec.server.check_type(@actual_string, type: @type, **@options)
          @ts_error.nil?
        end

        def failure_message
          "expected #{@actual_string} to be of TypeScript type #{@type}, but type check failed with error:\n#{@ts_error}"
        end

        def failure_message_when_negated
          "expected #{@actual_string} not to be of TypeScript type #{@type}, but type check succeeded"
        end
      end
    end
  end
end
