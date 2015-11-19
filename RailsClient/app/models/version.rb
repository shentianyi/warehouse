class Version < ActiveRecord::Base
  # before_save :check_active_user
  #
  # def check_active_user
  #   self.whodunnit = self.whodunnit || User.current
  #   puts "--------------------- #{self.whodunnit} --------------------------"
  # end
end