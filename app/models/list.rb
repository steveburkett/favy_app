class List < ActiveRecord::Base
  attr_accessible :title, :user_id, :privacy

  validates_presence_of :title

  belongs_to :user
  has_many :items, dependent: :destroy

  has_many :listships
  has_many :users, :through => :listships, :source => :user

end
