# frozen_string_literal: true

require_relative 'line_item'
require_relative 'build_line_item_with_policy'

RSpec.describe ServiceFunctions::HandleErrors::OkError::BuildLineItemWithPolicy, type: :service_function do
  describe '.call' do
    subject(:when_building_line_item_with_policy) do
      described_class.call(line_item)
    end

    context 'given correct line item' do
      [[100, 'salary'], [150, 'meal_voucher'], [200, 'bonus']].each do |(amount, line_item_key)|
        context 'with correct line item' do
          let(:line_item) do
            ServiceFunctions::HandleErrors::OkError::LineItem.new(amount:, line_item_key:)
          end

          it 'then returns expected ok and line item with policy' do
            expect(
              when_building_line_item_with_policy
            ).to(
              match(
                [:ok, an_instance_of(ServiceFunctions::HandleErrors::OkError::LineItemWithPolicy)]
              )
            )
          end
        end
      end
    end

    context 'given nil instead of line item' do
      let(:line_item) { nil }
      it 'then returns error and a message' do
        expect(when_building_line_item_with_policy).to(match([:error, an_instance_of(String)]))
      end
    end

    context 'given line item with unknown key' do
      let(:line_item) do
        ServiceFunctions::HandleErrors::OkError::LineItem.new(amount: 100, line_item_key: 'some-key')
      end

      it 'then returns error and a message' do
        expect(when_building_line_item_with_policy).to(match([:error, an_instance_of(String)]))
      end
    end
  end
end
