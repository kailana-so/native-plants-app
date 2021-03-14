# dependencies

require 'sinatra'
require 'bcrypt'
require_relative 'db/lib'
# grab the library run_sql file

require 'active_support'
require 'action_view'
# CloudinaryHelper methods depends on these to gems
require 'cloudinary' # method for the upload 
include CloudinaryHelper # for the cl_image_tag method


auth = {
    cloud_name: ENV['CLOUD_NAME'],
    api_key: ENV['CLOUD_API_KEY'],
    api_secret: ENV['CLOUD_API_SECRET']
}


# development only dependencies
if development?
  require 'sinatra/reloader'
  require 'pry'
end



# create a user session to control user flow and allow for submissions/edits/delete
enable :sessions
# this is the sinatra feature to create a global ~like~ obj session that can be written

# function to check if user is logged in or not
def logged_in?()
  if session[:user_id]
    return true
  else
    return false
  end
end

# current user function (to call upon when creating relationship between plants and users)

def current_user

  results = run_sql("SELECT * FROM users WHERE id = $1;",
  [session[:user_id]])
  # this id comes from the user db and log in route performed below

  return results.first
end


# index "homepage" serving ALL resoures from the db native_plants
get '/' do

  plants = run_sql("SELECT * FROM plants;")

  erb :index, locals: {
    plants: plants
  }
end

get '/about' do

  erb :about
end

# new plant submission page route from index.erb and serves the submit form
get '/plants' do

  if logged_in?
    erb :plant_submit
  else
    redirect'/login'
  end
end


# new plant submission to db from plant_submit route to insert into native_plants db
post '/plants' do
  # grab the params to run_sql
    #  - params are the named inputs from the form ie. params[:name], params[:color] etc
  # check if user is logged in or not : redirect to post
  # insert details into db
    # - write the sql statement whihc expect teh sql syntax and an array - the params from the form
  sql = "INSERT INTO plants (name, latin_name, description, family, color, petal_shape, leaf_shape, leaf_margin, location, plant_status, image_url, image_timestamp, user_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)"

  result = Cloudinary::Uploader.upload(params[:image_url][:tempfile], auth)



  
  run_sql(sql, [
    params[:name], 
    params[:latin_name],
    params[:description], 
    params[:family],
    params[:color], 
    params[:petal_shape],
    params[:leaf_shape], 
    params[:leaf_margin],
    params[:location], 
    params[:plant_status],
    result["public_id"],
    result["created_at"], # <-------- this is where params[:avatar][:tempfile]  goes
    current_user()['id'] 
  ])
  
  redirect'/'

end

# based on the plant id captured in the orig SELECT * FROM statement and sent to the index page with all the plant card route to the plant details page
get '/plants/:id' do

  plant = run_sql("SELECT * FROM plants WHERE id = $1", [params[:id]])[0]

  erb :plant_details, locals: {
    plant: plant
  }
end


# edit and delete your posts as a user
# route user to edit page
get '/plants/:id/edit' do

  plant = run_sql("SELECT * FROM plants WHERE id = $1", [params[:id]])[0]

  erb :plant_edit, locals: {
    plant: plant
  }
end

# patch (update the plant details) route to db
patch '/plants/:id' do

  result = Cloudinary::Uploader.upload(params[:image_url][:tempfile], auth)


  run_sql("UPDATE plants SET name = $1, latin_name = $2, description = $3, family = $4, color = $5, petal_shape = $6, leaf_shape = $7, leaf_margin = $8, location = $9, plant_status = $10, image_url = $11 WHERE id = $12;", [
    params[:name], 
    params[:latin_name],
    params[:description], 
    params[:family],
    params[:color], 
    params[:petal_shape],
    params[:leaf_shape], 
    params[:leaf_margin],
    params[:location], 
    params[:plant_status],
    result["public_id"],
  # <-------- this is where params[:avatar][:tempfile]  goes
    params[:id]
  ])

  redirect "/plants/#{params[:id]}"
end

# delete plant route
delete '/plants/:id' do

  run_sql("DELETE FROM plants WHERE id = $1", [
    params[:id]
    ])

  redirect'/'
  
end


# sign up route!!!
get '/sign_up' do

  erb :sign_up
end

# sign up route pushing to db
post '/new_user' do

  #  digest the password
  password_digest = BCrypt::Password.create(params[:password])

  #  pass the user details to the db
  new_user = run_sql("INSERT INTO users (username, email, password_digest) VALUES ( $1, $2, $3);", [
    params[:username], 
    params[:email],
    password_digest
  ])

  results = run_sql("SELECT * FROM users WHERE email = $1;", [
    params[:email]
  ])

    #  check if the user (who just signed up) is present in db and display user name
    if results.count == 1 && BCrypt::Password.new(results[0]['password_digest']).==(params[:password])

      # this is the identifiefier displayed when user is logged in
      session[:user_id] = results[0]['id']

      redirect '/'
    end

end



# session user content
# login route to take user to login form
get '/login' do

  erb :login
end


# post login to user db
post '/sessions' do 

  # this pulls a match form the table 'users'
  # user = run_sql("SELECT * FROM users WHERE email = $1;",[
  #   params[:email]
  # ])

  # db = PG.connect(dbname: 'native_plants')
  # sql = "SELECT * FROM users WHERE email = '#{params[:email]}';"

  results = run_sql("SELECT * FROM users WHERE email = $1;", [
    params[:email]
  ])

  if results.count == 1 && BCrypt::Password.new(results[0]['password_digest']).==(params[:password])

    # this is the identifiefier displayed when user is logged in
    session[:user_id] = results[0]['id']

    redirect '/'

  else

    erb :login

  end

end


get '/user' do

  plants = run_sql("SELECT * FROM plants WHERE user_id = $1", [session[:user_id]])


  erb :user, locals: {
    plants: plants
  }
end



delete '/sessions' do

  session[:user_id] = nil
  redirect '/login'
end