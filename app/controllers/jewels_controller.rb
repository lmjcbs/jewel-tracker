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
    jewel = Jewel.create(params.merge(user_id: current_user.id))
    redirect to "/jewels/#{@jewel.id}"
  end

  #show
  get "/jewels/:id" do
    logged_in? ? (erb :show, locals: { pos: current_user.jewels.index(current_jewel) + 1 }) : (erb :error)
  end

  #edit
  get "/jewels/:id/edit" do
    logged_in? && current_user.id == current_jewel.user_id ? (erb :edit) : (erb :error)
  end

  patch "/jewels/:id" do
    jewel = Jewel.new(params.merge(id: current_jewel.id, user_id: current_user.id).except(:_method))
    if current_jewel.update(params.except(:_method))
      redirect to "/jewels/#{current_jewel.id}"
    else
      erb :edit, locals: { current_jewel: jewel }
    end
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