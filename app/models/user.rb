class User < ActiveRecord::Base
	has_many :visits
	has_many :countries, :through => :visits, :uniq => true

	def currencies
		self.countries.map{|country| country.currencies}.flatten
	end

end
