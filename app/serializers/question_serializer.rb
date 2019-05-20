class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  belongs_to :user
  has_many :files, serializer: FileSerializer
  has_many :answers
  has_many :comments
  has_many :links
end
