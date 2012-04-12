class Startup < ActiveRecord::Base
	has_many :comments

	def self.rake_create(project_id, company_name, email)
		Startup.create(:project_id => project_id, :name => company_name, :email => email)
	end
end
