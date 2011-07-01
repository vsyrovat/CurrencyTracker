class User < ActiveRecord::Base
#	has_and_belongs_to_many :countries, :join_table => "user_2_country", :association_foreign_key => 'country_code'
	has_many :visits
	has_many :countries, :through => :visits

	def currencies
		self.countries.map{|country| country.currencies}.flatten
	end

end
