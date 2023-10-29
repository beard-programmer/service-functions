# frozen_string_literal: true

module ServiceFunctions
  module HandleErrors
    module Exceptions
      EmployeePayroll = Data.define(:employee_id, :line_items)
      CalculatedEmployeePayroll = Data.define(:employee_id, :total, :taxable, :exempt)
    end
  end
end
