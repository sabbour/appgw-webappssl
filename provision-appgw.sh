#!/bin/bash

function provision-appgw() {
  if [ "$PROVISION_LETSENCRYPT_SSLCERTS" = true ]
  then
      # Create Wildcard certificate using Let's Encrypt (testing purposes only)
      echo "Create Wildcard certificate using Let's Encrypt (testing purposes only)"
      sudo certbot certonly --manual --preferred-challenges dns -d "*.$APPGW_SUBDOMAIN" --server https://acme-v02.api.letsencrypt.org/directory

      # After following through domain verification, copy the generated certificates to this directory
      sudo cp "/etc/letsencrypt/live/$APPGW_SUBDOMAIN/fullchain.pem" "wildcard.$APPGW_SUBDOMAIN.pem"
      sudo cp "/etc/letsencrypt/live/$APPGW_SUBDOMAIN/privkey.pem" "wildcard.$APPGW_SUBDOMAIN-privkey.pem"

      # Convert to PFX for upload, provide a password
      openssl pkcs12 -export -out "wildcard.$APPGW_SUBDOMAIN.pfx" -inkey "wildcard.$APPGW_SUBDOMAIN-privkey.pem" -in "wildcard.$APPGW_SUBDOMAIN.pem"
  fi

  if [ "$PROVISION_VNET" = true ]
  then
      # Create Virtual Network with a Subnet for Application Gateway
      echo "Creating Virtual Network"
      az network vnet create \
      --name $VNET_NAME \
      --resource-group $RESOURCE_GROUP_NAME \
      --location $LOCATION \
      --address-prefix $VNET_ADDRESS_PREFIX \
      --subnet-name $APPGW_SUBNET_NAME \
      --subnet-prefix $APPGW_SUBNET_PREFIX
  fi

  if [ "$PROVISION_PIP" = true ]
  then
      # Create Public IP address
      echo "Creating Public IP Address"
      az network public-ip create \
      --resource-group $RESOURCE_GROUP_NAME \
      --name "$APPGW_NAME-ip" \
      --dns-name $APPGW_NAME \
      --allocation-method Dynamic
  fi

  # Create Application Gateway
  echo "Creating Application Gateway with 8080 as a frontend port (freeing up port 80)"
  az network application-gateway create \
    --name $APPGW_NAME \
    --location $LOCATION \
    --resource-group $RESOURCE_GROUP_NAME \
    --vnet-name $VNET_NAME \
    --subnet $APPGW_SUBNET_NAME \
    --capacity $APPGW_CAPACITY \
    --sku $APPGW_SKU \
    --http2 enabled \
    --frontend-port 8080 \
    --http-settings-port 8080 \
    --http-settings-protocol Http

  if [ "$PROVISION_SSL" = true ]
  then
      # Upload the frontend SSL certificate(s)
      echo "Uploading SSL certificate"
      az network application-gateway ssl-cert create \
      --resource-group $RESOURCE_GROUP_NAME \
      --gateway-name $APPGW_NAME \
      --name "wildcard.$APPGW_SUBDOMAIN" \
      --cert-file "wildcard.$APPGW_SUBDOMAIN.pfx" \
      --cert-password $CERTPASSWORD
  fi

  # Create a Backend Pool with webapp hostname
  echo "Creating a Backend Pool with webapp hostname"
  az network application-gateway address-pool create \
    --gateway-name $APPGW_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --name "$WEBAPP_HOSTNAME-backend-pool" \
    --servers $WEBAPP_HOSTNAME

  # Create Frontend IP configuration
  echo "Creating Frontend IP configuration"
  az network application-gateway frontend-ip create \
    --gateway-name  $APPGW_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --name "$APPGW_SUBDOMAIN-frontend-ipconfig" \
    --public-ip-address "$APPGW_NAME-ip"

  # Create Frontend port configurations
  echo "Creating Frontend port configuration (80)"
  az network application-gateway frontend-port create \
    --gateway-name  $APPGW_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --name "$APPGW_NAME-frontend-http-port" \
    --port 80

  if [ "$PROVISION_SSL" = true ]
  then
      echo "Creating Frontend port configuration (443)"
      az network application-gateway frontend-port create \
      --gateway-name  $APPGW_NAME \
      --resource-group $RESOURCE_GROUP_NAME \
      --name "$APPGW_NAME-frontend-https-port" \
      --port 443
  fi
}