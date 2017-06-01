class SessionsController < ApplicationController


  def index
    start_date = DateTime.now
    end_date = DateTime.now
    site_ids = { 'int' => -99 }
    source_credentials = { 'SourceName' => 'HelloHealthy', 'Password' => 'SifyL3S5cXk8P1VTT1m5u6cPWXA=', 'SiteIDs' => site_ids }
    user_credentials = { 'Username' => 'Siteowner', 'Password' => 'apitest1234', 'SiteIDs' => site_ids }
    http_request = { 'SourceCredentials' => source_credentials, 'UserCredentials' => user_credentials, 'StartDateTime' => start_date, 'EndDateTime' => end_date}
    params = { 'Request' => http_request }

    #Create Savon client using default settings
    http_client = Savon.client(wsdl: "https://api.mindbodyonline.com/0_5/ClassService.asmx?WSDL")

    # CALL API FOR CLASSES DATA
    result_classes = http_client.call(:get_classes, message: params)

    # FILL MY SESSIONS DATABASE WITH NEW DATA
    @sessions = result_classes.body[:get_classes_response][:get_classes_result][:classes][:class]

    @sessions.each do |one_session|
      current_session = Session.find_by(:session_mb_id => one_session[:id])
      if current_session != nil # the session is already in the DB
        # check if any of the info has changed - UPDATES FOR LATER
        # if it has, update the DB - UPDATES FOR LATER
      else
        new_session = Session.new
        new_session.session_name = one_session[:class_description][:name]
        new_session.start_time = one_session[:start_date_time]
        new_session.end_time = one_session[:end_date_time]
        new_session.instructor_id = one_session[:staff][:id]
        new_session.instructor_mb_id = one_session[:staff][:id]
        new_session.session_mb_id = one_session[:id]
        new_session.location = one_session[:location][:name]
        new_session.save
      end
    end

    @sessions = Session.all

    render("sessions/index.html.erb")
  end

  def show
    @session = Session.find(params[:id])

    id = @session.session_mb_id

    site_ids = { 'int' => -99 }
    source_credentials = { 'SourceName' => 'HelloHealthy', 'Password' => 'SifyL3S5cXk8P1VTT1m5u6cPWXA=', 'SiteIDs' => site_ids }
    user_credentials = { 'Username' => 'Siteowner', 'Password' => 'apitest1234', 'SiteIDs' => site_ids }
    http_request = { 'SourceCredentials' => source_credentials, 'UserCredentials' => user_credentials, 'ClassID' => id }
    params = { 'Request' => http_request }
    #Create Savon client using default settings
    http_client = Savon.client(wsdl: "https://api.mindbodyonline.com/0_5/ClassService.asmx?WSDL")
    result = http_client.call(:get_class_visits,  message: params)


    # FILL MY SESSIONS DATABASE WITH NEW DATA
    @rsvps = result.body[:get_class_visits_response][:get_class_visits_result][:class][:visits][:visit]

    resident_mb_id = visits[0][:client][:unique_id]


    @rsvps.each do |rsvp|
      @resident = Resident.find_by(:resident_mb_id => rsvp[:client][:unique_id])
      if @resident != nil # the session is already in the DB
        # check if any of the info has changed - UPDATES FOR LATER
        # if it has, update the DB - UPDATES FOR LATER
      else
        new_resident = Resident.new
        new_resident.first_name = rsvp[:client][:first_name]
        new_resident.last_name = rsvp[:client][:last_name]
        new_resident.save
      end

      new_rsvp = Rsvp.new
      new_rsvp.session_id = @session.id
      new_rsvp.resident_id = @resident.id
      new_rsvp.save

    end





    render("sessions/show.html.erb")
  end

  def new
    @session = Session.new

    render("sessions/new.html.erb")
  end

  def create
    @session = Session.new

    @session.session_name = params[:session_name]
    @session.start_time = params[:start_time]
    @session.end_time = params[:end_time]
    @session.instructor_id = params[:instructor_id]
    @session.instructor_mb_id = params[:instructor_mb_id]
    @session.session_mb_id = params[:session_mb_id]
    @session.location = params[:location]

    save_status = @session.save

    if save_status == true
      redirect_to("/sessions/#{@session.id}", :notice => "Session created successfully.")
    else
      render("sessions/new.html.erb")
    end
  end

  def edit
    @session = Session.find(params[:id])

    render("sessions/edit.html.erb")
  end

  def update
    @session = Session.find(params[:id])
    @session.session_name = params[:session_name]
    @session.start_time = params[:start_time]
    @session.end_time = params[:end_time]
    @session.instructor_id = params[:instructor_id]
    @session.instructor_mb_id = params[:instructor_mb_id]
    @session.session_mb_id = params[:session_mb_id]
    @session.location = params[:location]

    save_status = @session.save

    if save_status == true
      redirect_to("/sessions/#{@session.id}", :notice => "Session updated successfully.")
    else
      render("sessions/edit.html.erb")
    end
  end

  def destroy
    @session = Session.find(params[:id])

    @session.destroy

    if URI(request.referer).path == "/sessions/#{@session.id}"
      redirect_to("/", :notice => "Session deleted.")
    else
      redirect_to(:back, :notice => "Session deleted.")
    end
  end
end
