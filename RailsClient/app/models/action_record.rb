class ActionRecord < ActiveRecord::Base
  belongs_to :actionable, :polymorphic => true
end
