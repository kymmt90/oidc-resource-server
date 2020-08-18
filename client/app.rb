require 'sinatra'
require 'sinatra/reloader'

require_relative './oidc_client'

also_reload './oidc_client'

get '/' do
  erb :index
end

get '/callback' do
  client = OidcClient.new

  access_token = client.get_access_token(params['code'])

  id_token = OpenIDConnect::ResponseObject::IdToken.decode(access_token.id_token, OidcClient.public_key)

  verified =
    begin
      id_token.verify!(issuer: 'oidc-idp-server', audience: 'Gp3ykc00hPndLGfVnku5jAAZYi7OHpBsFLl8m2SrW6s')
    rescue => e
      false
    end

  user_info = access_token.userinfo!

  sub_matched = user_info.sub == id_token.sub

  if verified && sub_matched
    "Logged in as #{user_info.sub}/#{user_info.email}!!!"
  else
    'Failed to log in!!!'
  end
end
