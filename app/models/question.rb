class Question < ApplicationRecord
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true
  has_many :answers, dependent: :destroy

  has_many_attached :files

  validates :title, :body, presence: true
end
