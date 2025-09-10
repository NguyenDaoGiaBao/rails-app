class Task < ApplicationRecord
  validates :title,
            presence: { message: "Task name is required" },
            length: {
              minimum: 2,
              maximum: 50,
              too_short: "Task name must be at least %{count} characters",
              too_long: "Task name must be at most %{count} characters"
            }
  validates :description,
            presence: { message: "Description is required" },
            length: {
              minimum: 2,
              too_short: "Description must be at least %{count} characters",
            }
  validates :due_date,
            presence: { message: "Due date is required" }

  enum :priority, {
    Low: 1,
    Middle: 2,
    Hight: 3,
  }
end
