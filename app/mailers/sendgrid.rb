class Sendgrid < ActionMailer::Base
default :from => 'StalkNinja project comments <comments@stalkninja.com>'

	def relay_email(params)
		@message = params[:message]
		mail :to => params[:to], :bcc => "admin@stalkninja.com", :subject => params[:subject]

	end
	

        def test(email)
          mail(:to => email, :subject => "Hello world")
        end
end
