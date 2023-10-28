# frozen_string_literal: true

module ServiceFunctions
  LineItem = Data.define(:amount, :line_item_key)
  LineItemWithPolicy = Data.define(:amount, :line_item_key, :tax_policy)
  CalculatedLineItem = Data.define(:amount, :taxable, :exempt)

  # Verb + anemic method call: Service function
  module BuildLineItemWithPolicy
    extend self

    # @param line_item [LineItem]
    # @returns [LineItemWithPolicy]
    def call(line_item)
      LineItemWithPolicy.new(
        amount: line_item.amount,
        line_item_key: line_item.line_item_key,
        tax_policy: find_policy(line_item)
      )
    end

    private

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
