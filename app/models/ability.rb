class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    if user.superuser?
      can :manage, :all
      can :access, :rails_admin
      can :access, :dashboard
    end
    if user.supervisor?
      can :manage, Post, user_id: user.id
      can :read, Post
      can :manage, [Forum, Comment, Tag]
      cannot :access, :rails_admin
    end
    if user.normal?
        can :read, [Post, Forum, Comment, Tag]
        can :manage, Forum, user_id: user.id
        can :manage, Comment, user_id: user.id
        cannot :access, :rails_admin
    end

  end
end