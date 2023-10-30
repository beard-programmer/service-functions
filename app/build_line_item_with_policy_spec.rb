# frozen_string_literal: true

require_relative 'line_item'
require_relative 'build_line_item_with_policy'

RSpec.describe ServiceFunctions::BuildLineItemWithPolicy, type: :service_function do
  describe '.call' do
    subject(:when_building_line_item_with_policy) do
      described_class.call(line_item)
    end

    context 'given correct line item' do
      [[100, 'salary'], [150, 'meal_voucher'], [200, 'bonus']].each do |(amount, line_item_key)|
        context 'with correct line item' do
          let(:line_item) do
            ServiceFunctions::LineItem.new(amount:, line_item_key:)
          end

          it 'then returns expected line item with policy' do
            expect(
              when_building_line_item_with_policy
            ).to(be_instance_of(ServiceFunctions::LineItemWithPolicy))
          end
        end
      end
    end
  end
end
