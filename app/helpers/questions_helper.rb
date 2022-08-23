module QuestionsHelper
  def delete_question(question)
    link_to t('.delete'),
            question_path(question),
            method: :delete,
            data: { confirm: t('.delete_confirmation') }
  end

  def edit_question(question)
    link_to t('.edit'),
            '#',
            class: 'edit-question-link'
  end
end
