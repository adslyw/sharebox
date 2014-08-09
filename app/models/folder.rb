class Folder < ActiveRecord::Base
  attr_accessible :name, :parent_id, :user_id

  belongs_to :user
end
