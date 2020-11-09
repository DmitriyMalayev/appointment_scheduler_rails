class Patient < ApplicationRecord
  belongs_to :user
  has_many :appointments
  has_many :doctors, through: :appointments
  
  validates :name, presence: true, uniqueness: {scope: :user_id}
  # Unique within the scope of the user_id 
  # A patient can still have the same name??  
end
