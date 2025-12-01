class Project < ApplicationRecord
  belongs_to :company
  belongs_to :manager, class_name: "User", foreign_key: "manager_id", optional: true
  belongs_to :client, class_name: "User", foreign_key: "client_id", optional: true

  # has_rich_text :description
  has_one_attached :uploaded_document

  has_many :invitations, dependent: :destroy
  has_many :users
  has_many :tasks, dependent: :destroy

  # statuses enum
  enum :project_status, { pending: 0, working: 1, completed: 2 }, suffix: true

  # Validations
  validates :title, :project_status, :project_deadline, presence: true
  validates :description, presence: true

  # for action text
  # validates :description, presence: true, if: -> { description&.body&.to_plain_text.present? }

end
