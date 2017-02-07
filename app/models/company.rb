class Company < Supergroup
  has_many :recs
  
  has_many :division_supergroups, foreign_key: "supergroup_id", dependent: :destroy #, inverse_of: :supergroup
  has_many :divisions, through: :division_supergroups
end
