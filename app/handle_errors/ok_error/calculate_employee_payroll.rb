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
        # @return [Array(Symbol, ServiceFunctions::HandleErrors::OkError::CalculatedEmployeePayroll)] when success
        # @return [Array(Symbol, String)] when failed
        # @return [] [:ok, data] or [:error, reason]
        def call(
          build_line_item_with_policy_fn, # Dependency
          calculate_taxes_fn, # Dependency
          employee_payroll # Actual input value
        )
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

        #
        # # @param [Proc] build_line_item_with_policy_fn - Dependency,
        # # that responds to #call with an LineItem argument
        # # and returns LineItemWithPolicy
        # # @param [Proc] calculate_taxes_fn - Dependency,
        # # that responds to #call with an argument LineItemWithPolicy
        # # and returns CalculatedLineItem
        # # @param [ServiceFunctions::HandleErrors::OkError::EmployeePayroll] employee_payroll
        # # @return [Array(Symbol, String)]
        # # @return [Array(Symbol, ServiceFunctions::HandleErrors::OkError::CalculatedEmployeePayroll)]
        # # @return [] [:ok, data] or [:error, reason]
        # def call_one_return(
        #   build_line_item_with_policy_fn, # Dependency
        #   calculate_taxes_fn, # Dependency
        #   employee_payroll # Actual input value
        # )
        #   # # Step 1, 2: receive line items and build line items with policy using Dependency
        #   results = employee_payroll.line_items.map { |line_item| build_line_item_with_policy_fn.call(line_item) }
        #   case results
        #   in [*, [:error, reason], *] then [:error, "Failed to calculate employees payroll. #{reason}"]
        #   else
        #     # Step 3: calculate taxes for each line item using Dependency
        #     results = results.map { |(_ok, item)| calculate_taxes_fn.call(item) }
        #     case results
        #     in [*, [:error, reason], *] then [:error, "Failed to calculate employees payroll. #{reason}"]
        #     else
        #       calculated_line_items = results.map { |(_ok, item)| item }
        #
        #       # Step 4, 5: build payroll and return success
        #       [:ok, build_calculated_employee_payroll(employee_payroll, calculated_line_items)]
        #     end
        #   end
        # end

        # @param [ServiceFunctions::HandleErrors::OkError::EmployeePayroll] employee_payroll
        # @param [Array<ServiceFunctions::HandleErrors::OkError::CalculatedLineItem>] line_items
        # @returns [ServiceFunctions::HandleErrors::OkError::CalculatedEmployeePayroll]
        def build_calculated_employee_payroll(employee_payroll, line_items)
          total, taxable, exempt = line_items.reduce([0, 0, 0]) do |(total, taxable, exempt), line_item|
            [total + line_item.amount, taxable + line_item.taxable, exempt + line_item.exempt]
          end

          CalculatedEmployeePayroll.new(
            employee_id: employee_payroll.employee_id,
            total:,
            taxable:,
            exempt:
          )
        end
      end
    end
  end
end
