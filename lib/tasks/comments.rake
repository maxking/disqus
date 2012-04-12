namespace :comment do

	desc "Task for fetching email"
	task :fetch => :environment do
		Comment.rake_fetch_email
	end

	desc "Task for relaying email"
	task :relay => :environment do
		Comment.rake_relay_email
	end

	desc "Task for creating startup on project submit"
	task :createstartup, [:project_id, :name, :email] => :environment  do |t, args|
		Startup.rake_create(args.project_id, args.name, args.email)
	end

end
