require 'tscheck/rspec/matchers/ts_type_matcher'

module TSCheck
  module RSpec
    module Matchers

      def match_ts_type(type, options = {})
        TSCheck::RSpec::Matchers::TSTypeMatcher.new(type, options)
      end
    end
  end
end
