# frozen_string_literal: true

module ServiceFunctions
  module HandleErrors
    module OkError
      class EmployeePayroll < Data.define(:employee_id, :line_items); end
      class CalculatedEmployeePayroll < Data.define(:employee_id, :total, :taxable, :exempt); end
    end
  end
end
