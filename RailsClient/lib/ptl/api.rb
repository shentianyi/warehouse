require 'sinatra/base'
require 'ptl/phase_machine'

module Ptl
  class Api<Sinatra::Base
    # include Sidekiq::Paginator


    get '/led' do

      pm=Ptl::PhaseMachine.new({led_id: 1})
      pm.to_json
    end
  end
end