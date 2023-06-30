class UserVoteable < ApplicationRecord
  enum impact: { down: -1, no_impact: 0, up: 1 }

  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :user, uniqueness: { scope: [:voteable_id, :voteable_type] }
end
