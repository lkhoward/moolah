require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'factory_girl'

Dir['./models/*.rb'].each { |file| require file }
Dir['./factories/*.rb'].each { |file| require file }

enable :sessions
set :session_secret, '^hzh@$5281'
set :database, 'sqlite3:///piggy.db'

helpers do

  def to_dollars(number)
    dollars = "$#{number.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1,").reverse}"
    if dollars.split('.').last.size == 1
      return "#{dollars}0"
    else
      return dollars
    end
  end

  def find_or_create_user(email)
    recipient = User.find_or_create_by_email(email)
    unless recipient.password
      recipient.password = Faker::Internet.password(8, 12, true, true)
      recipient.save!
    end
    recipient
  end

end

get '/activities' do
  erb :'/admin/activities', layout: false
end

get '/users' do
  erb :'/admin/users', layout: false
end

get '/' do
  erb :home, layout: false
end

get '/login' do
  @title = 'Login'
  erb :login
end

get '/logout' do
  session[:authenticated] = false
  session[:user] = nil
  redirect '/login'
end

get '/sign_up' do
  @title = 'Sign Up'
  erb :sign_up
end

get '/contact_us' do
  @title = 'Contact Us'
  erb :contact_us
end

get '/profile' do
  redirect '/login' unless session[:authenticated]
  @title = 'My Profile'
  erb :profile
end

get '/account' do
  redirect '/login' unless session[:authenticated]
  @title = 'Account'
  erb :account
end

get '/activity' do
  redirect '/login' unless session[:authenticated]
  @title = 'Activity'
  erb :activity
end

post '/login' do
  session[:user] = User.find_by_email(params[:email])
  if params[:password].eql?(session[:user][:password])
    session[:authenticated] = true
    redirect "/account"
  else
    session[:error] = true
    flash[:error] = 'Username/Password incorrect. Please try again.'
    redirect '/login'
  end
end

post '/sign_up' do
  User.create(email: params[:email], name: params[:name], phone: params[:phone], password: params[:password])
  session[:new_user] = true
  flash[:message] = 'Thanks for Signing Up! Please log in.'
  redirect '/login'
end

post '/contact_us' do

end

post '/send_payment' do
  recipient = find_or_create_user(params[:email])
  recipient.credit(params[:amount].to_f)
  session[:user].debit(params[:amount].to_f)
  recipient.save!
  session[:user].save!
  Activity.create(from_account_id: session[:user][:id], to_account_id: recipient.id,
                  transaction_type: 'D', amount: params[:amount].to_f)
  flash[:message] = 'Payment Sent.'
  redirect "/account"
end