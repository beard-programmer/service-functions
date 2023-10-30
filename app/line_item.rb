# frozen_string_literal: true

module ServiceFunctions
  LineItem = Data.define(:amount, :line_item_key)
  LineItemWithPolicy = Data.define(:amount, :line_item_key, :tax_policy)
  CalculatedLineItem = Data.define(:amount, :taxable, :exempt)
end
