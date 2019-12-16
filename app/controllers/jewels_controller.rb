class JewelsController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "mysecret"
  end

  #index
  get "/jewels" do
    @session = session
    # @jewels = Jewel. where Jewel.user_id == session[:user_id]
    if logged_in?(session)
      erb :jewels
    else
      erb :error
    end
  end

  #new
  get "jewels/new" do
    erb :new
  end

  post "/jewels" do
    @jewel = Jewel.create(
      type: params[:type],
      weight: params[:weight],
      colour: params[:colour],
      location_found: params[:location_found],
      value: params[:value],
      user_id: session[:user_id]
    )
    redirect to "/jewels/#{@jewel.id}"
  end

  #show
  get "./jewels/:id" do
    @jewel = Jewel.find_by_id(params[:id])
    erb :show
  end

  #edit
  get "/jewels/:id/edit" do
    @jewel = Jewel.find_by_id(params[:id])
    erb :edit
  end

  patch "jewels/:id" do
    @jewel = Jewel.find_by_id(params[:id])
    @jewel.type = params[:type]
    @jewel.weight = params[:weight]
    @jewel.colour = params[:colour]
    @jewel.location_found = params[:location_found]
    @jewel.value = params[:value]
    @jewel.save
    redirect to "/jewels/#{@jewel.id}"
  end

  #delete
  delete "./jewels/:id" do
    @jewel = Jewel.find_by_id(params[:id])
    @jewel.delete
    redirect to '/jewels'
  end

  helpers do
    def logged_in?(session_hash)
      !!session_hash[:user_id]
    end

    def current_user(session_hash)
      User.find_by(id: session_hash[:user_id])
    end
  end

end