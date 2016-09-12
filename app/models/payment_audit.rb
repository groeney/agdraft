class PaymentAudit < ActiveRecord::Base
  belongs_to :farmer
  belongs_to :job
end
