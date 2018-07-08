#!/bin/bash

function cleanup-appgw() {
  echo "Deleting default rule that was created with the Application Gateway"
  az network application-gateway rule delete \
    --gateway-name  $APPGW_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --name "rule1"

  echo "Deleting default HTTP listener that was created with the Application Gateway"
  az network application-gateway http-listener delete \
    --gateway-name  $APPGW_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --name "appGatewayHttpListener"

  echo "Deleting default Backend Pool that was created with the Application Gateway"
  az network application-gateway address-pool delete \
    --gateway-name  $APPGW_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --name "appGatewayBackendPool"

  echo "Deleting default HTTP Setting that was created with the Application Gateway"
  az network application-gateway http-settings delete \
    --gateway-name  $APPGW_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --name "appGatewayBackendHttpSettings"

  echo "Done!"
}