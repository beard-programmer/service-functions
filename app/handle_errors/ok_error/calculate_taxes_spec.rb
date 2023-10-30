# frozen_string_literal: true

require_relative 'calculate_taxes'
require_relative 'line_item'

RSpec.describe ServiceFunctions::HandleErrors::OkError::CalculateTaxes, type: :service_function do
  describe '.call' do
    subject(:when_calculating_taxes) do
      described_class.call(line_item_with_policy)
    end

    context 'given line item with policy' do
      let(:line_item_with_policy) do
        ServiceFunctions::HandleErrors::OkError::LineItemWithPolicy.new(
          amount: 100,
          line_item_key: 'salary',
          tax_policy: 'TAXABLE'
        )
      end

      it 'then should successfully calculate taxes and return CalculatedLineItem' do
        expect(when_calculating_taxes)
          .to(match([:ok, be_instance_of(ServiceFunctions::HandleErrors::OkError::CalculatedLineItem)]))
      end
    end

    context 'given line item with unknown policy' do
      let(:line_item_with_policy) do
        ServiceFunctions::HandleErrors::OkError::LineItemWithPolicy.new(
          amount: 100,
          line_item_key: 'salary',
          tax_policy: 'some-random-policy'
        )
      end

      it 'then should return error with reason' do
        expect(when_calculating_taxes).to(match([:error, be_instance_of(String)]))
      end
    end

    [
      nil,
      123,
      'Sooome',
      '',
      ServiceFunctions::HandleErrors::OkError::LineItemWithPolicy.new(
        amount: nil,
        line_item_key: 'salary',
        tax_policy: 'TAXABLE'
      ),
      ServiceFunctions::HandleErrors::OkError::LineItemWithPolicy.new(
        amount: [],
        line_item_key: 'salary',
        tax_policy: 'EXEMPT'
      ),
      ServiceFunctions::HandleErrors::OkError::LineItemWithPolicy.new(
        amount: 'asdasdasd',
        line_item_key: 'salary',
        tax_policy: 'TAXABLE'
      )
    ].each do |invalid_input|
      context 'given invalid input' do
        let(:line_item_with_policy) { invalid_input }

        it 'then should return error with reason' do
          expect(when_calculating_taxes).to(match([:error, be_instance_of(String)]))
        end
      end
    end
  end
end
