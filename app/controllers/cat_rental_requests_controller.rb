class CatRentalRequestsController < ApplicationController
  before_action :require_login
  before_action :validate_request, only:[:approve, :deny]

  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def create
    @rental_request = CatRentalRequest.new(cat_rental_request_params)
    @rental_request.renter_id = current_user.id
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat)
    else
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new
    end
  end

  def deny
    current_cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  def new
    @rental_request = CatRentalRequest.new
  end

  private
  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request)
      .permit(:cat_id, :end_date, :start_date, :status)
  end

  def validate_request
    @cat = current_cat
    unless current_user.id == @cat.owner_id
      flash[:errors] = ["That's not your cat!"]
      redirect_to cat_url(@cat)
    end
  end

end
