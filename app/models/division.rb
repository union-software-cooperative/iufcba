class Division < ActiveRecord::Base
  mount_uploader :logo, LogoUploader
  validates :name, :short_name, presence: true
  
  has_many :division_recs, dependent: :destroy
  has_many :recs, through: :division_recs
  
  has_many :division_supergroups, dependent: :destroy
  has_many :companies, through: :division_supergroups
  has_many :unions, through: :division_supergroups
  
  translates :name, :short_name
  
  # def method_missing(m, **args)
  #   Rails.application.routes.url_helpers.send(m, { division_id: self.id }.merge(args))
  # end
end
