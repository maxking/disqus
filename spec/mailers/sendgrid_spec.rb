require "spec_helper"

describe Sendgrid do

=begin
	before(:each) do
		@email = "pocha@stalkninja.com"
		@password = "pocha320"

	end

  it "should send mail a mail to pocha@stalkninja.com which should be read by gmail" do

		subject = "testing mail from rspec"

		Sendgrid.relay_email({:to => @email, :subject => subject, :message => 'test message body'}).deliver
		

		gmail = Gmail.new(@email,@password)
		emails = gmail.inbox.emails(:unread, :to => "comments@stalkninja.com")
		emails.count.should > 0
		emails.each do |email|
			email.subject.should == subject
			email.mark(:read)
		end
		gmail.logout

	end
=end


end
