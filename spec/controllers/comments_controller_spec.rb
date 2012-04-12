require 'spec_helper'

describe CommentsController do
render_views

  describe "GET 'list'" do

		before(:each) do
			#two comments, 2 commenters, 1 startup are added
			Startup.create(:project_id =>1, :name => 'Stealth Mode Startup', :email => 'stealth@startup.com')

			Commenter.create( :project_id => 1, :codename => 'pocha', :email => 'pocha@stalkninja.com')
			Commenter.create( :project_id => 1, :codename => 'lakshmi', :email => 'lakshmi@stalkninja.com')
			
			Comment.create( :startup_id => 1, :commenter_id => 1, :from => 'commenter', :message => 'from pocha', :status => 'sent')
			Comment.create( :startup_id => 1, :commenter_id => 1, :from => 'project_creator', :message => 'reply to pocha email message', :status => 'pending')
			Comment.create( :startup_id => 1, :commenter_id => 2, :from => 'commenter', :message => 'from lakshmi', :status => 'pending')
		end
    
		it "show count of comments, codename of commenters & form to submit comment" do
      get 'list', :project_id => 1
      response.should be_success
			response.body.should have_selector('p', :content => '3 comment(s) have been submitted by lakshmi,Stealth Mode Startup,pocha')

			response.should have_selector("form", :method => "post", :action => comments_submit_path(:project_id => 1)) do |form|
					form.should have_selector("input", :value => 'Submit')
			end
			
		end


  end

  describe "POST 'submit'" do
		
		before(:each) do
			Startup.create(:project_id =>1, :name => 'Stealth Mode Startup', :email => 'stealth@startup.com')
		end

    it "should not add same commenters again & add new comments" do

			lambda do 
				post 'submit',:project_id => 1, :comment => { :codename => 'tocha', :email => 'tocha@stalkninja.com', 'message' => 'this message will self destruct itself in 5 sec'}
			end.should change(Commenter, :count)
		
			lambda do 
				post 'submit',:project_id => 1, :comment => { :codename => 'tocha', :email => 'tocha@stalkninja.com', 'message' => 'this message will self destruct itself in 5 sec'}
			end.should_not change(Commenter, :count)

			lambda do 
				post 'submit',:project_id => 1, :comment => { :codename => 'tocha', :email => 'tocha@stalkninja.com', 'message' => 'this message will self destruct itself in 5 sec'}
			end.should change(Comment, :count)


    end

		it "should redirect to comment list view post submit" do
      
				post 'submit', :project_id => 1, :comment => { :codename => 'tocha', :email => 'tocha@stalkninja.com', 'message' => 'this message will self destruct itself in 5 sec'}
				response.should redirect_to comments_list_path(:project_id => 1)
		end
  
	end

end
