class Union < Supergroup
  has_many :people
  has_many :recs
  
  has_many :division_supergroups, foreign_key: "supergroup_id" #, inverse_of: :supergroup
  has_many :divisions, through: :division_supergroups
end
