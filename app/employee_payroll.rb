# frozen_string_literal: true

module ServiceFunctions
  EmployeePayroll = Data.define(:employee_id, :line_items)
  CalculatedEmployeePayroll = Data.define(:employee_id, :total, :taxable, :exempt)
end
