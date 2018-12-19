class CatsController < ApplicationController
    before_action :cat_owned?, only: [:edit, :update]


  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id

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
    params.require(:cat).permit(:age, :birth_date, :color, :description, :name, :sex)
  end

  def cat_owned?
    cat_id = params[:id]

    if current_user.nil?
      flash[:errors] = ["Please log in to edit cat"]
      redirect_to cat_url(cat_id)
      return
    end
    
    cat = current_user.cats.where(id: cat_id)

    if cat.empty?
      flash[:errors] = ["You do not own this cat"]
      redirect_to cat_url(cat_id)
    else
      
    end
  end
end
