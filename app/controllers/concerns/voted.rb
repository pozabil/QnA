module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: [:upvote, :downvote]
  end

  def upvote
    return if @voteable.user == current_user

    smart_upvote!
    render_json
  end

  def downvote
    return if @voteable.user == current_user

    smart_downvote!
    render_json
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
  end

  def smart_upvote!
    user_voteable = @voteable.user_voteables.find_or_create_by(user: current_user)
    user_voteable.up? ? user_voteable.no_impact! : user_voteable.up!
  end

  def smart_downvote!
    user_voteable = @voteable.user_voteables.find_or_create_by(user: current_user)
    user_voteable.down? ? user_voteable.no_impact! : user_voteable.down!
  end
  
  def render_json
    render json: { model_klass.name.underscore => { id: @voteable.id, rating: @voteable.rating, action: action_name} } if @voteable.update_rating
  end
end
