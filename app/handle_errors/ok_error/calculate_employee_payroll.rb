# frozen_string_literal: true

require_relative 'employee_payroll'

module ServiceFunctions
  module HandleErrors
    module OkError
      module CalculateEmployeePayroll
        extend self

        # @param [Proc] build_line_item_with_policy_fn - Dependency,
        # that responds to #call with an LineItem argument
        # and returns LineItemWithPolicy
        # @param [Proc] calculate_taxes_fn - Dependency,
        # that responds to #call with an argument LineItemWithPolicy
        # and returns CalculatedLineItem
        # @param [ServiceFunctions::HandleErrors::OkError::EmployeePayroll] employee_payroll
        # @return [Array(Symbol, CalculatedEmployeePayroll)] when success [:ok, value]
        # @return [Array(Symbol, String)] when failed [:error, reason]
        def call(
          build_line_item_with_policy_fn, # Dependency
          calculate_taxes_fn, # Dependency
          employee_payroll # Actual input value
        )
          # Step 1: receive line items.
          # Step 1, 2: receive line items and build line items with policy using Dependency
          results = employee_payroll.line_items.map { |line_item| build_line_item_with_policy_fn.call(line_item) }
          if results in [*, [:error, reason], *]
            return [:error, "Failed to calculate employees payroll. #{reason}"]
          end

          # Step 3: calculate taxes for each line item using Dependency
          results = results.map { |(_, item)| calculate_taxes_fn.call(item) }
          if results in [*, [:error, reason], *]
            return [:error, "Failed to calculate employees payroll. #{reason}"]
          end

          calculated_line_items = results.map { |(_, item)| item }

          # Step 4: build CalculatedEmployeePayroll
          calculated = build_calculated_employee_payroll(
            employee_payroll, calculated_line_items
          )
          # Step 5: return it
          [:ok, calculated]
        end

        private

        # @param employee_payroll [ServiceFunctions::HandleErrors::OkError::EmployeePayroll]
        # @param line_items [Array<ServiceFunctions::HandleErrors::OkError::CalculatedLineItem>]
        # @returns [ServiceFunctions::HandleErrors::OkError::CalculatedEmployeePayroll]
        def build_calculated_employee_payroll(employee_payroll, line_items)
          employee_id = employee_payroll.employee_id
          total, taxable, exempt = line_items.reduce(
            [0, 0, 0],
            &->(
              (total, taxable, exempt),
              line_item
            ) { [total + line_item.amount, taxable + line_item.taxable, exempt + line_item.exempt] }
          )

          CalculatedEmployeePayroll.new(
            employee_id:,
            total:,
            taxable:,
            exempt:
          )
        end
      end
    end
  end
end
