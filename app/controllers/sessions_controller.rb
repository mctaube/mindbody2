class SessionsController < ApplicationController






  def index
    start_date = DateTime.now
    end_date = DateTime.now
    site_ids = { 'int' => -99 }
    source_credentials = { 'SourceName' => 'NA1', 'Password' => 'TipzGqFvbyQKlw7/ZOZrj0YSv0w=', 'SiteIDs' => site_ids }
    user_credentials = { 'Username' => 'Siteowner', 'Password' => 'apitest1234', 'SiteIDs' => site_ids }
    http_request = { 'SourceCredentials' => source_credentials, 'UserCredentials' => user_credentials, 'StartDateTime' => start_date, 'EndDateTime' => end_date}
    params = { 'Request' => http_request }

    #Create Savon client using default settings
    http_client = Savon.client(wsdl: "https://api.mindbodyonline.com/0_5/ClassService.asmx?WSDL")

    # CALL API
    result_classes = http_client.call(:get_classes, message: params)


    # DO SOMETHING WITH THE RESULTS
    sessions_array = result_classes.body[:get_classes_response][:get_classes_result][:classes][:class]
    sessions_array.each do |sessions|

      @session = Session.new
      @session.session_name = params[:session_name]
      @session.start_time = params[:start_time]
      @session.end_time = params[:end_time]
      @session.instructor_id = params[:instructor_id]
      @session.instructor_mb_id = params[:instructor_mb_id]
      @session.session_mb_id = params[:session_mb_id]
      @session.location = params[:location]





    @sessions = Session.all

    render("sessions/index.html.erb")
  end

  def show
    @session = Session.find(params[:id])

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
