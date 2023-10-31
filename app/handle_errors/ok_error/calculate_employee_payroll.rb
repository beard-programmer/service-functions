# frozen_string_literal: true

module ServiceFunctions
  module HandleErrors
    module OkError
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
          build_result = reduce_collection(line_items, build_line_item_with_policy_fn)
          return build_result if build_result in [:error, _]

          build_result => [:ok, line_items_with_policies]

          # Step 3: calculate taxes for each line item using Dependency
          calculation_result = reduce_collection(line_items_with_policies, calculate_taxes_fn)
          return calculation_result if calculation_result in [:error, _]

          calculation_result => [:ok, calculated_line_items]

          # Step 4: build CalculatedEmployeePayroll
          # Step 5: return it
          calculated = build_calculated_employee_payroll(
            employee_payroll, calculated_line_items
          )
          [:ok, calculated]
        end

        private

        # @param [Array(any)] collection
        # @param [Lambda] operation
        # @return [Array(Symbol, Array(any))] when :ok
        # @return [Array(Symbol, String)] when :error
        def reduce_collection(collection, operation)
          collection.reduce([:ok, []]) do |collection_result, element|
            case [collection_result, element]
            in [[:error, reason], _] then [:error, reason]
            in [[:ok, _], [:error, reason]] then [:error, reason]
            else
              operation_result = operation.call(element)
              case operation_result
              in [:ok, element] then
                collection_result => [_, collection]
                [:ok, collection + [element]]
              else
                operation_result => [_, reason]
                [:error, reason]
              end
            end
          end
        end

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
