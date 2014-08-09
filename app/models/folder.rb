class Folder < ActiveRecord::Base
  attr_accessible :name, :parent_id, :user_id
  acts_as_tree
  belongs_to :user
  has_many   :assets, :dependent => :destroy
end
