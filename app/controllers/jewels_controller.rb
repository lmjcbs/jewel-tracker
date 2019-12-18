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
    logged_in? ? (erb :show, locals: { pos: current_user.jewels.index(current_jewel) + 1, jewel: current_jewel}) : (erb :error)
  end

  ###
  ### Validate that the the jewel / user actually has attributes before submitting.
  #edit
  get "/jewels/:id/edit" do
    logged_in? && current_user.id == current_jewel.user_id ? (erb :edit, locals: { jewel: current_jewel}) : (erb :error)
  end

  patch "/jewels/:id" do
    current_jewel.update(
      name: params[:name],
      weight: params[:weight],
      colour: params[:colour],
      location_found: params[:location_found],
      value: params[:value]
    )
    redirect to "/jewels/#{current_jewel.id}"
  end

  #delete
  delete "/jewels/:id" do
    current_jewel.delete
    redirect to '/jewels'
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find_by_id(session[:user_id])
    end

    def current_jewel
      Jewel.find_by_id(params[:id])
    end
  end

end