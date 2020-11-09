class AppointmentsController < ApplicationController
  before_action :authenticate_user!    #need to be logged in to view appointments
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  def index #CHECK
    @patient = current_user.patients.find_by_id(params[:patient_id])
    @doctor = Doctor.find_by_id(params[:doctor_id])  #A Doctor is not directly related to a User.
    # We cannot use the .find method because it will raise an exception if it's nil.
    # Also, Non nested no longer works. Also the not found rescue won't work.
    # With find_by_id we get nil if it's not found. Can be used in conditional logic.
    # The Controller is Rendering The View. Which appointments do we want to render if the patient exists?
    # We want to render the patient's appointments. The reason this is ok is because the patient belongs to the user.
    # The top method returns the current user's patients??

    if @patient
      @appointments = @patient.appointments   #Each patient is associated with one user??
    elsif @doctor
      @appointments = current_user.appointments.by_doctor(@doctor)
    else
      @appointments = current_user.appointments
      # Every time we make a request that matches the index route @appointments is set to all of the appointments that belong to the current user's appointments.In the case where we hit the nested route we only want the appointments that belong to that patient
      # How do we know in the index action if we're on the nested route or not? If the request that matched this action was made to the nested route or not the nested route.
    end
  end

  def show
    # needs to be present because it's connected to the show template which is rendered
  end

  def new
    @patient = current_user.patients.find_by_id(params[:patient_id])
    #We find out if we're on a nested route under patients or doctors for the new appointment.
    #We check if there is a patient that we're getting from the url?

    @doctor = Doctor.find_by_id(:doctor_id)
    #checking if there is a doctor that we're getting from the url?

    if @patient
      @appointment = @patient.appointments.build
      # We call build on the association
      # If this saves (which it is in this case) then the foreign key for a patient_id is assigned to this patient's id??
    elsif @doctor
      @appointment = @doctor.appointments.build
      # We call build on the association
      # If this saves (which it is in this case) then the foreign key for a doctor_id is assigned to this doctor's id??
    else
      @appointment = Appointment.new
      # If there is a patient from the url make the appointment belong to the patient
      # If there is a doctor from the url make the appointment belong to the doctor
      # Otherwise make an appointment that doesn't belong to either one
    end
    filter_options   # We call this method on the bottom
  end

  def create
    # An appointment doesn't belong to the user.
    # An Appointment belongs_to a Doctor and a Patient
    # There is no direct relationship between a User and an Appointment
    @appointment = Appointment.new(appointment_params)
    if @appointment.save
  
      appointment_path(@appointment) #show page
    else
      render :new
    end
  end

  def edit
    # needs to be present because it's connected to the edit template which is rendered
  end

  def update
    if @appointment.update(appointment_params) #update can also save
      redirect_to appointment_path(@appointment) #show page
    else
      render :edit
    end
  end

  def destroy
    @appointment.destroy
    redirect_to appointments_path  #Goes to index
  end

  private

  def set_appointment
    @appointment = current_user.appointments.find(params[:id])
    # An appointment is associated with a current user
    # Makes sure a User isn't editing an appointment they have not created
    # This will provide protection by only searching through appointments created by this user.
  end

  def filter_options
    # We update the appointments based on what's in params.
    # We implement a scope method based on what's in params. This can changes the value of the instance variable.
    if params[:filter_by_time] == "upcoming"
      @appointments = @appointments.upcoming
    elsif params[:filter_by_time] == "past"
      @appointments = @appointments.past
    end

    if params[:sort] == "most_recent"
      @appointments = @appointment.most_recent
    elsif params[:sort] == "longest_ago"
      @appointments = @appointments.longest_ago
    end
  end

  def appointment_params
    params.require(:appointment).permit(:location, :start_time, :end_time, :doctor_id, :patient_id)
    # Must have appointment key
    # Can have :location, :start_time, :end_time, :doctor_id, :patient_id
  end
end
