class PostsController < ApplicationController
  before_filter :logged_in_user, only: [ :new, :create ]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to posts_path
    else
      flash.now[:danger] = "Something went wrong..."
    end
  end

  def index
    @posts = Post.all
  end

  private

    def post_params
      params.require(:post).permit(:content)
    end

    def logged_in_user
      flash[:danger] = "Please login."
      redirect_to root_url if !logged_in?
    end
end
