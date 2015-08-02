require 'sinatra/base'
#require 'ptl/phase_machine'

module Ptl
  class Api<Sinatra::Base
    # include Sidekiq::Paginator


    # post '/confirm' do
    #
    # end

    # params
    #  required: message string
    #
    post '/receive' do
      content_type :json
      puts "1. api receive message : #{params}"
      raise 'no params message' if params[:message].blank?
      puts "1. api receive message : #{params[:message]}"
      message=params[:message]
      unless message.match(/^</)
        message='<'+message
      end
      Ptl::Message::Parser.dispatch(message)
      {result: 0}.to_json
    end
  end
end
