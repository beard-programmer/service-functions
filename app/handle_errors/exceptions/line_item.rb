# frozen_string_literal: true

module ServiceFunctions
  module HandleErrors
    module Exceptions
      class LineItem < Data.define(:amount, :line_item_key); end
      class LineItemWithPolicy < Data.define(:amount, :line_item_key, :tax_policy); end
      class CalculatedLineItem < Data.define(:amount, :taxable, :exempt); end
    end
  end
end
