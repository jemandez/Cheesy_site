require 'bcrypt'

class SchoolsController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_admin!, except: [:index, :show, :access, :validation]

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
    if current_admin
      @school = School.find(params[:id])
    else
      redirect_to action: :access
    end
  end

  def access
    school_id = params[:id]
    @school = School.find(school_id)
  end

  def validation
    school_id = params[:id]
    password = params[:clave]

    @school = School.find(school_id)

    generation = @school.generations.select do |g|
      begin
        g.password == password ? true : false
      rescue
        false
      end
    end.first

    if generation
      session[:school] = school_id
      session[:generation] = generation.id.to_s
      session[:expires_at] = Time.current + 24.hours
      redirect_to school_generation_path(@school, generation)
    else
      flash[:notice] = "La clave no es valida"
      render 'access'
    end
  end
end