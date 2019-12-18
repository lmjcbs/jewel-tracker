class JewelsController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "mysecret"
  end

  #index
  get "/jewels" do
    logged_in? ? (erb :jewels, locals: { jewels: current_user.jewels }) : (erb :error)
  end

  #new
  get "/jewels/new" do
    logged_in? ? (erb :new) : (erb :error)
  end
  ###
  ###
  #refactor to not set each attribute inidividually
  post "/jewels" do
    @jewel = Jewel.create(
      name: params[:name],
      weight: params[:weight],
      colour: params[:colour],
      location_found: params[:location_found],
      value: params[:value],
      user_id: session[:user_id]
    )
    redirect to "/jewels/#{@jewel.id}"
  end

  #show
  get "/jewels/:id" do
    @jewel = Jewel.find_by_id(params[:id])
    @pos = Jewel.where(user_id: session[:user_id]).index(@jewel) + 1
    logged_in? ? (erb :show) : (erb :error)
  end

  ###
  ### Validate that the the jewel / user actually has attributes before submitting.
  #edit
  get "/jewels/:id/edit" do
    ###
    ###
    #add protection to ensure only user who created jewel can edit
    @jewel = Jewel.find_by_id(params[:id])
    logged_in? ? (erb :edit) : (erb :error)
  end

  patch "/jewels/:id" do
    @jewel = Jewel.find_by_id(params[:id])
    @jewel.update(
      name: params[:name],
      weight: params[:weight],
      colour: params[:colour],
      location_found: params[:location_found],
      value: params[:value]
    )
    redirect to "/jewels/#{@jewel.id}"
  end

  #delete
  delete "/jewels/:id" do
    @jewel = Jewel.find_by_id(params[:id])
    @jewel.delete
    redirect to '/jewels'
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find_by_id(session[:user_id])
    end
  end

end