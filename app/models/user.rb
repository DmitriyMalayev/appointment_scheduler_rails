class User < ApplicationRecord
  has_many :patients
  has_many :doctors, through: :patients
  has_many :appointments, through: :patients
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]
  # Included default devise modules above. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # The self.from_google This method that we need to define in our User model is going to take information from Google and user it to create the User Account. These are known as keyword arguments. This will look for each of these things inside of the Hash that's passed in and it's going to pull them out. It will work with the private method from_google_params.

  def self.from_google(uid:, email:, full_name:, avatar_url:)
    user = User.find_or_create_by(email: email) do |u|
      u.uid = uid
      u.full_name = full_name
      u.avatar_url = avatar_url
      u.password = SecureRandom.hex  #generates a random string each time it's called.
    end
    user.update(uid: uid, full_name: full_name, avatar_url: avatar_url)
    #We don't update the password
  end
end

# Note
# When you're creating a new account with OAuth, you would not be typing a password in. But a password is one of the things that is required to create a user account. In order to make this work we need to assign some kind of password, even if the User has google auth that will be the way they sign in. This password should not be predictable or easily guessed. This password will not be used. But this password could be used to login if they are using a regular form.

#validates
# def self.from_google(uid:, email:, full_name:, avatar_url:)
#   create_with(uid: uid, email: email, full_name: full_name, avatar_url: avatar_url) #CHECK order
#   # The goal of this is to return a User object
# end
# end
# User.create_with(attributes).find_or_create_by(nick_name: "wombi")
# Example
# What this is going to do is if you have already created an account with the website and a given email address and then you do the offload with the same gmail address that you already have instead of throwing an error it will find your account and then add the information from google to it. This will only get used if there already wasn't a user that was found. This is the way OAuth is designed to be used.
# This is adding the ability to interact with the provider in addition to other providers.

# Devise is a flexible authentication solution for Rails based on Warden.
# Its:
# Is Rack based;
# Is a complete MVC solution based on Rails engines;
# Allows you to have multiple models signed in at the same time;
# Is based on a modularity concept: use only what you really need.

# It's composed of 10 modules:
# Database Authenticatable:
# Hashes and stores a password in the database to validate the authenticity of a user while signing in.
# The authentication can be done both through POST requests or HTTP Basic Authentication.
# Omniauthable:
# Adds OmniAuth Support  https://github.com/omniauth/omniauth
# Confirmable:
# Sends emails with confirmation instructions and verifies whether an account is already confirmed during sign in.
# Recoverable:
# Resets the user password and sends reset instructions.
# Registerable:
# Handles signing up users through a registration process, also allowing them to edit and destroy their account.
# Rememberable
# Manages generating and clearing a token for remembering the user from a saved cookie.
# Trackable
# Tracks sign in count, timestamps and IP address.
# Timeoutable
# Expires sessions that have not been active in a specified period of time.
# Validatable
# Provides validations of email and password.
# It's optional and can be customized, so you're able to define your own validations.
# Lockable:
# Locks an account after a specified number of failed sign-in attempts.
# Can unlock via email or after a specified time period.
