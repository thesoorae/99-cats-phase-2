class CatsController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: [:show, :index]
  before_action :check_owner, only: [:edit, :update]


  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.includes(rental_requests: :potential_renter)
    .where(id: params[:id])
    .order('cat_rental_requests.start_date')
    .first
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.owner_id = current_user.id


    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private


  def cat_params
    params.require(:cat)
      .permit(:age, :birth_date, :color, :description, :name, :sex)
  end
end
