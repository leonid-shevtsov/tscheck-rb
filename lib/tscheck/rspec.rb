require 'tscheck/tsserver'
require 'tscheck/rspec/matchers'

module TSCheck
  module RSpec

    def self.setup(options = {})
      @server = TSServer.new(options)

      ::RSpec.configure do |config|
        config.before(:suite) do
          TSCheck::RSpec.server.start_server
        end

        config.after(:suite) do
          TSCheck::RSpec.server.stop_server
        end

        config.include TSCheck::RSpec::Matchers
      end
    end

    def self.server
      @server
    end
  end
end
