# frozen_string_literal: true

module ServiceFunctions
  module HandleErrors
    module Exceptions
      class LineItem < Data.define(:amount, :line_item_key); end
      class LineItemWithPolicy < Data.define(:amount, :line_item_key, :tax_policy); end
      class CalculatedLineItem < Data.define(:amount, :taxable, :exempt); end

      # Verb + anemic method call: Service function
      module BuildLineItemWithPolicy
        class InvalidInput < ArgumentError; end
        class PolicyNotFound < StandardError; end

        extend self

        # @param [ServiceFunctions::HandleErrors::Exceptions::CalculatedLineItem] line_item
        # @raise [PolicyNotFound]
        # @raise [InvalidInput]
        # @return [ServiceFunctions::HandleErrors::Exceptions::LineItemWithPolicy]
        def call(line_item)
          case line_item
          in amount:, line_item_key: then
            LineItemWithPolicy.new(
              amount:,
              line_item_key:,
              tax_policy: find_policy!(line_item_key)
            )
          else
            raise InvalidInput
          end
        end

        private

        # @param line_item_key [String]
        # @raise [PolicyNotFound]
        # @return [String]
        def find_policy!(line_item_key)
          case line_item_key
          in 'meal_voucher' then
            'EXEMPT'
          in 'bonus' | 'salary' then
            'TAXABLE'
          else
            raise PolicyNotFound, "Cant find policy for line item key #{line_item_key}"
          end
        end
      end
    end
  end
end
#
# module PavelL
#   extend self
#
#   # @param company [Company]
#   # @return [Array<Hash{Symbol => String, Array}>] an array of hashes
#   #   @option return [String] :identifier The identifier of the item.
#   #   @option return [Array<String>] :sub_items The sub-items of the item, which are strings.
#   def call(company)
#     feature_enabled = ->(key) { company.sidebar_overrides.include?(key) || is_auto_enabled?(key) }
#     features = SIDEBAR_FEATURES
#                .filter(&feature_enabled)
#                .map(&method(:build_feature))
#
#     update_company_features!(company, features) if features.any?
#     features
#   end
#
#   private
#
#   def build_feature(key)
#     sub_items = []
#     sub_items += %w[apps_browse apps_install] if key == 'app_store'
#     {
#       identifier: key,
#       sub_items:
#     }
#   end
#
#   def update_company_features!(company, features)
#     feature_ids = features.pluck(:identifier)
#
#     company_features = company.features
#     company_features.push('content') if feature_ids.include?('content') && company_features.exclude?('content')
#     company_sidebar_overrides = (company.sidebar_overrides + feature_ids).uniq
#
#     company.update!(features: company_features, sidebar_overrides: company_sidebar_overrides)
#   end
#
#   def is_auto_enabled?(key)
#     send("fetch_#{key}?")
#   end
# end

# line_item = 123
# ServiceFunctions::HandleErrors::Exceptions::BuildLineItemWithPolicy.call(line_item)
