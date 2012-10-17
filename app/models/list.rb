class List < ActiveRecord::Base
  attr_accessible :title, :user_id, :privacy, :tag_list, :sort_by

  validates_presence_of :title

  belongs_to :user
  has_many :items, dependent: :destroy

  has_many :listships
  has_many :users, :through => :listships, :source => :user

  acts_as_taggable

end
