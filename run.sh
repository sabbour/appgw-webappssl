#!/bin/bash

# Load the sources
source ./init-vars.sh
source ./provision-appgw.sh
source ./addwebsite-appgw.sh
source ./cleanup-appgw.sh

# Provision the Application Gateway
provision-appgw

# Add your webapps to the Application Gateway configuration
addwebsite-appgw "myapp" # myapp.mydomain.com
addwebsite-appgw "foo" # foo.mydomain.com

# Clean up
cleanup-appgw