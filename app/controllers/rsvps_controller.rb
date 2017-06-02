class RsvpsController < ApplicationController
  def index
    @rsvps = Rsvp.all

    render("rsvps/index.html.erb")
  end

  def show
    @rsvp = Rsvp.find(params[:id])

    render("rsvps/show.html.erb")
  end

  def new
    @rsvp = Rsvp.new

    render("rsvps/new.html.erb")
  end

  def create
    @rsvp = Rsvp.new

    @rsvp.session_id = params[:session_id]
    @rsvp.resident_id = params[:resident_id]
    @rsvp.confirmed = params[:confirmed]

    save_status = @rsvp.save

    if save_status == true
      redirect_to("/rsvps/#{@rsvp.id}", :notice => "Rsvp created successfully.")
    else
      render("rsvps/new.html.erb")
    end
  end

  def edit
    @rsvp = Rsvp.find(params[:id])

    render("rsvps/edit.html.erb")
  end

  def update
    @rsvp = Rsvp.find(params[:id])

    @rsvp.session_id = params[:session_id]
    @rsvp.resident_id = params[:resident_id]
    @rsvp.confirmed = params[:confirmed]

    save_status = @rsvp.save

    if save_status == true
      redirect_to("/rsvps/#{@rsvp.id}", :notice => "Rsvp updated successfully.")
    else
      render("rsvps/edit.html.erb")
    end
  end

  def destroy
    @rsvp = Rsvp.find(params[:id])

    @rsvp.destroy

    if URI(request.referer).path == "/rsvps/#{@rsvp.id}"
      redirect_to("/", :notice => "Rsvp deleted.")
    else
      redirect_to(:back, :notice => "Rsvp deleted.")
    end
  end
end
