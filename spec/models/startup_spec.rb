require 'spec_helper'

describe Startup do
	

	it "should add new startup when a new project is submitted" do
		
		#this being called as rake comment:create_startup[1,"name","email"]

		lambda do
			Startup.rake_create(1,"Stealth Mode Startup","some@come.com")
		end.should change(Startup,:count)
			
	end

end
