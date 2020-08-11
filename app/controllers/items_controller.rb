class ItemsController < ApplicationController
  before_action -> { doorkeeper_authorize! :read }, only: [:index, :show]
  before_action -> { doorkeeper_authorize! :write }, only: [:create, :destroy]

  def index
    @items = current_resource_owner.items

    respond_to do |format|
      format.json
    end
  end

  def show
    @item = current_resource_owner.items.find(params[:id])

    respond_to do |format|
      format.json
    end
  end

  def create
    item = current_resource_owner.items.build(user_params)

    if item.save
      respond_to do |format|
        format.json { render json: { item: { title: item.title, user_id: item.user_id } } }
      end
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @item = current_resource_owner.items.find(params[:id])

    @item.destroy

    head :no_content
  end

  private

  def current_resource_owner
    @current_resource_owner ||=
      if doorkeeper_token
        User.find_by(id: doorkeeper_token.resource_owner_id)
      end
  end

  def user_params
    params.require(:item).permit(:title)
  end
end
