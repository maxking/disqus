class CommentsController < ApplicationController
  def list
		@commenters = Commenter.where("project_id = ?",params[:project_id])
		@comments = Comment.includes(:commenter).where("comments.commenter_id = commenters.id AND commenters.project_id = ?",params[:project_id]) 
		@project_id = params[:project_id]
		#@commenters_name = @commenters.map! { |c| c.codename}.join(",")
		@commenters_name = Comment.includes(:commenter, :startup).where("comments.commenter_id = commenters.id AND comments.startup_id = startups.id AND commenters.project_id = ? AND startups.project_id = ?", params[:project_id], params[:project_id]).order("comments.id desc").map { |c| 
			if c.from == 'commenter'
				Commenter.find(c.commenter_id).codename
			else 
				Startup.find(c.startup_id).name
			end
		}.uniq.join(",")
		
		render 'list'
  end

  def submit
		commenter = Commenter.find_or_create_by_project_id_and_email(:project_id => params[:project_id], :codename => params[:comment][:codename], :email => params[:comment][:email])
		Comment.create(:startup_id => Startup.find_by_project_id(params[:project_id]).id, :commenter_id => commenter.id, :from => 'commenter', :message => params[:comment][:message], :status => 'pending')

		redirect_to comments_list_path(:project_id => params[:project_id])
  end

end
