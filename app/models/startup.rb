class Startup < ActiveRecord::Base
	has_many :comments

	def self.rake_create(startup_id,project_id, company_name, email)
		Startup.create(:startup_id => startup_id ,:project_id => project_id, :name => company_name, :email => email)
	end
end
