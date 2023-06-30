class Answer < ApplicationRecord
  include Voteable

  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  before_destroy :before_destroy_nullify_best_answer_for_question

  def mark_as_best
    question.update(best_answer_id: self.id)
    user.trophies.push(question.trophy) if question.trophy
  end

  def append_files=(attachables)
    files.attach(attachables)
  end

  private

  def before_destroy_nullify_best_answer_for_question
    question.update(best_answer_id: nil) if question.best_answer == self
  end
end
