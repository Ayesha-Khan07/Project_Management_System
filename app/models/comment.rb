class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  has_paper_trail

  #validation
  validates :body, presence: true
end
