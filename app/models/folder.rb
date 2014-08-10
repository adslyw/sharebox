class Folder < ActiveRecord::Base
  attr_accessible :name, :parent_id, :user_id
  acts_as_tree
  belongs_to :user
  has_many   :assets, :dependent => :destroy
  has_many   :shared_folders, :dependent => :destroy

  def shared?
    !self.shared_folders.empty?
  end
end
