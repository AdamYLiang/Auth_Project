class CatRentalRequestsController < ApplicationController
  before_action :cat_owned?, only: [:approve, :deny]
  before_action :logged_in?, only: [:create]

  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def create
    @rental_request = CatRentalRequest.new(cat_rental_request_params)
    @rental_request.user_id = current_user.id
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

  def cat_owned?
    cat_id = current_cat.id

    if current_user.nil?
      flash[:errors] = ["Please log in to approve or deny requests"]
      redirect_to cat_url(cat_id)
      return
    end
    
    cat = current_user.cats.where(id: cat_id)

    if cat.empty?
      flash[:errors] = ["This cat is not yours"]
      redirect_to cat_url(cat_id)
    else
      
    end
  end

  def logged_in?
    if current_user.nil?
      flash[:errors] = ["Please log in to rent cat"]
      redirect_to new_cat_rental_request_url
      # redirect_to new_session_url
    end
  end

  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :end_date, :start_date, :status)
  end
end
