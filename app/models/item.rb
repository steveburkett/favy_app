class Item < ActiveRecord::Base
  attr_accessible :name, :initial_comment

  validates_presence_of :name

  belongs_to :list
  has_many :comments, dependent: :destroy
  
  belongs_to :location
  belongs_to :category

  def category_name
    category.try(:name)
  end

  def category_name=(name)
    self.category = Category.find_or_create_by_name(name) if name.present?
  end

  def location_name
    location.try(:name)
  end

  def location_name=(name)
    self.location = Location.find_or_create_by_name(name) if name.present?
  end



end
