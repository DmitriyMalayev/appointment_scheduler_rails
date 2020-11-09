# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup) 
# Examples:
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.first_or_create(email: "test@test.com", password: "password", phone_number: '(123)456-7890') 

p1 = user.patients.find_or_create_by(name: "Samantha")  #Both patients are related to a single User. Patient belongs_to User. Example, one   
p2 = user.patients.find_or_create_by(name: "Patrick")

# user.patients => collection 
# .find_or_create_by => finds the record with these attributes or creates it 
# .first_or_create => gives the first record in the table if it exists or it creates a first record in the table with these attributes   
# create => also saves 

d1 = Doctor.find_or_create_by(name: "Dr. Drew", phone_number: "555-555-5555", specializations: "Celebrities")
d2 = Doctor.find_or_create_by(name: "Dr. Zhivago", phone_number: "111-232-5738", specializations: "Weathering the Cold")
# Doctors do not belong to a user 

10.times do 
  doctor = [d1, d2].sample   #.sample  => chooses a random element  
  start = [1,2,3,4,5,6].sample.days.ago + [1,2,3,4,5,6,7].sample.hour   #What do the numbers represent? 
  doctor.appointments.find_or_create_by( 
    patient: [p1,p2].sample,
    start_time: start,
    end_time: start + 1.hour,
    location: ["Boston General", "Disneyland Clinic", "General Hospital"].sample
  )
end






# a1 = d1.appointments.find_or_create_by(
#   patient: p1, 
#   start_time: 2.days.ago,
#   end_time: 2.days.ago + 1.hour 
# )

