module Blockcypher
  module Ethereum
    class Engine < ::Rails::Engine

      config.autoload_paths += Dir["#{config.root}/lib/"]
      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      end

      ActiveSupport::Inflector.inflections do |inflect|
        inflect.plural /^(tx)$/i, '\1\2s'
        inflect.plural /^(addr)$/i, '\1\2s'
      end
    end
  end
end
