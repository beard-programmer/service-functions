# frozen_string_literal: true

require_relative 'line_item'
require_relative 'employee_payroll'
require_relative 'calculate_employee_payroll'
require_relative 'calculate_taxes'

RSpec.describe ServiceFunctions::HandleErrors::Exceptions::CalculateEmployeePayroll, type: :service_function do
  describe '.call' do
    subject(:when_calculating_employee_payroll) do
      described_class.call(
        ServiceFunctions::HandleErrors::Exceptions::BuildLineItemWithPolicy,
        ServiceFunctions::HandleErrors::Exceptions::CalculateTaxes,
        employee_payroll
      )
    end
    let(:employee_payroll) do
      ServiceFunctions::HandleErrors::Exceptions::EmployeePayroll.new(
        employee_id: 1, line_items: [
          ServiceFunctions::HandleErrors::Exceptions::LineItem.new(amount: 100, line_item_key: 'salary'),
          ServiceFunctions::HandleErrors::Exceptions::LineItem.new(amount: 150, line_item_key: 'bonus'),
          ServiceFunctions::HandleErrors::Exceptions::LineItem.new(amount: 200, line_item_key: 'meal_voucher')
        ]
      )
    end
    context 'given correct employee payroll' do
      let(:expected_result) do
        ServiceFunctions::HandleErrors::Exceptions::CalculatedEmployeePayroll.new(
          employee_id: 1,
          total: 450,
          taxable: 350,
          exempt: 100
        )
      end
      it 'then returns expected calculated employee payroll' do
        expect(when_calculating_employee_payroll).to eq expected_result
      end
    end
  end
end
