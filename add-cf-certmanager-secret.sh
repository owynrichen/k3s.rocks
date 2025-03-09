#!/bin/zsh

BASE64_API_TOKEN=$(echo -n $1| base64)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-token
  namespace: cert-manager
data:
  token: ${BASE64_API_TOKEN}
EOF

echo k3s Secret Value

kubectl get secret cloudflare-api-token -n cert-manager -o jsonpath='{.data.token}' | base64 -d

 # kubectl delete secret cloudflare-api-token -n cert-manager

# validate the token directly
echo
echo Validation of Token
curl -X GET "https://api.cloudflare.com/client/v4/accounts/$2/tokens/verify" \
     -H "Authorization: Bearer $1" \
     -H "Content-Type:application/json"

# validate the token via k3s secret
echo Validation of Secret Stored Token
curl -X GET "https://api.cloudflare.com/client/v4/accounts/$2/tokens/verify" \
-H "Authorization: Bearer $(kubectl get secret cloudflare-api-token -n cert-manager -o jsonpath='{.data.token}' | base64 -d)" \
-H "Content-Type:application/json"