
helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end
end

get '/' do
    @finstagram_posts = FinstagramPost.order(created_at: :desc)
    erb(:index)
end

get '/signup' do     # if a user navigates to the path "/signup",
    @user = User.new   # setup empty @user object
    erb(:signup)       # render "app/views/signup.erb"
end


post '/signup' do
     # grab user input values from params
    email      = params[:email]
    avatar_url = params[:avatar_url]
    username   = params[:username]
    password   = params[:password]
    
   # instantiate a User
  @user = User.new({ email: email, avatar_url: avatar_url, username: username, password: password })

  # if user validations pass and user is saved
  if @user.save
    redirect to('/login')
  else
    erb(:signup)
  end
end

get '/login' do    # when a GET request comes into /login
  erb(:login)      # render app/views/login.erb
end

post '/login' do
  username = params[:username]
  password = params[:password]

  user = User.find_by(username: username)

  if user && user.password == password
    session[:user_id] = user.id
    redirect to('/')
  else
    @error_message = "Login failed."
    erb(:login)
  end
end

get '/logout' do
  session[:user_id] = nil
  redirect to('/')
end

get '/finstagram_posts/new' do
  @finstagram_post = FinstagramPost.new
  erb(:"finstagram_posts/new")
end

post '/finstagram_posts' do
  photo_url = params[:photo_url]

  # instantiate new FinstagramPost
  @finstagram_post = FinstagramPost.new({ photo_url: photo_url, user_id: current_user.id })

  # if @post validates, save
  if @finstagram_post.save
    redirect(to('/'))
  else
    erb(:"finstagram_posts/new")
  end
end

get '/finstagram_posts/:id' do
  @finstagram_post = FinstagramPost.find(params[:id])   # find the finstagram post with the ID from the URL
  erb(:"finstagram_posts/show")               # render app/views/finstagram_posts/show.erb
end

post '/comments' do
   # point values from params to variables
   text = params[:text]
   finstagram_post_id = params[:finstagram_post_id]
 
   # instantiate a comment with those values & assign the comment to the `current_user`
   comment = Comment.new({ text: text, finstagram_post_id: finstagram_post_id, user_id: current_user.id })
 
   # save the comment
   comment.save
 
   # `redirect` back to wherever we came from
   redirect(back)
end

post '/likes' do
  # point values from params to variables
  finstagram_post_id = params[:finstagram_post_id]

  # instantiate a like with those values & assign the like to the `current_user`
  like = Like.new({ finstagram_post_id: finstagram_post_id, user_id: current_user.id })

  # save the like
  like.save

  # `redirect` back to wherever we came from
  redirect(back)
end
delete '/likes/:id' do
  like = Like.find(params[:id])
  like.destroy
  redirect(back)
end

=begin
# this is old code
def humanized_time_ago(time_ago_in_minutes)
    if time_ago_in_minutes >= 60
      "#{time_ago_in_minutes / 60} hours ago"
    else
      "#{time_ago_in_minutes} minutes ago"
    end
end
  
get '/' do
    @finstagram_post_shark = {
        username: "sharky_j",
        avatar_url: "http://naserca.com/images/sharky_j.jpg",
        photo_url: "http://naserca.com/images/shark.jpg",
        humanized_time_ago: humanized_time_ago(15),
        like_count: 0,
        comment_count: 1,
        comments: [{
        username: "sharky_j",
        text: "Out for the long weekend... too embarrassed to show y'all the beach bod!"
        }]
    }

    @finstagram_post_whale = {
        username: "kirk_whalum",
        avatar_url: "http://naserca.com/images/kirk_whalum.jpg",
        photo_url: "http://naserca.com/images/whale.jpg",
        humanized_time_ago: humanized_time_ago(65),
        like_count: 0,
        comment_count: 1,
        comments: [{
        username: "kirk_whalum",
        text: "#weekendvibes"
        }]
    }

    @finstagram_post_marlin = {
        username: "marlin_peppa",
        avatar_url: "http://naserca.com/images/marlin_peppa.jpg",
        photo_url: "http://naserca.com/images/marlin.jpg",
        humanized_time_ago: humanized_time_ago(190),
        like_count: 0,
        comment_count: 1,
        comments: [{
        username: "marlin_peppa",
        text: "lunchtime! ;)"
        }]
    }
    [@finstagram_post_shark, @finstagram_post_whale, @finstagram_post_marlin].to_s
    @finstagram_posts = [@finstagram_post_shark, @finstagram_post_whale, @finstagram_post_marlin]
    erb(:index)
end
=end