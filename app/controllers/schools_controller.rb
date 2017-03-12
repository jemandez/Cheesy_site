class SchoolsController < ApplicationController
  protect_from_forgery prepend: true

  def index
    @schools = School.all
  end

  def new
    @school = School.new
  end

  def create
    @school = School.new(params[:school].permit(:name, :url))
    if @school.valid?
      @school.save
      flash[:notice] = "Nueva escuela creada"
      redirect_to schools_path
    else
      logger.info "Form Errors: #{@school.errors.messages}"
      flash[:errors] = @school.errors.messages
      render :new
    end
  end

  def update

  end

  def delete

  end

  def show
    @school = School.find(params[:id])
  end
end