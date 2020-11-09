class Appointment < ApplicationRecord
  belongs_to :doctor   
  belongs_to :patient

  validates :start_time, :end_time, :location, presence: true
  validate :doctor_double_booked, :patient_double_booked, if: :starts_before_it_ends?     #Explanation please?? 
  :ends_after_it_starts
  # what does it mean for a double booking to exist. 
  # What conditions mean that a doctor or a patient is double booked?
  # if the doctor has any appointment that:
  # starts in the middle of this appointment or ends in the middle of this appointment then it's a double booking on the doctor's part
  
  def doctor_double_booked  #We check this against all of the doctors appointments 
    this_start = self.start_time #Instance methods that are called on a particular doctor's appointment  
    this_end = self.end_time  
    conflict = doctor.appointments.any? do |appointment| 
  #Look through all of the doctors appointments and checks if there are any overlapping appointments (start_time, end_time). 
  #any? returns true or false.  
      
      other_start = appointment.start_time 
      other_end = appointment.end_time
      other_start < this_end && this_end < other_end || other_start < this_start && this_start < other_end
     # other_start < this_end && this_end < other_end  
     #This means that this appointment ends in the middle of an existing appointment.
     
     # other_start < this_start && this_start < other_end  
     #This means that this appointment starts in the middle of an existing appointment. 
    end
    if conflict   #true or false 
      errors.add(:doctor, 'has a conflicting appointment') 
    # Adds an error message to the appointment with an error message about the doctor. The doctor is the key, the message is the value.     
    end
  end

  def patient_double_booked  #We check all of the patients appointments 
    this_start = self.start_time # Instance methods that are called on a particular patient's appointment 
    this_end = self.end_time
    conflict = patient.appointments.any? do |appointment|  
  #Looks through all of the patient's appointments and checks if there are any overlapping appointments (start_time, end_time). 
      other_start = appointment.start_time 
      other_end = appointment.end_time
      other_start < this_end && this_end < other_end || other_start < this_start && this_start < other_end
      # other_start < this_end && this_end < other_end  
      #This means that this appointment ends in the middle of an existing appointment.
      
      # other_start < this_start && this_start < other_end  
      #This means that this appointment starts in the middle of an existing appointment. 
    end
    if conflict   #true or false 
      errors.add(:patient, 'has a conflicting appointment')  #Add an error message to the patient's object 
    end
  end

  def ends_after_it_starts
    if !starts_after_it_ends? #If it does not start after it ends 
      errors.add(:start_time, "must be before the end time")   #If it does start after it ends we add an error   
    end
  end

  def starts_before_it_ends?
    start_time < end_time   #checking if it starts after it ends  
  end 

  # PROJECT INFO 
# The Association Macros add Instance Methods to that Class that return a collection of instances (or one instace depending on if it's a belongs_to or has_many macro) of the other class.    
   
  def doctor_name   
    self.doctor.name   # works with or without self  
  end 
   
  def patient_name   
    self.patient.name   # works with or without self  
  end
  
#IMPORTANT 
  # This is a scope method that returns all appointments that belong to a particular doctor. 
  # Scope Methods are Class Methods that return an ActiveRecord Relation. 
  # An ActionRecord Relation is something that does WHERE, ORDER, don't call methods like first at the end of it, and don't have methods that returns an array.  It is best to implement scope methods in INDEX VIEWS.  
  # The reason is this is a class method is because this is what allows us to call it on a collection of appointments 
  def self.by_doctor(doctor)  #scope methods are class methods that return an AR Relation   
    where(doctor_id: doctor.id) #This gives us a class method by doctor that we can on either the appointment class or any collection proxy or relation that is connected to that class. 
  end   

  def self.upcoming 
    where("start_time > ?", Time.now) #Explanation please ?? 
  end 

  def self.past 
    where("start_time < ?", Time.now) 
  end 

  def self.most_recent  #Sort by newest to oldest 
    order(start_time: :desc) 
  end 

  def self.longest_ago  #Sort by oldest to newest 
    order(start_time: :asc) 
  end 

end






# Need to understand who are your users and what could go wrong when they're using the app.  
# How exactly do we know if something is wrong?? 
# We can add an error to an object and that will prevent saving bad data. 
# In the User Interface make sure to make it easy for Users not to make simple mistakes 
# We need to have validations on the server side because anything in the browser is editible by the user (disable form validations example). Your server side code, your ruby code on the server needs to make sure that only stuff that's is supposed to happen is actually happening.    
