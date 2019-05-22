class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_one :award, dependent: :destroy
  include Voteable
  include Commentable

  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  has_many_attached :files

  after_save { id = self.id }

  validates :title, :body, presence: true
end
