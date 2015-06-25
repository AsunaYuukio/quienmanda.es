### Tasks

## mojepanstwo.pl

  Every task for getting data form mojepanstwo.pl is in "mp" namespace
  
# deputies

  $ rake mp:deupties:import
  
  imports deputies data
  
  $ rake mp:deputies:import_roles
  
  imports deputies roles (and organizations of roles)
  
# KRS

  $ rake mp:krs_person:find_and_import_if_connected first_name=John last_name=Doe
  
  search for person, imports if has any role in any already existing organization. 
  Imports all roles in all organization, so its enlarges organizations database, 
  it can get more people on each execution.
  
  $ rake mp:krs_people:import_if_connected
  
  Executes mp:krs_person:find_and_import_if_connected rake with names from file
  vendor/100richest.txt
  
# setup Entities

  $ rake mp:people:setup
  
  Setups all people
  
  $ rake mp:krs_organizations:setup
  
  Setups all organization
  
  $ rake mp:roles:setup
  
  Setups all roles of all people