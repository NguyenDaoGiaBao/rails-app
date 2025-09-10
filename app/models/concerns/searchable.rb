module Searchable
  extend ActiveSupport::Concern

  class_methods do
    def search_by_title(query)
      return all if query.blank?
      where("title ILIKE ?", "%#{query}%")
    end
  end
end