require 'pony'

get '/users' do
  # data = zipcodes_in_range(current_user.zip_code)
  # zip_code_info = data["zip_codes"]
  # @users = []
  # @distances = {}
  # zip_code_info.each do |hash|
  #   @users += User.where(zip_code: hash["zip_code"])
  #   @distances[hash["zip_code"]] = hash["distance"]
  # end
  # if params[:instrument] != "all instruments"
  #   @users = @users.select { |user| user.instruments.include? Instrument.find_by(name: params[:instrument]) }
  # end
  # if params[:genre] != "all genres"
  #   @users = @users.select { |user| user.genres.include? Genre.find_by(name: params[:genre]) }
  # end
  @users_distances = search_for_users
  if request.xhr?
    erb(:'/users/index', layout: false)
  else
    erb :'/users/index'
  end
end

get '/users/new' do
  erb :'/users/new'
end

post '/users' do
  if params[:user][:password] != params[:confirm_pw]
    @errors = ["Passwords must match"]
    return erb :'/users/new'
  end
  user = User.new(params[:user])
  user.city_state
  if user.save
    session[:user_id] = user.id
    redirect "/users/#{user.id}"
  else
    @errors = user.errors.full_messages
    erb :'/users/new'
  end
end

get '/users/:id' do
  @user = User.find(params[:id])
  erb :'/users/show'
end

get '/users/:id/edit' do
  erb :'/users/edit'
end

put '/users/:id' do
  current_user.update(params[:user])
  current_user.city_state
  current_user.save
  redirect "/users/#{current_user.id}"
end

get '/users/:id/instruments/edit' do
  if request.xhr?
    erb :'users/_instruments_edit', layout: false
  else
    erb :'users/_instruments_edit'
  end
end

put '/users/:id/instruments/edit' do
  instruments = []
  params[:instruments].each_key { |k| instruments << Instrument.find_by(name: k) }
  current_user.instruments = instruments
  if request.xhr?
    erb :'/users/_genres_inst_list_partial', layout: false, locals: { things: current_user.instruments }
  else
    redirect "/users/#{current_user.id}"
  end
end

get '/users/:id/genres/edit' do
  if request.xhr?
    erb :'users/_genres_edit', layout: false
  else
    erb :'users/_genres_edit'
  end
end

put '/users/:id/genres/edit' do
  genres = []
  params[:genres].each_key { |k| genres << Genre.find_by(name: k) }
  current_user.genres = genres
  if request.xhr?
    erb :'/users/_genres_inst_list_partial', layout: false, locals: { things: current_user.genres }
  else
    redirect "/users/#{current_user.id}"
  end
end

delete '/users/:id' do
  #delete your own profile when logged in
end

get '/users/:id/contact' do
  @user = User.find(params[:id])
  #if request.xhr?
    #display email form on user's page
  #else
  erb :'/users/_contact'
end
