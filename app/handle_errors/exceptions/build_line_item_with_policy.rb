# frozen_string_literal: true

require_relative 'line_item'

module ServiceFunctions
  module HandleErrors
    module Exceptions
      module BuildLineItemWithPolicy
        class InvalidInput < ArgumentError; end
        class PolicyNotFound < StandardError; end

        extend self

        # @param [ServiceFunctions::HandleErrors::Exceptions::CalculatedLineItem] line_item
        # @raise [PolicyNotFound]
        # @raise [InvalidInput]
        # @return [ServiceFunctions::HandleErrors::Exceptions::LineItemWithPolicy]
        def call(line_item)
          case line_item
          in amount:, line_item_key: then
            LineItemWithPolicy.new(
              amount:,
              line_item_key:,
              tax_policy: find_policy!(line_item_key)
            )
          else
            raise InvalidInput
          end
        end

        private

        # @param line_item_key [String]
        # @raise [PolicyNotFound]
        # @return [String]
        def find_policy!(line_item_key)
          case line_item_key
          in 'meal_voucher' then
            'EXEMPT'
          in 'bonus' | 'salary' then
            'TAXABLE'
          else
            raise PolicyNotFound, "Cant find policy for line item key #{line_item_key}"
          end
        end
      end
    end
  end
end
