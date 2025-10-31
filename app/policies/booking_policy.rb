# app/policies/booking_policy.rb
class BookingPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    user.admin? || user.manager?
  end
end