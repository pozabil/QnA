module QuestionsHelper
  def delete_question(question)
    link_to t('.delete'),
            question_path(question),
            method: :delete,
            data: { confirm: t('helpers.questions_helper.delete_confirmation') }
  end
end
