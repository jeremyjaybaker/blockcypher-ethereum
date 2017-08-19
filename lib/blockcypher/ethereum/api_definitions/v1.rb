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
            attributes: [ :address ],
            actions: {
              add_wei: {
                path_extension: '',
                type: :post,
                testnet_only: true,
                params: {
                  address: ->{ @address },
                  amount: nil
                },
                return_type: :hash
              }
            }
          },
          txs: {
            attributes: [
              :block_height,
              :hash,
              :address,
              :total,
              :fees,
              :size,
              :gas_used,
              :gas_price,
              :relayed_by,
              :received,
              :ver,
              :double_spend,
              :vin_sz,
              :vout_sz,
              :confirmations,
              :inputs,
              :outputs,
              :internal_txids,
              :parent_tx,
              :confirmed,
              :gas_limit,
              :contract_creation,
              :receive_count,
              :block_hash,
              :block_index,
              :double_of,
              :execution_error
            ],
            actions: {
              retrieve: {
                path_extension: '',
                type: :get,
                testnet_only: false,
                params: { lookup_hash: nil },
                return_type: :tx
              },
              build: {
                path_extension: 'new',
                type: :post,
                testnet_only: false,
                params: {
                  input_address: nil,
                  output_address: nil,
                  amount: nil
                },
                return_type: :txskeleton
              },
              save: {
                path_extension: 'new',
                type: :post,
                testnet_only: false,
                params: {
                  input_address: nil,
                  output_address: nil,
                  amount: nil
                },
                return_type: :txskeleton
              }
            }
          }
        }.freeze
      end
    end
  end
end
