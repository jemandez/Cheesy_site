class SchoolsController < ApplicationController
  protect_from_forgery prepend: true

  def index
    @msg = "Ḧola!"
  end

end