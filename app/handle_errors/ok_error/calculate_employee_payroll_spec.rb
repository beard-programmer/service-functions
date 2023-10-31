# frozen_string_literal: true

require_relative 'line_item'
require_relative 'employee_payroll'
require_relative 'calculate_employee_payroll'
require_relative 'calculate_taxes'

RSpec.describe ServiceFunctions::HandleErrors::OkError::CalculateEmployeePayroll, type: :service_function do
  describe '.call' do
    subject(:when_calculating_employee_payroll) do
      described_class.call(
        ServiceFunctions::HandleErrors::OkError::BuildLineItemWithPolicy,
        ServiceFunctions::HandleErrors::OkError::CalculateTaxes,
        employee_payroll
      )
    end

    context 'given correct employee payroll' do
      let(:employee_payroll) do
        ServiceFunctions::HandleErrors::OkError::EmployeePayroll.new(
          employee_id: 1, line_items: [
            ServiceFunctions::HandleErrors::OkError::LineItem.new(amount: 100, line_item_key: 'salary'),
            ServiceFunctions::HandleErrors::OkError::LineItem.new(amount: 150, line_item_key: 'bonus'),
            ServiceFunctions::HandleErrors::OkError::LineItem.new(amount: 200, line_item_key: 'meal_voucher')
          ]
        )
      end

      let(:calculated_employee_payroll) do
        ServiceFunctions::HandleErrors::OkError::CalculatedEmployeePayroll.new(
          employee_id: 1,
          total: 450,
          taxable: 350,
          exempt: 100
        )
      end

      it 'then returns success with calculated employee payroll' do
        expect(when_calculating_employee_payroll).to eq([:ok, calculated_employee_payroll])
      end
    end

    context 'given invalid employee payroll' do
      let(:employee_payroll) do
        ServiceFunctions::HandleErrors::OkError::EmployeePayroll.new(
          employee_id: 1, line_items: [
            ServiceFunctions::HandleErrors::OkError::LineItem.new(amount: nil, line_item_key: 'salary'),
            ServiceFunctions::HandleErrors::OkError::LineItem.new(amount: 150, line_item_key: 'bonus'),
            ServiceFunctions::HandleErrors::OkError::LineItem.new(amount: 200, line_item_key: 'meal_voucher')
          ]
        )
      end

      it 'then returns an error' do
        expect(when_calculating_employee_payroll).to(match([:error, be_instance_of(String)]))
      end
    end
  end
end
