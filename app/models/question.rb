class Question < ApplicationRecord
  include Voteable

  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true
  has_one :trophy, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :trophy, reject_if: :all_blank

  validates :title, :body, presence: true

  def append_files=(attachables)
    files.attach(attachables)
  end
end
