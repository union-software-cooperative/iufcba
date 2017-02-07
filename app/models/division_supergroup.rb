class DivisionSupergroup < ActiveRecord::Base
  belongs_to :division
  # belongs_to :supergroup
  belongs_to :company, foreign_key: "supergroup_id"
  belongs_to :union, foreign_key: "supergroup_id"
end
