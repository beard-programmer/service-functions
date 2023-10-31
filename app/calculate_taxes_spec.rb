# frozen_string_literal: true

require_relative 'calculate_taxes'

RSpec.describe ServiceFunctions::CalculateTaxes, type: :service_function do
  describe '.call' do
    subject(:when_calculating_taxes) do
      described_class.call(line_item_with_policy)
    end

    context 'given line item with policy' do
      let(:line_item_with_policy) do
        ServiceFunctions::LineItemWithPolicy.new(amount: 100, line_item_key: 'salary', tax_policy: 'TAXABLE')
      end

      it 'then should calculate taxes and return CalculatedLineItem' do
        expect(when_calculating_taxes).to be_instance_of(ServiceFunctions::CalculatedLineItem)
      end
    end
  end
end
