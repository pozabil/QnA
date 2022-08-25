class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  before_destroy :before_destroy_nullify_best_answer_for_question

  def mark_as_best
    question.update(best_answer_id: self.id)
  end

  def append_files=(attachables)
    files.attach(attachables)
  end

  private

  def before_destroy_nullify_best_answer_for_question
    question.update(best_answer_id: nil) if question.best_answer = self
  end
end
