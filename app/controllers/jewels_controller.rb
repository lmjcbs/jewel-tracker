class JewelsController < ApplicationController

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
    logged_in? ? (erb :new, locals: { jewel: Jewel.new }) : (erb :error)
  end

  post "/jewels" do
    jewel = Jewel.create(params.merge(user_id: current_user.id))
    if jewel.valid?
      redirect to "/jewels/#{jewel.id}"
    else
      erb :new, locals: { jewel: jewel }
    end
  end

  #show
  get "/jewels/:id" do
    logged_in? ? (erb :show, locals: { pos: current_user.jewels.index(current_jewel) + 1 }) : (erb :error)
  end

  #edit
  get "/jewels/:id/edit" do
    logged_in? && current_user.id == current_jewel.user_id ? (erb :edit, locals: { jewel: current_jewel }) : (erb :error)
  end

  patch "/jewels/:id" do
    jewel = Jewel.new(params.merge(id: current_jewel.id, user_id: current_user.id).except(:_method))
    if jewel.valid?
      current_jewel.update(params.except(:_method))
      redirect to "/jewels/#{current_jewel.id}"
    else
      erb :edit, locals: { jewel: jewel }
    end
  end

  #delete
  delete "/jewels/:id" do
    current_jewel.delete
    redirect to '/jewels'
  end

end