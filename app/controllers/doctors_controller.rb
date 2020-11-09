class DoctorsController < ApplicationController
  before_action :authenticate_user!  #Why exclamation mark??
  before_action :set_doctor, only: [:show, :edit, :update, :destroy]

  def index
    @doctors = Doctor.all  #all doctors
  end

  def show
  end

  def new
    @doctor = Doctor.new  #new instance of doctor for blank form
  end

  def create #Users can create a doctor but cannot edit or delete existing doctors??
    @doctor = Doctor.new(doctor_params)
    if @doctor.save
      
      redirect_to doctor_path(@doctor)  #show??
    else
      render :new
    end
  end

  private

  def set_doctor
    @doctor = Doctor.find(params[:id])
  end

  def doctor_params
    params.require(:doctor).permit(:name, :phone_number, :specializations)
    # Must have :doctor
    # Can have one name, one phone_number and one specializations ??
  end
end
