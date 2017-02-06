class Division < ActiveRecord::Base
  mount_uploader :logo, LogoUploader
  validates :name, :short_name, presence: true
  
  has_many :division_recs
  has_many :recs, through: :division_recs
  
  has_many :division_supergroups
  has_many :supergroups, through: :division_supergroups
  
  # def method_missing(m, **args)
  #   Rails.application.routes.url_helpers.send(m, { division_id: self.id }.merge(args))
  # end
end
