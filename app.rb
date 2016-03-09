require 'sinatra'
require 'shotgun'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'factory_girl'

Dir['./models/*.rb'].each { |file| require file }
Dir['./factories/*.rb'].each { |file| require file }

enable :sessions
set :session_secret, '^hzh@$5281'
set :database, 'sqlite3:///moolah.db'

helpers do

  def flash_login_error
    session[:error] = true
    flash[:error] = 'Username/Password incorrect. Please try again.'
    redirect '/login'
  end

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
      recipient.balance = 0.0
      recipient.save!
    end
    recipient
  end

end

get '/' do
  redirect '/login'
end

get '/login' do
  @title = 'Login'
  erb :login
end

post '/login' do
  session[:user] = User.find_by_email(params[:email])
  if session[:user].nil?
    flash_login_error
  elsif params[:password].eql?(session[:user][:password])
    session[:authenticated] = true
    redirect '/account'
  else
    flash_login_error
  end
end

get '/account' do
  redirect '/login' unless session[:authenticated]
  @title = 'Account'
  erb :account
end

post '/send_payment' do
  recipient = find_or_create_user(params[:email])
  recipient.credit(params[:amount].to_f)
  session[:user].debit(params[:amount].to_f)
  [ recipient, session[:user] ].each { |user| user.save! }
  Transaction.create(from_email: session[:user][:email],
                     to_email: recipient.email,
                     amount: params[:amount].to_f)
  flash[:message] = 'Payment Sent.'
  redirect "/account"
end

get '/transactions' do
  redirect '/login' unless session[:authenticated]
  @title = 'Transactions'
  erb :transactions
end

get '/sign_up' do
  @title = 'Sign Up'
  erb :sign_up
end

post '/sign_up' do
  User.create(email: params[:email], name: params[:name],
              phone: params[:phone], password: params[:password],
              balance: 0.0)
  session[:new_user] = true
  flash[:message] = 'Thanks for Signing Up! Please log in.'
  redirect '/login'
end








get '/transactions' do
  erb :'/admin/transactions', layout: false
end

get '/users' do
  erb :'/admin/users', layout: false
end


#
# get '/logout' do
#   session[:authenticated] = false
#   session[:user] = nil
#   redirect '/login'
# end
#

#
# get '/contact_us' do
#   @title = 'Contact Us'
#   erb :contact_us
# end
#
# get '/profile' do
#   redirect '/login' unless session[:authenticated]
#   @title = 'My Profile'
#   erb :profile
# end
#




#
# post '/contact_us' do
#
# end
#
