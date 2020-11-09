class Doctor < ApplicationRecord
  has_many :appointments    #added when there is appointments present 
  has_many :patients, through: :appointments
  
  validates :name, :phone_number, :specializations, presence: true  #added anytime 
end
