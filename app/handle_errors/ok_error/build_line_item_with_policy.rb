# frozen_string_literal: true

require_relative 'line_item'

module ServiceFunctions
  module HandleErrors
    module OkError
      module BuildLineItemWithPolicy
        extend self

        # @param [ServiceFunctions::HandleErrors::OkError::CalculatedLineItem] line_item
        # @return [Array(Symbol, LineItemWithPolicy)]
        # @return [Array(Symbol, String)]
        def call(line_item)
          case line_item
          in { amount: Integer => amount, line_item_key: } if ['bonus', 'salary'].include?(line_item_key) then
            [:ok, build_line_item(amount, line_item_key, 'TAXABLE')]
          in { amount: Integer => amount, line_item_key: 'meal_voucher' } then
            [:ok, build_line_item(amount, 'meal_voucher', 'EXEMPT')]
          else
            [:error, 'failed to build line item with policy']
          end
        end

        private

        # @param [Integer] amount
        # @param [String] line_item_key
        # @param [String] tax_policy
        # @return [ServiceFunctions::HandleErrors::OkError::LineItemWithPolicy]
        def build_line_item(amount, line_item_key, tax_policy)
          LineItemWithPolicy.new(
            amount:,
            line_item_key:,
            tax_policy:
          )
        end
      end
    end
  end
end
