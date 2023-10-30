# frozen_string_literal: true

require_relative 'line_item'

module ServiceFunctions
  # Verb + anemic method call: Service function
  module BuildLineItemWithPolicy
    extend self

    # @param [LineItem] line_item
    # @returns [LineItemWithPolicy]
    def call(line_item)
      LineItemWithPolicy.new(
        amount: line_item.amount,
        line_item_key: line_item.line_item_key,
        tax_policy: find_policy(line_item)
      )
    end

    private

    # @param [LineItem] line_item
    # @return [String]
    def find_policy(line_item)
      line_item_key = line_item.line_item_key
      if line_item_key == 'meal_voucher'
        'EXEMPT'
      else
        'TAXABLE'
      end
    end
  end
end
