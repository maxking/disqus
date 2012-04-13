class Comment < ActiveRecord::Base
  belongs_to :commenter
  belongs_to :startup
  
  def self.rake_relay_email
    Comment.where("status = 'pending'").each do |comment|
      subject = "New reply commenter #{Commenter.find(comment.commenter_id).codename} - Project #{Startup.find(comment.startup_id).project_id}"
      
      retval = false
      case comment.from
      when "commenter"
        Sendgrid.test("raj.abhilash1@gmail.com")
        startup = Startup.find(comment.startup_id)
        retval = Sendgrid.test(:to => startup.email, :subject => subject, :message => comment.message).deliver
      when "admin"
        startup = Startup.find(comment.startup_id)
        commenter = Commenter.find(comment.commenter_id)
        retval = Sendgrid.relay_email(:to => startup.email, :subject => subject, :message => comment.message).deliver and Sendgrid.relay_email(:to => commenter.email, :subject => subject, :message => comment.message).deliver
      when "project_creator"
        commenter = Commenter.find(comment.commenter_id)
        retval = Sendgrid.relay_email(:to => commenter.email, :subject => subject, :message => comment.message).deliver
      end
      
      if retval 
        comment.status = 'sent'
        comment.save
      end
      
    end
  end
  
  def self.rake_fetch_email
    gmail = Gmail.new('comments@stalkninja.com','comments123')
    
    gmail.inbox.emails(:unread, :to => 'comments@stalkninja.com').each do |email|
      
      if matches = email.subject.match('New reply commenter (.*?) - Project (\d+)')
        
        project_id = matches[2]
        codename = matches[1]
        startup = Startup.find_by_project_id(project_id)
        message = email.text_part.body.decoded
        
        case email.from[0]
        when startup.email
          Comment.create(:startup_id => startup.id, :commenter_id => Commenter.find_by_codename_and_project_id(codename,project_id).id, :from => "project_creator", :message => message, :status => 'pending')
        when "admin@stalkninja.com"
          Comment.create(:startup_id => startup.id, :commenter_id => Commenter.find_by_codename_and_project_id(codename,project_id).id, :from => "admin", :message => message, :status => 'pending')
        else
          Comment.create(:startup_id => startup.id, :commenter_id => Commenter.find_by_codename_and_project_id(codename,project_id).id, :from => "commenter", :message => message, :status => 'pending')
        end
        
        email.mark(:read)
        
      end
      
    end #gmail.inbox.emails
    
    gmail.logout
    
  end
  
end
