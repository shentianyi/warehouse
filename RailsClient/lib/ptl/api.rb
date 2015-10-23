require 'sinatra/base'

module Ptl
  class Api<Sinatra::Base
    # params
    #  required: message string
    #
    post '/receive' do
      content_type :json
      puts "1. api receive message : #{params}"
      puts "1. api receive message : #{params[:message]}"
      message=params[:message]
      Ptl::Message::Parser.dispatch(message)
      {result: 0}.to_json
    end
  end
end
