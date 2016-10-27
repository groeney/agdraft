class Recommendation < ActiveRecord::Base
  belongs_to :user, polymorphic: true
  belongs_to :resource, polymorphic: true
end
