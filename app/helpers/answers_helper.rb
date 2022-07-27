module AnswersHelper
  def delete_answer(answer)
    link_to t('.delete'),
            answer_path(answer),
            method: :delete,
            data: { confirm: t('.delete_confirmation') }
  end
end
