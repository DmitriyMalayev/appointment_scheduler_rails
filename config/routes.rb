Rails.application.routes.draw do
  resources :appointments
  resources :doctors do
    resources :appointments, only: [:index, :new]
  end

  resources :patients do #One Level Nesting (one do end block)
    resources :doctors, only: [:index]
    resources :appointments, only: [:index, :new]
  end

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root "patients#index"   # a root route is required with devise
end

# What are our Nested Routes/Nested Resources? (We need a nested new route and either a nested index or nested show route)
# /patients/:patient_id/doctors => all of that patient's doctors

# /patients/:patient_id/appointments/new => a new appointment form with the patient pre-selected
# /patients/:patient_id/appointments => all appointments made with that patient (the one who is identified by `params[:patient_id]`)

# `/patients/:patient_id/`appointments => This part shows what appointments is nested under
# /patients/:patient_id/`appointments` => This part shows what controller is responsible to give us data. It's the AppointmentsController.

# Do we have Non Nested Versions of those nested routes?
# /appointments => all appointments created by this user.
# /appointments/new => a new appointment form where user must select the patient.

# PROJECT
# Anything that doesn't have a colon in the route does not need an argument
# Anything that has 1 colon it in within the route requires 1 argument
# If there are 2 colons in it that means 2 arguments are required, in the correct order.

# edit_patient_path GET  /patients/:id/edit
# This requires one argument
