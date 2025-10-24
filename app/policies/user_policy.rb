class UserPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  attr_reader :user

  def initialize(user, _record)
    @user = user
  end

  def index?
    user.admin? || user.manager?
  end

  def show?
    user.admin? || user.manager?
  end

  def create?
    user.admin? || user.manager?
  end

  def new?
    create?
  end

  def update?
    user.admin? || user.manager?
  end

  def destroy?
    user.admin?
  end

  def show_side?
    user.admin? || user.manager?
  end

  def show_side_user?
    user.admin? || user.manager?
  end

  def show_side_player?
    user.admin? || user.manager? || user.member?
  end

  def show_side_movie?
    user.admin? || user.manager? || user.member?
  end
  def show_side_screen?
    user.admin? || user.manager? || user.member?
  end
  def show_side_club?
    user.admin? || user.manager? || user.member?
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
