# frozen_string_literal: true

require_relative 'line_item'

module ServiceFunctions
  # Verb + anemic method call: Service function
  module CalculateTaxes
    module_function

    # @param [LineItemWithPolicy] line_item
    # @returns [CalculatedLineItem]
    def call(line_item)
      amount = line_item.amount
      exempt = if line_item.tax_policy == 'TAXABLE'
                 0
               else
                 amount / 2
               end
      taxable = amount - exempt
      CalculatedLineItem.new(amount:, taxable:, exempt:)
    end
  end
end
