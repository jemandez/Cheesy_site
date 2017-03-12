class StudentsController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_admin!
  before_action :fill_attr, only: [:new, :create]


  #def index
  #  @students = Student.all
  #end

  def new
    @group = Group.find params[:group_id]
    @generation = Generation.find(params[:generation_id])
    @school = School.find(params[:school_id])
  end

  def create
    @group = Group.find params[:group_id]
    @generation = Generation.find(params[:generation_id])
    @school = School.find(params[:school_id])
    @student.group = @group

    if @student.valid?
      @student.save
      redirect_to school_generation_group_path(@school, @generation, @group)
    else
      render action: 'new'
    end
  end

  private

  def fill_attr
    if params.key?(:student)
      @student = Student.new(params[:student].permit(:title, :description, :url))
    else
      @student = Student.new
    end

    @student.group = @group = Group.find(Integer(params[:group_id]))
  end

end
