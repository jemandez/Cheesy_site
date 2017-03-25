class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  def validate_session
    unless current_admin
      school_id = session[:school]
      generation_id = session[:generation]

      @school = School.find(school_id)

      unless @school
        render status: 404 and return
      end

      if session[:expires_at] < Time.current
        flash[:notice] = "La sesión ha expirado"
        redirect_to access_school_path(@school) and return
      end

      generation = @school.generations.find(generation_id)

      unless generation
        flash[:notice] = "La generación no existe"
        redirect_to access_school_path(@school) and return
      end

      redirect_to school_generation_url(@school, generation) and return
      end
  end
end
