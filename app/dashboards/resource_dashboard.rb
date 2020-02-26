# frozen_string_literal: true

require 'administrate/base_dashboard'

class ResourceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    resource_category: Field::BelongsTo,
    id: Field::Number,
    state: Field::String,
    time: Field::Text,
    cost: Field::Text,
    award: Field::Text,
    likelihood: Field::Text,
    safety: Field::Text,
    story: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    who: Field::Text,
    when: Field::Text,
    covered_expenses: Field::Text,
    attorney: Field::Text,
    tips: Field::Text,
    where: Field::Text,
    resources: Field::Text,
    steps: Field::Text,
    challenges: Field::Text,
    what_to_expect: Field::Text,
    what_if_i_disagree: Field::Text
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    state
    who
    resource_category
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    resource_category
    id
    state
    time
    cost
    award
    likelihood
    safety
    story
    created_at
    updated_at
    who
    when
    covered_expenses
    attorney
    tips
    where
    resources
    steps
    challenges
    what_to_expect
    what_if_i_disagree
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    resource_category
    state
    time
    cost
    award
    likelihood
    safety
    story
    who
    when
    covered_expenses
    attorney
    tips
    where
    resources
    steps
    challenges
    what_to_expect
    what_if_i_disagree
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how resources are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(resource)
  #   "Resource ##{resource.id}"
  # end
end
