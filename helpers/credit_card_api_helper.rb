# helper
module CreditCardAPIHelper
  def login(user)
    session[:user_id] = user.id
    redirect '/'
  end
end
