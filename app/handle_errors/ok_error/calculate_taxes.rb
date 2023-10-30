# frozen_string_literal: true

module ServiceFunctions
  module HandleErrors
    module OkError
      # Verb + anemic method call: Service function
      module CalculateTaxes
        class InvalidInput < ArgumentError; end

        extend self

        # @param [LineItemWithPolicy] line_item
        # @return [Array(Symbol, ServiceFunctions::HandleErrors::OkError::CalculatedLineItem)] when all good,
        # first element is symbol :ok and second is line item
        # @return [Array(Symbol, String)] when failed, first element is symbol :error an d second is error message
        def call(line_item)
          case line_item
          in amount: Integer => amount, tax_policy: 'TAXABLE' then
            [:ok, build_line_item(amount, amount, 0)]
          in amount: Integer => amount, tax_policy: 'EXEMPT' then
            exempt = amount / 2
            [:ok, build_line_item(amount, amount - exempt, exempt)]
          else
            [:error, 'Failed to calculate taxes']
          end
        end

        private

        # @param [Integer] amount
        # @param [Integer] taxable
        # @param [Integer] exempt
        # @return [ServiceFunctions::HandleErrors::OkError::CalculatedLineItem]
        def build_line_item(amount, taxable, exempt)
          CalculatedLineItem.new(amount:, taxable:, exempt:)
        end
      end
    end
  end
end
