class GroupsController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_admin!, except: [:index, :show]

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def create
    clean_params =  params[:group].permit(:title, :description)
    @group = Group.new clean_params

    if @group.save
      redirect_to collections_path
    else
      render action: 'new'
    end
  end

  def show
    @group = Group.find params[:id]
  end

  def edit
    @group = Group.find params[:id]
  end
end
