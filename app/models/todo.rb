class Todo < ActiveRecord::Base
  belongs_to :user, foreign_key: :user_id, class_name: "User"
end
