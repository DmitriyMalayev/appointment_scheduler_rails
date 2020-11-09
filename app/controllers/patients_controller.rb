class PatientsController < ApplicationController
  before_action :authenticate_user! #checks if a user is logged in before any method runs. 
  before_action :set_patient, only: [:show, :edit, :update, :destroy] #we're setting the value of the patient instance variable

  def index 
    @patients = current_user.patients 
    # Which patients should a user see when they're logged in? 
    # We only show the patients that belong to the current user.
    # With devise, current_user is accessible in controllers and views. 
    # If there is no current user or a User isn't logged in we're redirected to login ?? 
  end

  def show
    @patient = current_user.patients.find(params[:id])   
    # This code can be used with :show, :edit, :update, :destroy 
    # We can't use @patients instead because they're separate actions 
  end 

  def new
    @patient = Patient.new 
  end

  def create   #We can use @patient because we have the set_patient method   
    @patient = current_user.patients.build(patient_params)  
    # We're calling .build on patients for the current user. So that the new patient will belong to the current user. 
    # The patient's user_id will be current_user.id       
    
    if @patient.save     
      redirect_to patient_path(@patient) #index 
    else 
      render :new 
    end 
  end 

  # This will auto assign the foreign key to the user whose collection of patient's we're working with. 
  # The user id will be assigned to the current user's id.  
  # We're able to do this because we have has many patients in the user model 
  # @patient = Patient.new(patient_params) This way we don't get the foreign key assigned ?? 

  def update #We can use @patient because we have the set_patient method  
    if @patient.update(patient_params) 
      redirect_to patient_path(@patient)
    else 
      render :edit 
    end 
  end


  def destroy
    @patient.destroy 
    redirect_to patients_path
    # The user will be redirected if they try to delete a patient that don't have access to 
    # This is because of the set_patient method 
  end
  private 

  def set_patient  #called before [:show, :edit, :update, :destroy]
    @patient = current_user.patients.find(params[:id])  
    # If the current_user is nil meaning not signed in we will be redirected to the home route.
    # We're preventing anyone from viewing, editing, updating or deleting something they haven't created. 
    # Works in conjunction with our rescue method.
  end 
  
  def patient_params
    params.require(:patient).permit(:name)
    # Must have :patient key,  Can have :name  
  end 

end

# OTHER EXAMPLES 
# params.require(:patient).permit(:name, :allergy_ids [], guardian_attributes: [:name, :phone_number])  
# This will allow you to call the nested attributes method, because it's whitelisted 
# The empty [] is used if you have checkboxes 

# Roles:
#   User
#   Admin

# Generated methods:
#   authenticate_user!  # Signs user in or redirect
#   authenticate_admin! # Signs admin in or redirect
#   user_signed_in?     # Checks whether there is a user signed in or not
#   admin_signed_in?    # Checks whether there is an admin signed in or not
#   current_user        # Current signed in user
#   current_admin       # Current signed in admin
#   user_session        # Session data available only to the user scope
#   admin_session       # Session data available only to the admin scope

# Use:
#   before_action :authenticate_user!  # Tell devise to use :user map
#   before_action :authenticate_admin! # Tell devise to use :admin map



# <%= render :partial => "account" %>

# This means there is already an instance variable called @account for the partial and you pass it to the partial.

# <%= render :partial => "account", :locals => { :account => @buyer } %>

# This means you pass a local instance variable called @buyer to the account partial and the variable in the account partial is called @account. I.e., the hash { :account => @buyer } for :locals is just used for passing the local variable to the partial. You can also use the keyword as in the same way:

# <%= render :partial => "contract", :as => :agreement

# which is the same as:

# <%= render :partial => "contract", :locals => { :agreement => @contract }