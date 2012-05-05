class User < ActiveRecord::Base
  authenticates

  validates_confirmation_of :password
end
