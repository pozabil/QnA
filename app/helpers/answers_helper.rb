module AnswersHelper
  def delete_answer(answer)
    link_to t('delete'),
            answer_path(answer),
            method: :delete,
            data: { confirm: t('.delete_confirmation') },
            remote: true
  end

  def edit_answer(answer)
    link_to t('edit'),
            '#',
            class: 'edit-answer-link',
            data: { answer_id: answer.id }
  end

  def mark_as_best(answer)
    button_to t('.mark_as_best'),
              mark_as_best_answer_path(answer),
              method: :patch,
              remote: true
  end
end
