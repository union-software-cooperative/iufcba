class Post < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  belongs_to :person
  belongs_to :parent, polymorphic: true
  has_many :comments, :dependent => :delete_all # delete all, just deletes the comments without loading them first and triggering call backs

  acts_as_likeable
end
