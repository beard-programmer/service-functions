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

class Ololo < Data.define(:key1); end

def test
  input = { key1: 1, key2: 2 }

  case input
  in { key1: 1, key2: 2 } then p('first match')
  else p('first not match')
  end

  case input
  in key1: 1, key2: 2 then p('second match')
  else p('second not match')
  end

  input2 = Ololo.new(key1: 1)
  case input2
  in key1: 1 then p('third match')
  else p('third not match')
  end

  case input2
  in { key1: 1 } then p('forth match')
  else p('forth not match')
  end
end
