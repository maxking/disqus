class Startup < ActiveRecord::Base
	has_many :comments

	def self.rake_create(startup_id,project_id, company_name, email)
		Startup.create(:id => params['startup_id'] ,:project_id => params['project_id'], :name => params['company_name'], :email => ['email'])
	end
end
