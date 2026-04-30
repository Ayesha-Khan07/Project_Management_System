class Task < ApplicationRecord
  belongs_to :project
  belongs_to :assigned_user, class_name: "User", foreign_key: "assigned_user_id"    # as the association name is not the cls name so that's why added the cls name. 

  has_many :comments, dependent: :destroy
  
  # paper trail 
  has_paper_trail

  # enums
  enum :task_type, { feature: 0, bug: 1, user_story: 2 }, suffix: true
  enum :task_status, { to_do: 0, in_progress: 1, to_verify: 2, done: 3 }, suffix: true
  enum :progress, { "0%" => 0, "25%" => 1, "50%" => 2, "75%" => 3, "100%" => 4 }, suffix: true

  # scopes
  scope :overdue, -> {
    where("estimated_deadline < ? ", Date.today)
    .where.not(task_status: :done)
  } 

  # validations
  validates :title, :task_type, :task_status, :progress, :assigned_user_id, :project_id, presence: true

end
