class Location < ActiveRecord::Base
  has_and_belongs_to_many :workers
  has_many :farmers

  def label
    return "#{region}, #{state}"
  end
end
