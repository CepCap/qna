class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :award

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  has_many_attached :files

  belongs_to :author, class_name: 'User', foreign_key: :author_id

  validates :title, :body, presence: true
end
