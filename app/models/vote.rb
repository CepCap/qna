class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :vote_type, inclusion: { in: [1, -1] }
end
