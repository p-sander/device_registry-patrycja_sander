#Device Registry

A simple device assignment and return tracking system. This Ruby on Rails application enables users within an organization to assign and return devices, with strict business rules around ownership and history of use.

---

## Features

- Assign a device to a user (user can only assign devices to themselves).
- Prevent re-assignment of returned devices to the same user.
- Prevent device assignment if it is actively assigned to another user.
- Allow only the user who assigned a device to return it.
- Prevent returning devices more than once.

---

## Setup Instructions

### 1. Clone the Repository

git clone https://github.com/p_sander/device-registry.git
cd device-registry


### 2. Set the Correct Ruby Version

Ensure you are using Ruby version 3.2.3. You can install and set it with rbenv:


rbenv install 3.2.3
rbenv local 3.2.3


### 3. Install Dependencies

bundle install


### 4. Prepare the Database

bundle exec rake db:setup
bundle exec rake db:test:prepare


## Running the Test Suite

bundle exec rspec


## Project structure

Service specs for AssignDeviceToUser and ReturnDeviceFromUser
Controller specs for device assignment and unassignment
Structure Overview

app/services/assign_device_to_user.rb: Business logic for assigning devices.
app/services/return_device_from_user.rb: Business logic for returning devices.
spec/services/: Tests for services.
spec/controllers/: Tests for API endpoints.



Author
Patrycja Sander
