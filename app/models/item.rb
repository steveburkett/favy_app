class Item < ActiveRecord::Base
  attr_accessible :name

  belongs_to :list
  has_many :comments, dependent: :destroy

end
