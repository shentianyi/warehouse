module LedStateable
  extend ActiveSupport::Concern

  included do
    after_create :create_job
  end

  def create_job

    puts "344444444343434344334"

  end

end