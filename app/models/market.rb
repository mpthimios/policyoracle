class Market < ActiveRecord::Base
	has_many :contracts

	# you need to add a position column to desired table:
	# acts_as_list

	CATEGORY_TYPES = ['Economics', 'Politics', 'Environment']

	validates_presence_of :name, :description, :published_date, :arbitration_date
	validates_length_of :name, :maximum => 255
	validates_uniqueness_of :name
	validates_inclusion_of :category, :in => CATEGORY_TYPES, :message => "must be one of: #{CATEGORY_TYPES.join(',')}"
	validates_presence_of :category

  	scope :sorted, lambda { order("markets.id ASC")}
  	scope :newest_first, lambda { order("markets.published_date DESC")}
end
