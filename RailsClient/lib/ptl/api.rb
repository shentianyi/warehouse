require 'sinatra/base'
#require 'ptl/phase_machine'

module Ptl
  class Api<Sinatra::Base
    # include Sidekiq::Paginator


    post '/confirm' do

    end
	
    # params
    #  required: message string
    #
    post '/receive' do
      puts params.to_json.red
		raise 'no params message' if params[:message].blank?
	  puts "receive msg: #{params[:message]}"

      Ptl::Message::Parser.dispatch(params[:message])
    end
  end
end
