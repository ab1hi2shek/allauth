class ForumsController < ApplicationController

	before_action :find_forum, only: [:show, :edit, :update, :destroy]
	load_and_authorize_resource :except => [:index]

	def index
		if params[:search]
    		@forums = Forum.search(params[:search]).order("created_at DESC").paginate(page: params[:page], per_page: 4)
  		else
    		@forums = Forum.all.order('created_at DESC').paginate(page: params[:page], per_page: 4)
  		end
	end

	def new
		@forum = Forum.new
	end

	def create
		@forum = Forum.new forum_params
		@forum.user_id = current_user.id
		if @forum.save
			redirect_to @forum, notice: "Forum created"
		else
			render 'new', notice: "unable to save"
		end
	end

	def show
		@forum = Forum.friendly.find(params[:id])

		@prev_forum = @forum.previous
		@next_forum = @forum.next
	end

	def edit
	end

	def update
		if @forum.update forum_params
			redirect_to @forum, notice: "Forum successfully updated!"
		else
			render 'edit'
		end
	end

	def destroy
		@forum.tags.each do |tag|
			tag.forums_count -= 1;
			tag.save!
		end
		@forum.destroy
		redirect_to forums_path
	end

	def upvote 
  		@forum = Forum.friendly.find(params[:id])
  		if @forum.upvote_by current_user
  			@forum.cached_votes_up += 1
  		end
  		redirect_to :back
	end

	def downvote 
  		@forum = Forum.friendly.find(params[:id])
  		if @forum.downvote_by current_user
  			@forum.cached_votes_up -= 1
  		end
  		redirect_to :back
	end

	private

	def forum_params
		params.require(:forum).permit(:title, :content, :slug, :tag_ids => [])
	end

	def find_forum
		@forum = Forum.friendly.find(params[:id])
	end


end
