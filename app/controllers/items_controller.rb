class ItemsController < ApplicationController
  before_action :authenticate_user

  def index
    @items = current_user.items

    respond_to do |format|
      format.json
    end
  end

  def show
    @item = current_user.items.find(params[:id])

    respond_to do |format|
      format.json
    end
  end

  def create
    item = current_user.items.build(user_params)

    if item.save
      respond_to do |format|
        format.json { render json: { item: { title: item.title, user_id: item.user_id } } }
      end
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @item = current_user.items.find(params[:id])

    @item.destroy

    head :no_content
  end

  private

  def authenticate_user
    return if current_user

    respond_to do |format|
      format.json { render json: { errors: ['unauthorized'] }, status: :unauthorized }
    end

    return
  end

  def user_params
    params.require(:item).permit(:title)
  end
end
