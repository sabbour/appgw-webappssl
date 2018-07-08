# Setup

## Create and configure the Web App

- Create the Web App to be protected.
- Add the final custom domain to the Web App's Custom Domains.
  For example: If you created an app `myapp.azurewebsites.net` that is to be loaded through `myapp.mydomain.com`, verify that domain by adding a `TXT` record from `awverify.myapp` on `mydomain.com` to `myapp.azurewebsites.net` then add it through the Portal UI.

## Create SSL certificates for Application Gateway domain

This will assume using Let's Encrypt to generate a wildcard certificate for your AppGW domain. You can also bring your own SSL certificate. Make sure you have [certbot](https://certbot.eff.org/) installed on your machine.

## Create and configure the Application Gateway and Virtual Network

- Execute the `provision-appgw.sh` script

## CDN

- Create a CDN profile
- Create a CDN endpoint `myapp.azureedge.net` pointing to the Application Gateway domain as the origin `myapp.appgw.mydomain.com`
- Add the final custom domain to the CDN endpoint's Custom Domains.
  For example: If the entire site traffic is to be passed through the CDN domain `myapp.mydomain.com`, verify that domain by adding a `CNAME` record from `myapp` on `mydomain.com` to `myapp.azureedge.net` then add it through the Portal UI.
- Configure SSL on the custom domain. The process usually take about 6 hours to get done.