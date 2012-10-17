class Item < ActiveRecord::Base
  attr_accessible :name, :location, :category

  validates_presence_of :name

  belongs_to :list
  has_many :comments, dependent: :destroy

end
