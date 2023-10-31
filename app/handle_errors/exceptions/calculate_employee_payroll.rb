# frozen_string_literal: true

module ServiceFunctions
  module HandleErrors
    module Exceptions
      module CalculateEmployeePayroll
        class CalculationError < StandardError; end

        extend self

        # @param build_line_item_with_policy_fn [#call] - Dependency,
        # that responds to #call with an LineItem argument
        # and returns LineItemWithPolicy
        # @param calculate_taxes_fn [#call] - Dependency,
        # that responds to #call with an argument LineItemWithPolicy
        # and returns CalculatedLineItem
        # @param employee_payroll [EmployeePayroll]
        # @raise [CalculationError]
        # @returns [CalculatedEmployeePayroll]
        def call(
          build_line_item_with_policy_fn, # Dependency
          calculate_taxes_fn, # Dependency
          employee_payroll # Actual input value
        )
          # Step 1: receive line items.
          line_items = employee_payroll.line_items

          # Step 2: Build line items with policy using Dependency
          line_items_with_policies = line_items.map do |line_item|
            build_line_item_with_policy_fn.call(line_item) # Dependency
          rescue ServiceFunctions::HandleErrors::Exceptions::CalculateTaxes::InvalidInput,
                 ServiceFunctions::HandleErrors::Exceptions::CalculateTaxes::PolicyNotFound => e
            raise CalculationError, "Failed to build line item with policy: #{e.message}"
          end

          # Step 3: calculate taxes for each line item using Dependency
          calculated_line_items = line_items_with_policies.map do |item_with_policy|
            calculate_taxes_fn.call(item_with_policy) # Dependency
          rescue ServiceFunctions::HandleErrors::Exceptions::CalculateTaxes::InvalidInput => e
            raise CalculationError, "Failed to calculate taxes: #{e.message}"
          end

          # Step 4: build CalculatedEmployeePayroll
          # Step 5: return it
          build_calculated_employee_payroll(
            employee_payroll, calculated_line_items
          )
        end

        private

        # @param employee_payroll [EmployeePayroll]
        # @param line_items [Array<CalculatedLineItem>]
        # @returns [CalculatedEmployeePayroll]
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
