# frozen_string_literal: true

require_relative 'line_item'
require_relative 'employee_payroll'
require_relative 'calculate_employee_payroll'
require_relative 'calculate_taxes'
require_relative 'build_line_item_with_policy'

module ServiceFunctions
  employee_payroll = EmployeePayroll.new(
    employee_id: 1, line_items: [
      LineItem.new(amount: 100, line_item_key: 'salary'),
      LineItem.new(amount: 150, line_item_key: 'bonus'),
      LineItem.new(amount: 200, line_item_key: 'meal_voucher')
    ]
  )
  calculated_employee_payroll = CalculateEmployeePayroll.call(
    BuildLineItemWithPolicy, # Dependency
    CalculateTaxes, # Dependency
    employee_payroll # Actual input value
  )

  calculated_employee_payroll
end
