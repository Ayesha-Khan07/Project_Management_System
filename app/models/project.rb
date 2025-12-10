class Project < ApplicationRecord
  belongs_to :company
  belongs_to :manager, class_name: "User", foreign_key: "manager_id", optional: true
  belongs_to :client, class_name: "User", foreign_key: "client_id", optional: true

  # paper trail 
  has_paper_trail

  has_one_attached :uploaded_document

    #join table association
  has_many :projects_users, dependent: :destroy
  has_many :users, through: :projects_users

  has_many :invitations, dependent: :destroy
  has_many :tasks, dependent: :destroy
  

  # statuses enum
  enum :project_status, { pending: 0, working: 1, completed: 2 }, suffix: true

  # Validations
  validates :title, :project_status, :project_deadline, presence: true
  validates :description, presence: true
  validates :project_deadline, presence: true

  # for action text
  # validates :description, presence: true, if: -> { description&.body&.to_plain_text.present? }

end
