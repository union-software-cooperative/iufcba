class Rec < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  
  belongs_to :company
  belongs_to :union
  belongs_to :person
  has_many :posts, :as => :parent
  
  has_many :division_recs
  has_many :divisions, through: :division_recs
  
  validates :name, :company, :union, :person, :end_date, presence: true
  validate :is_authorized?
  #validates :union_mandate_page, :anti_precariat_page, :specific_rights_page, :grievance_handling_page, numericality: { allow_blank: true }

  serialize :nature_of_operation, Array

  acts_as_followable

  def type
    self.class.to_s
  end

  def authorizer=(person)
    @authorizer = person
  end

  def is_authorized?(person = nil)
    @authorizer = person unless person.blank?
    
    if @authorizer.blank?
      errors.add(:authorizer, "hasn't be specified, so this agreement update cannot be made.")
      return
    end

    if @authorizer.union.short_name != ENV['OWNER_UNION']
      if self.union_id != @authorizer.union_id
        errors.add(:union, "is not your union so this assignment is not authorized.")
      end 

      if self.person.present? && self.person.union_id != @authorizer.union_id
        errors.add(:person, "is not a colleague from your union so this assignment is not authorized.")
      end
    end
  end
end
