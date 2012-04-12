require 'spec_helper'

describe Comment do

	describe "testing mail relaying" do
		
		before(:each) do
			#three comments, 2 commenters, 1 startup are added
			Startup.create(:project_id =>1, :name => 'Stealth Mode Startup', :email => 'stealth@startup.com')

			Commenter.create( :project_id => 1, :codename => 'pocha', :email => 'pocha@stalkninja.com')
			Commenter.create( :project_id => 1, :codename => 'lakshmi', :email => 'lakshmi@stalkninja.com')
			
			Comment.create( :startup_id => 1, :commenter_id => 1, :from => 'commenter', :message => 'from pocha', :status => 'sent')
			Comment.create( :startup_id => 1, :commenter_id => 1, :from => 'project_creator', :message => 'reply to pocha email message', :status => 'pending')
			Comment.create( :startup_id => 1, :commenter_id => 2, :from => 'commenter', :message => 'from lakshmi', :status => 'pending')

			#mocking Sendgrid calls
			#mock_model("Sendgrid")
			Sendgrid.stub_chain(:relay_email, :deliver).and_return(true)

		end

		it "should send the pending email to appropriate receivers" do 
			Comment.rake_relay_email
			Comment.find_by_status("pending").should be_nil
		end

	end

	describe "testing mail parsing" do
		before(:each) do
			
			Startup.create(:project_id =>1, :name => 'Stealth Mode Startup', :email => 'stealth@startup.com')
			Commenter.create( :project_id => 1, :codename => 'pocha', :email => 'pocha@stalkninja.com')
			
			@gmail = mock_model("Gmailpocha");
			Gmail.stub!(:new).and_return(@gmail)
			@email = mock_model("Emailpocha")

		  @email.stub!(:mark).and_return(true)

			@gmail.stub!(:logout).and_return(true)
		end
	
		it "should fetch mails & put them in the db" do
			
			#mocking gmail fetch & returning 2 entries to be put into database
			@email.stub!(:from).and_return(["pocha@stalkninja.com"], ["stealth@startup.com"])
			@email.stub!(:subject).and_return("New reply commenter pocha - Project 1")
			@email.stub_chain(:text_part, :body, :decoded).and_return("hi pocha here","hi stealth mode startup here")
			@gmail.stub_chain(:inbox, :emails).and_return([@email, @email])

			Comment.rake_fetch_email
			#puts Comment.all
			Comment.find_by_message("hi pocha here").from.should == 'commenter'
			Comment.find_by_message("hi stealth mode startup here").from.should == 'project_creator'
			Comment.where("status = 'pending'").count.should == 2	
		end

		it "should send mail both to project creator & ninja if reply is from admin@stalkninja.com" do
	
			@email.stub!(:from).and_return(["admin@stalkninja.com"])
			@email.stub!(:subject).and_return("Re: New reply commenter pocha - Project 1")
			@email.stub_chain(:text_part, :body, :decoded).and_return("hi pocha, steath mode startup - any update on this ?")
			@gmail.stub_chain(:inbox, :emails).and_return([@email])

			Comment.rake_fetch_email
			Comment.all.count.should == 1
			#Comment.find_by_from('admin').should_not be_nil
			
			Sendgrid.stub_chain(:relay_email, :deliver).and_return(true)
			Sendgrid.should_receive(:relay_email).once.with(hash_including(:to => 'stealth@startup.com'))
			Sendgrid.should_receive(:relay_email).once.with(hash_including(:to => 'pocha@stalkninja.com'))

			Comment.rake_relay_email
		
		end

	end



end
