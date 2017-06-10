class ResidentsController < ApplicationController
  def first_name_with_last_name
    "#{:first_name}: #{:last_name}"
  end

  def index
    @residents = Resident.all

    render("residents/index.html.erb")
  end

  def show
    @resident = Resident.find(params[:id])

    render("residents/show.html.erb")
  end

  def new
    @resident = Resident.new

    render("residents/new.html.erb")
  end

  def create

    @resident = Resident.new

    @resident.first_name = params[:first_name]
    @resident.last_name = params[:last_name]
    @resident.resident_mb_id = params[:resident_mb_id]

    save_status = @resident.save

    if save_status == true
      redirect_to("/sessions", :notice => "Resident created successfully.")
    else
      render("residents/new.html.erb")
    end
  end

  def edit
    @resident = Resident.find(params[:id])

    render("residents/edit.html.erb")
  end

  def update
    @resident = Resident.find(params[:id])

    @resident.first_name = params[:first_name]
    @resident.last_name = params[:last_name]
    @resident.resident_mb_id = params[:resident_mb_id]

    save_status = @resident.save

    if save_status == true
      redirect_to("/residents/#{@resident.id}", :notice => "Resident updated successfully.")
    else
      render("residents/edit.html.erb")
    end
  end

  def destroy
    @resident = Resident.find(params[:id])

    @resident.destroy

    if URI(request.referer).path == "/residents/#{@resident.id}"
      redirect_to("/", :notice => "Resident deleted.")
    else
      redirect_to(:back, :notice => "Resident deleted.")
    end
  end



end
