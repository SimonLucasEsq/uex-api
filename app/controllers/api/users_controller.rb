class Api::UsersController < Api::BaseController
  before_action :set_user, only: [:create, :show, :update, :destroy]

  def create
    @user.save!
    render json: @user
  end

  def index
    users = User.search(params).paginate(page: page, per_page: per_page)
    render json: users, each_serializer: UserSerializer, meta: meta_attributes(users)
  end

  def show
    render json: @user
  end
  def update
    @user.update!(user_params)
    render json: @user
  end

  def destroy
    @user.destroy!
  end

  def set_user
    @user = if params[:id]
      User.find(params[:id])
    else
      User.new(user_params)
    end
  end

  def user_params
    params.require(:user).permit(:email, :username, :password)
  end
end