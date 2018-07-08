#!/bin/bash

function addwebsite-appgw() {
    APP_SUBDOMAIN=$1
    APPGW_HOSTNAME="$APP_SUBDOMAIN.$APPGW_SUBDOMAIN"
    FRONTEND_HOSTNAME="$APP_SUBDOMAIN.$BASE_DOMAIN"
    
    # Create Probe
    echo "\tCreating probe for $FRONTEND_HOSTNAME to $WEBAPP_HOSTNAME"
    az network application-gateway probe create \
    --gateway-name  $APPGW_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --name "$FRONTEND_HOSTNAME-probe" \
    --protocol Http \
    --path "/" \
    --interval 30 \
    --timeout 120 \
    --threshold 3 \
    --host "$FRONTEND_HOSTNAME" \
    --match-status-codes 200-399

    # Create HTTP Settings
    echo "\tCreating Backend HTTP Setting for $FRONTEND_HOSTNAME to $WEBAPP_HOSTNAME"
    az network application-gateway http-settings create \
    --gateway-name  $APPGW_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --name "$FRONTEND_HOSTNAME-http-setting" \
    --port 80 \
    --protocol Http \
    --cookie-based-affinity Disabled \
    --timeout 120 \
    --probe "$FRONTEND_HOSTNAME-probe" \
    --host-name $FRONTEND_HOSTNAME

    # Create a new listener using the front-end ip configuration and port created earlier
    echo "\tCreating HTTP Listener for $APPGW_HOSTNAME"
    az network application-gateway http-listener create \
    --gateway-name  $APPGW_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --name "$APPGW_HOSTNAME-http-listener" \
    --frontend-ip "$APPGW_SUBDOMAIN-frontend-ipconfig" \
    --frontend-port "$APPGW_NAME-frontend-http-port" \
    --host-name $APPGW_HOSTNAME

    if [ "$PROVISION_SSL" = true ]
    then
        echo "\tCreating HTTPS Listener for $APPGW_HOSTNAME with SSL certificate $SSLCERTIFICATE_NAME"
        az network application-gateway http-listener create \
        --gateway-name  $APPGW_NAME \
        --resource-group $RESOURCE_GROUP_NAME \
        --name "$APPGW_HOSTNAME-https-listener" \
        --frontend-ip "$APPGW_SUBDOMAIN-frontend-ipconfig" \
        --frontend-port "$APPGW_NAME-frontend-https-port" \
        --host-name $APPGW_HOSTNAME \
        --ssl-cert "wildcard.$APPGW_SUBDOMAIN"
    fi
  
    # Create a new HTTP rule
    echo "\tCreating HTTP rule"
    az network application-gateway rule create \
    --gateway-name  $APPGW_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --name "$FRONTEND_HOSTNAME-http-rule" \
    --http-listener "$APPGW_HOSTNAME-http-listener" \
    --rule-type Basic \
    --address-pool "$WEBAPP_HOSTNAME-backend-pool" \
    --http-settings "$FRONTEND_HOSTNAME-http-setting"

    if [ "$PROVISION_SSL" = true ]
    then
        # Create a new HTTPS rule
        echo "\tCreating HTTPS rule"
        az network application-gateway rule create \
        --gateway-name $APPGW_NAME \
        --resource-group $RESOURCE_GROUP_NAME \
        --name "$FRONTEND_HOSTNAME-https-rule" \
        --http-listener "$APPGW_HOSTNAME-https-listener" \
        --rule-type Basic \
        --address-pool "$WEBAPP_HOSTNAME-backend-pool" \
        --http-settings "$FRONTEND_HOSTNAME-http-setting"
    fi

    echo "\n\tDone adding $FRONTEND_HOSTNAME"
}