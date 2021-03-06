class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  # GET /users
  # GET /users.json
  def index
      @users = User.all
      @users = User.order("rank ASC").paginate(page: params[:page], :per_page => 20)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @holdings = @user.holdings.all
    @holdings = @user.holdings.order("created_at DESC").paginate(page: params[:page], :per_page => 10)
    @markets_group = @holdings.select(:market_id).distinct
    @utransactions = @user.utransactions.order("created_at DESC").paginate(page: params[:page], :per_page => 20)
    @bhistories = @user.bhistories.order("created_at DESC").paginate(page: params[:page], :per_page => 20)
    @visible_transactions =0
    if current_user.id == @user.id || current_user.admin?
      @visible_transactions = 1
    end
  end

  # GET /users/new
  def new
    @user = User.new
    render layout: "static"
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to signin_path
    else
      render 'new'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  def update_ranking
    #operations are performed for all tenants
    User.update_ranking
    @tenant = Tenant.current = Tenant.where(:host => (request.subdomain.nil? ? "" : request.subdomain) ).first
    logger.debug(@tenant)
    render :text => "OK"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.

    def user_params
      params.require(:user).permit(:name, :email, :password,:password_confirmation, :country, :gender,
        :birth_year, :education, :market_knowledge)
    end

    # Before filters
    
    def signed_in_user
       unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
  end
