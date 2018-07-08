#!/bin/bash

# Variables
export DEPLOYMENT_NAME="test-dohabank"
export RESOURCE_GROUP_NAME="$DEPLOYMENT_NAME"
export LOCATION="westeurope"
export WEBAPP_HOSTNAME="test-dohabank.azurewebsites.net"
export VNET_NAME="$DEPLOYMENT_NAME-vnet"
export VNET_ADDRESS_PREFIX="10.0.0.0/16"
export APPGW_SUBNET_NAME="appgw-subnet"
export APPGW_SUBNET_PREFIX="10.0.1.0/24"
export APPGW_NAME="$DEPLOYMENT_NAME-appgw"
export APPGW_SKU="WAF_Medium" # Standard_Large, Standard_Medium, Standard_Small, WAF_Large, WAF_Medium
export APPGW_CAPACITY=2
export BASE_DOMAIN="dohabank.azure.sabbour.me"
export APPGW_SUBDOMAIN="appgw.$BASE_DOMAIN"
export CERTPASSWORD="p@ssw0rd"

# Flow control variables
PROVISION_LETSENCRYPT_SSLCERTS=false
PROVISION_SSL=true
PROVISION_VNET=false
PROVISION_PIP=false