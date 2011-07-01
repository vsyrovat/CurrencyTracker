class Country < ActiveRecord::Base
  set_primary_key :code
  attr_accessible :name, :code, :visited

  validates_presence_of :name
  validates_presence_of :code
  validates_uniqueness_of :code, :allow_blank => true

  has_many :currencies
  has_many :visits
  has_many :users, :through => :visits
#  has_and_belongs_to_many :users, :join_table => "user_2_country"

  accepts_nested_attributes_for :currencies, :allow_destroy => true

  scope :visited, :conditions => { :visited => true }
  scope :not_visited, :conditions => { :visited => false }

end