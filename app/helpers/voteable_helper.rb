module VoteableHelper
  def upvote_button(voteable)
    button_to t('upvote'),
              __send__("upvote_#{voteable.class.name.underscore}_path", voteable),
              method: :patch,
              remote: true,
              class: "upvote_button#{' active' if voteable.user_rating_impact(current_user) == 'up'}",
              form_class: 'downvote_button_form'
  end

  def downvote_button(voteable)
    button_to t('downvote'),
              __send__("downvote_#{voteable.class.name.underscore}_path", voteable),
              method: :patch,
              remote: true,
              class: "downvote_button#{' active' if voteable.user_rating_impact(current_user) == 'down'}",
              form_class: 'downvote_button_form'
  end
end
