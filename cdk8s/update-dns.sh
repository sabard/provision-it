# reset IP address
ENDPOINT_IP=`kubectl get service --output jsonpath="{.items[1].status.loadBalancer.ingress[0].ip}"`
curl -v "https://www.duckdns.org/update?domains=licorice-provision&token=$DUCK_DNS_TOKEN&ip=$ENDPOINT_IP"

# for provision.licorice.su.domains:
# Update in Stanford Domains Zone editor for now
