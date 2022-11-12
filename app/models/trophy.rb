class Trophy < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image

  validates :title, presence: true
  validates :image, attached: true,
                    content_type: ['image/png', 'image/jpeg', 'image/gif'],
                    size: { less_than: 1.megabyte }
end
