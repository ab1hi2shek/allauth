class PostsController < ApplicationController
	before_action :find_post, only: [:show, :edit, :update, :destroy]

	def index
		if params[:search]
    		@posts = Post.search(params[:search]).order("created_at DESC").paginate(page: params[:page], per_page: 4)
  		else
    		@posts = Post.all.order('created_at DESC').paginate(page: params[:page], per_page: 4)
  		end
	end

	def new
		@post = Post.new
	end

	def create
		@post = Post.new post_params
		@post.user_id = current_user.id
		if @post.save
			redirect_to @post, notice: "Post created"
		else
			render 'new', notice: "unable to save"
		end
	end

	def show
		@post = Post.friendly.find(params[:id])

		@prev_post = @post.previous
		@next_post = @post.next
	end

	def edit
	end

	def update
		if @post.update post_params
			redirect_to @post, notice: "Post successfully updated!"
		else
			render 'edit'
		end
	end

	def destroy
		@post.tags.each do |tag|
			tag.posts_count -= 1;
			tag.save!
		end
		@post.destroy
		redirect_to posts_path
	end

	def upvote 
  		@post = Post.friendly.find(params[:id])
  		if @post.upvote_by current_user
  			@post.cached_votes_up += 1
  		end
  		redirect_to :back
	end

	def downvote 
  		@post = Post.friendly.find(params[:id])
  		if @post.downvote_by current_user
  			@post.cached_votes_up -= 1
  		end
  		redirect_to :back
	end

	private

	def post_params
		params.require(:post).permit(:title, :content, :slug, :tag_ids => [])
	end

	def find_post
		@post = Post.friendly.find(params[:id])
	end

end
