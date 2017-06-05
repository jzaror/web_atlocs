class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    can :index, Location
    can :create, User
    can :delete_request, Location, user_id: user.id
    #can :cancel_modal, Booking, user_id: user.id
    can :edit, Booking, user_id: user.id
    can :update, Booking, user_id: user.id
    can :cancel_modal, Booking do |booking|
      if booking.user == user || booking.location.user == user
        true
      else
        false
      end
    end
    can :cancel_booking, Booking do |booking|
      if booking.user == user || booking.location.user == user
        true
      else
        false
      end
    end
    can :show, Location do |location|
        if location.status == "approved"
            true
        else
            false
        end
    end
    can :show, Collection
    can :index, Collection
    if user.status=="admin"
        can :manage, Location
        can :manage, Collection
        can :manage, User
        can :manage, Booking
        can :manage, Attachment
        can :manage, Conf
        can :confirmpayment, Booking
    end
    if user.id != nil
        # regular user
        can :show, User
        can :manage, User do |u|
            if u.id==user.id
                true
            else
                false
            end
        end
        can :price, Booking
        can :create, Location
        can :admin, Location
        can :create, Booking
        can :create, Attachment
        can :destroy, Attachment do |attachment|
            if attachment.location.user.id==user.id||attachment.location.user==nil
                true
            else
                false
            end
        end
        can :new, Booking
        can :index, Booking
        can :comment, Booking do |booking|
            if booking.user_id==user.id||booking.location.user_id==user.id
                true
            else
                false
            end
        end
        can :show, Booking do |booking|
            if booking.user_id==user.id||booking.location.user_id==user.id
                true
            else
                false
            end
        end
        can :request_removal, Location do |location|
            if location.user_id==user.id
                true
            else
                false
            end
        end
        can :show, Location do |location|
            if location.status == "approved" || location.user_id==user.id
                true
            else
                false
            end
        end
        can :edit, Location do |location|
            if location.user_id==user.id||location.user_id==nil
                true
            else
                false
            end
        end

        can :update, Location do |location|
            if location.user_id==user.id||location.user_id==nil
                true
            else
                false
            end
        end
        can :accept, Booking do |booking|
            if booking.location.user_id==user.id
                true
            else
                false
            end
        end
        can :cancel, Booking do |booking|
            if (booking.location.user_id==user.id||booking.user_id==user.id)&&(booking.status=="waiting"||booking.status=="accepted")
                true
            else
                false
            end
        end
        can :ignore, Booking do |booking|
            if booking.location.user_id==user.id
                true
            else
                false
            end
        end
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

  end
end
