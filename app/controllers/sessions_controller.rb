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
    session_pull = result_classes.body[:get_classes_response][:get_classes_result][:classes][:class]

    session_pull.each do |one_session|
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
    # Identify the session
    @session = Session.find(params[:id])

    # For use in getting RSVP Info from API
    id = @session.session_mb_id

    # API PULL from MINDBODY
    site_ids = { 'int' => -99 }
    source_credentials = { 'SourceName' => 'HelloHealthy', 'Password' => 'SifyL3S5cXk8P1VTT1m5u6cPWXA=', 'SiteIDs' => site_ids }
    user_credentials = { 'Username' => 'Siteowner', 'Password' => 'apitest1234', 'SiteIDs' => site_ids }
    http_request = { 'SourceCredentials' => source_credentials, 'UserCredentials' => user_credentials, 'ClassID' => id }
    params = { 'Request' => http_request }

    #Create Savon client using default settings
    http_client = Savon.client(wsdl: "https://api.mindbodyonline.com/0_5/ClassService.asmx?WSDL")
    result = http_client.call(:get_class_visits,  message: params)

    # Get to the the RSVP array in the information pulled

    if #checking if nil and if so then doesn't do the rest because there are no RSVPS
      result.body[:get_class_visits_response][:get_class_visits_result][:class][:visits] == nil


    elsif
      #checks to see if it's a hash or array.  If there is only 1 rsvp it is a Hash if it's 2 or more it's an array
      result.body[:get_class_visits_response][:get_class_visits_result][:class][:visits][:visit].class == Hash

      #pulls the data into a variable "rsvp_pull"
      rsvp_pull = result.body[:get_class_visits_response][:get_class_visits_result][:class][:visits][:visit]

      # LOOK FOR RESIDENTS IN RESIDENT DATABASE AND ADD THEM IF NOT THERE
      check_resident = Resident.find_by(:resident_mb_id => rsvp_pull[:client][:unique_id])
      if check_resident != nil # the resident is already in the DB

      else #if not there than add them
        new_resident = Resident.new
        new_resident.first_name = rsvp_pull[:client][:first_name]
        new_resident.last_name = rsvp_pull[:client][:last_name]
        new_resident.resident_mb_id = rsvp_pull[:client][:unique_id]
        new_resident.save
      end

      @residents = Resident.find_by(:resident_mb_id => rsvp_pull[:client][:unique_id])
      rsvp_check = Rsvp.find_by("rsvps.session_id" => @session.id, "rsvps.resident_id" => @residents.id)

      if #check to see if already in the RSVP DB
        rsvp_check != nil #the combo already exists no need to add

      else #if not there than add the RSVP
        new_rsvp = Rsvp.new
        new_rsvp.session_id = @session.id
        new_rsvp.resident_id = @residents.id
        new_rsvp.confirmed =
        new_rsvp.save
      end


    else #if it's an array then have to do each do to loop through it
      rsvp_pull = result.body[:get_class_visits_response][:get_class_visits_result][:class][:visits][:visit]

      # LOOK FOR RESIDENTS IN RESIDENT DATABASE AND ADD THEM IF NOT THERE
      rsvp_pull.each do |rsvped|
        check_resident = Resident.find_by(:resident_mb_id => rsvped[:client][:unique_id])
        if check_resident != nil # the resident is already in the DB

        else #if not there than add them
          new_resident = Resident.new
          new_resident.first_name = rsvped[:client][:first_name]
          new_resident.last_name = rsvped[:client][:last_name]
          new_resident.resident_mb_id = rsvped[:client][:unique_id].to_i
          new_resident.save
        end

      end

      # LOOK FOR Session ID and Resident ID Combo in RSVP DATABASE AND ADD THEM IF NOT THERE
      rsvp_pull.each do |rsvped2|
        @residents = Resident.find_by(:resident_mb_id => rsvped2[:client][:unique_id])
        rsvp_check = Rsvp.find_by("rsvps.session_id" => @session.id, "rsvps.resident_id" => @residents.id)

        if #check to see if already in the RSVP DB
          rsvp_check != nil #the combo already exists no need to add

        else #if not there than add the RSVP
          new_rsvp = Rsvp.new
          new_rsvp.session_id = @session.id
          new_rsvp.resident_id = @residents.id
          new_rsvp.confirmed =
          new_rsvp.save
        end
      end #end of each.do
    end #end of if/else

    render("sessions/show.html.erb")
  end #end of show

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
