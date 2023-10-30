# frozen_string_literal: true

require_relative 'line_item'
require_relative 'build_line_item_with_policy'
require_relative 'employee_payroll'
require_relative 'calculate_employee_payroll'
require_relative 'calculate_taxes'

RSpec.describe ServiceFunctions::CalculateEmployeePayroll, type: :service_function do
  describe '.call' do
    subject(:when_calculating_employee_payroll) do
      described_class.call(
        ServiceFunctions::BuildLineItemWithPolicy,
        ServiceFunctions::CalculateTaxes,
        employee_payroll
      )
    end
    let(:employee_payroll) do
      ServiceFunctions::EmployeePayroll.new(
        employee_id: 1, line_items: [
          ServiceFunctions::LineItem.new(amount: 100, line_item_key: 'salary'),
          ServiceFunctions::LineItem.new(amount: 150, line_item_key: 'bonus'),
          ServiceFunctions::LineItem.new(amount: 200, line_item_key: 'meal_voucher')
        ]
      )
    end
    context 'given correct employee payroll' do
      let(:expected_result) do
        ServiceFunctions::CalculatedEmployeePayroll.new(employee_id: 1, total: 450, taxable: 350, exempt: 100)
      end
      it 'then returns expected calculated employee payroll' do
        expect(when_calculating_employee_payroll).to eq expected_result
      end
    end
  end
end
