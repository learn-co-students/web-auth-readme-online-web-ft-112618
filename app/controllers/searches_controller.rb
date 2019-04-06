class SearchesController < ApplicationController
  def search
  end

  def friend
    resp = Faraday.get("https://api.foursquare.com/v2/users/self/friends") do |req|
      req.params['oauth_token'] = session[:token]
      req.params['v'] = '20160201'
    end
    @friends = JSON.parse(resp.body)["response"]["friends"]["items"]

  def foursquare

    client_id = ENV['SHPP04BK4VTOLYHIUNOEZPOAFO1DPIC4FU1I1PH532PBBX0Y']
    client_secret = ENV['WMVMDKQD0WRWIT41YUDBP5YJLWGM0245SIUWPDJNBDJTNUIJ']

    @resp = Faraday.get 'https://api.foursquare.com/v2/venues/search' do |req|
      req.params['client_id'] = client_id
      req.params['client_secret'] = client_secret
      req.params['v'] = '20160201'
      req.params['near'] = params[:zipcode]
      req.params['query'] = 'coffee shop'
    end

    body = JSON.parse(@resp.body)
    session[:token] = body["access_token"]
    redirect_to root_path

    if @resp.success?
      @venues = body["response"]["venues"]
    else
      @error = body["meta"]["errorDetail"]
    end
    render 'search'

    rescue Faraday::TimeoutError
      @error = "There was a timeout. Please try again."
      render 'search'
  end
end
