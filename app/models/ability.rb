class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :approve, Friendship do |friendship|
        friendship.friend_id == user.id
    end

    can :ignore, Friendship do |friendship|
        friendship.friend_id == user.id
    end

    can :destroy, Friendship do |friendship|
        ((friendship.user_id == user.id) or (friendship.friend_id == user.id)) and (friendship.approved == true)
    end

    can :create, List do |list|
        list.user_id == user.id
    end

    can :destroy, List do |list|
        list.user_id == user.id
    end

    can :create, Item do |item|
        item.list.user_id == user.id
    end

    can :add, Item do |item|
        item.list.user_id == user.id
    end

    can :destroy, Item do |item|
        item.list.user_id == user.id
    end

    can :destroy, Comment do |comment|
        comment.user_id == user.id
    end

    can :change_privacy, List do |list|
        list.user_id == user.id
    end



    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
