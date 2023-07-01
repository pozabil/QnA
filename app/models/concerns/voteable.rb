module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :user_voteables, dependent: :destroy, as: :voteable
  end

  def update_rating
    update(rating: user_voteables.sum(:impact))
  end

  def user_rating_impact(user)
    user_voteable = user_voteables.find_by(user: user)
    return if user_voteable.blank?

    user_voteable.impact
  end
end
