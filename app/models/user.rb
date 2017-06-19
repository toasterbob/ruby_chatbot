class User < ActiveRecord::Base
  has_many :todos, foreign_key: :user_id, class_name: "Todo"
end
