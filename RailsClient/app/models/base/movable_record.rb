class MovableRecord < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :movable, :polymorphic => true
end