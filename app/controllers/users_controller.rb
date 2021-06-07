class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    
    @today = @books.created_today.count
    @yesterday = @books.created_yesterday.count
    if @today == 0 || @yesterday == 0
      @day_before_ratio = 0
    else
      @day_before_ratio = @today / @yesterday * 100
    end
    
    @this_week = @books.created_this_week.count
    @last_week = @books.created_last_week.count
    if @this_week == 0 || @last_week == 0
      @week_over_week = 0
    else
      @week_over_week = @this_week / @last_week * 100
    end
  end
  
  def index
    @users = User.all
    @book = Book.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end