class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached :files

  belongs_to :author, class_name: 'User', foreign_key: :author_id

  validates :title, :body, presence: true
end
