class StudentsController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_admin!
  before_action :fill_attr, only: [:edit, :update]


  def edit
  end

  def update
    clean_params = params[:student].permit(:facebook, :telephone, :mail)

    if @student.update_attributes(clean_params)
      redirect_to school_generation_group_path(@school, @generation, @group)
    else
      render action: 'edit'
    end
  end

  private

  def fill_attr
    @student = Student.find(params[:id])
    @group = @student.group
    @generation = @group.generation
    @school = @generation.school
  end

end
