class StudentsController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_admin!
  before_action :fill_attr, only: [:new, :create]


  #def index
  #  @students = Student.all
  #end

  def new
  end

  def create

    if @student.valid?
      @student.save
      redirect_to group_path(@group)
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
