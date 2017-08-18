module Blockcypher
  module Ethereum
    class Engine < ::Rails::Engine

      config.autoload_paths += Dir["#{config.root}/lib/**/"]
      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      end
    end
  end
end
