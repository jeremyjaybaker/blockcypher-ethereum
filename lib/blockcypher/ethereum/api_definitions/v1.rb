module Blockcypher
  module Ethereum
    module APIDefinitions
      module V1

        # Dynamic objects will use this namespace
        eval <<-RUBY
          module Blockcypher::Ethereum::V1
          end
        RUBY

        OBJECTS = {
          faucet: {
            initialization_params: { address: @address },
            actions: [
              add_wei: {
                path_extension: '',
                type: :post,
                testnet_only: true,
                params: {
                  address: @address,
                  amount: nil
                },
              }
            ]
          }
        }.freeze
      end
    end
  end
end
