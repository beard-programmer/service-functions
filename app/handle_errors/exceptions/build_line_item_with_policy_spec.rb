# frozen_string_literal: true

require_relative 'line_item'
require_relative 'build_line_item_with_policy'

RSpec.describe ServiceFunctions::HandleErrors::Exceptions::BuildLineItemWithPolicy, type: :service_function do
  describe '.call' do
    subject(:when_building_line_item_with_policy) do
      described_class.call(line_item)
    end

    context 'given correct line item' do
      [[100, 'salary'], [150, 'meal_voucher'], [200, 'bonus']].each do |(amount, line_item_key)|
        context 'with correct line item' do
          let(:line_item) do
            ServiceFunctions::HandleErrors::Exceptions::LineItem.new(amount:, line_item_key:)
          end

          it 'then returns expected line item with policy' do
            expect(
              when_building_line_item_with_policy
            ).to(be_instance_of(ServiceFunctions::HandleErrors::Exceptions::LineItemWithPolicy))
          end
        end
      end
    end

    context 'given nil instead of line item' do
      let(:line_item) { nil }
      it 'then raises an error' do
        expect do
          when_building_line_item_with_policy
        end.to raise_error(ServiceFunctions::HandleErrors::Exceptions::BuildLineItemWithPolicy::InvalidInput)
      end
    end

    context 'given line item with unknown key' do
      let(:line_item) do
        ServiceFunctions::HandleErrors::Exceptions::LineItem.new(amount: 100, line_item_key: 'some-key')
      end
      it 'then raises an error' do
        expect do
          when_building_line_item_with_policy
        end.to raise_error(ServiceFunctions::HandleErrors::Exceptions::BuildLineItemWithPolicy::PolicyNotFound)
      end
    end
  end
end
