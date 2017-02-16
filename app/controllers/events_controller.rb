class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def new
    @event = Event.new
    @collections = Collection.all
  end

  def create
    new_params = params[:event].permit(:title, :description, collections: [])

    new_params[:collections] = Collection.find(
      new_params[:collections].delete_if { |x| x.empty? })

    @event = Event.new(new_params)


    if @event.valid?
      @event.save
      redirect_to events_path
    else
      @collections = Collection.all
      render :new
    end

  end
end
