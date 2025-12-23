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

  #custom validation for documenet uploada
  validate :validate_uploaded_document                  # -- validates -> for built-in validations like presence, length, format
                                                        # -- validate -> for custom validations

  # for action text
  # validates :description, presence: true, if: -> { description&.body&.to_plain_text.present? }

  def validate_uploaded_document
    return unless uploaded_document.attached?

    #arr of all allowed types
    allowed_types = [
      "application/pdf",
      "application/msword", 
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document", # .docx
      "text/csv", 
      "text/plain"
    ]

    #check for file type
    unless allowed_types.include?(uploaded_document.content_type)
      errors.add(:uploaded_document, "File must be a Pdf, doc, docx, txt and csv.")
    end

    #check for file's size
    if uploaded_document.byte_size > 10.megabytes
      errors.add(:uploaded_document, "File size can't be more than 10MB.")
    end
  end

  #show page method
  def free_plan_limit_reached?
    users.count >= 7 && subscription_status == "free"
  end

end
