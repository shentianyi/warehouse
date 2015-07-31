class PtlJob < ActiveRecord::Base
  include Extensions::UUID
  include AutoKey

  def state_display
    Ptl::State::Job.display(self.state)
  end
end
