# frozen_string_literal: true

module ServiceFunctions
  module HandleErrors
    module Exceptions
      # Verb + anemic method call: Service function
      module CalculateTaxes
        class InvalidInput < ArgumentError; end

        module_function

        # @param [LineItemWithPolicy] line_item
        # @raise [InvalidInput]
        # @returns [CalculatedLineItem]
        def call(line_item)
          amount, taxable, exempt =
            case line_item
            in amount: Integer => amount, tax_policy: 'TAXABLE' then
              [amount, amount, 0]
            in amount: Integer => amount, tax_policy: 'EXEMPT' then
              exempt = amount / 2
              [amount, amount - exempt, exempt]
            else
              raise InvalidInput
            end
          CalculatedLineItem.new(amount:, taxable:, exempt:)
        end
      end
    end
  end
end
