class Listship < ActiveRecord::Base
  attr_accessible :followlist_id, :user_id

  belongs_to :user
  belongs_to :followlist, :class_name => "List", :foreign_key => "followlist_id"

end
