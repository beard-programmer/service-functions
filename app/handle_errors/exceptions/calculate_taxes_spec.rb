# frozen_string_literal: true

require_relative 'calculate_taxes'
require_relative 'line_item'

RSpec.describe ServiceFunctions::HandleErrors::Exceptions::CalculateTaxes, type: :service_function do
  describe '.call' do
    subject(:when_calculating_taxes) do
      described_class.call(line_item_with_policy)
    end

    context 'given line item with policy' do
      let(:line_item_with_policy) do
        ServiceFunctions::HandleErrors::Exceptions::LineItemWithPolicy.new(
          amount: 100,
          line_item_key: 'salary',
          tax_policy: 'TAXABLE'
        )
      end

      it 'then should calculate taxes and return CalculatedLineItem' do
        expect(when_calculating_taxes).to be_instance_of(ServiceFunctions::HandleErrors::Exceptions::CalculatedLineItem)
      end
    end

    context 'given line item with unknown policy' do
      let(:line_item_with_policy) do
        ServiceFunctions::HandleErrors::Exceptions::LineItemWithPolicy.new(
          amount: 100,
          line_item_key: 'salary',
          tax_policy: 'some-random-policy'
        )
      end
      it 'then should raise an error' do
        expect { when_calculating_taxes }.to(
          raise_error(ServiceFunctions::HandleErrors::Exceptions::CalculateTaxes::InvalidInput)
        )
      end
    end

    [
      nil,
      123,
      'Sooome',
      '',
      ServiceFunctions::HandleErrors::Exceptions::LineItemWithPolicy.new(
        amount: nil,
        line_item_key: 'salary',
        tax_policy: 'TAXABLE'
      ),
      ServiceFunctions::HandleErrors::Exceptions::LineItemWithPolicy.new(
        amount: [],
        line_item_key: 'salary',
        tax_policy: 'EXEMPT'
      ),
      ServiceFunctions::HandleErrors::Exceptions::LineItemWithPolicy.new(
        amount: 'asdasdasd',
        line_item_key: 'salary',
        tax_policy: 'TAXABLE'
      )
    ].each do |invalid_input|
      context 'given invalid input' do
        let(:line_item_with_policy) { invalid_input }

        it 'then should raise an error' do
          expect { when_calculating_taxes }.to(
            raise_error(ServiceFunctions::HandleErrors::Exceptions::CalculateTaxes::InvalidInput)
          )
        end
      end
    end
  end
end
