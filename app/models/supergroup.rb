class Supergroup < ActiveRecord::Base
  # Used for index searching
  include Filterable
  scope :name_like, -> (name) {where("name ilike ?", "%#{name}%")}
  mount_uploader :banner, BannerUploader
  mount_uploader :logo, LogoUploader
  
  has_many :posts, as: :parent
  
  has_many :division_supergroups, dependent: :destroy
  has_many :divisions, through: :division_supergroups
  
  validates :name, :short_name, presence: true

  acts_as_followable
end
