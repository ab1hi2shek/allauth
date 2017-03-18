class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= current_user

    if user.superuser?
      can :manage, :all
      can :access, :rails_admin
      can :access, :dashboard
    elsif user.supervisor?
      can :manage, Post, user_id: user.id
      can :manage, Forum
      cannot :access, :rails_admin
    else
        can :read, Post
        can :manage, Forum, id: user.id
        cannot :access, :rails_admin
    end

  end
end