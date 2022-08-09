module AnswersHelper
  def delete_answer(answer)
    link_to t('delete'),
            answer_path(answer),
            method: :delete,
            data: { confirm: t('.delete_confirmation') }
  end

  def edit_answer(answer)
    link_to t('edit'),
            '#',
            class: 'edit-answer-link',
            data: { answer_id: answer.id }
  end
end
