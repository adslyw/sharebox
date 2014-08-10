class SharedFolder < ActiveRecord::Base
  attr_accessible :folder_id, :message, :shared_email, :shared_user_id, :user_id

  belongs_to :user
  belongs_to :shared_user, :class_name => 'User', :foreign_key => 'shared_user_id'
  belongs_to :folder
end
