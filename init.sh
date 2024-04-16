#!/bin/sh

# Check if a key already exists for radicle (/root/.radicle/keys/*), if not run rad auth
key_exists=false
for file in /root/.radicle/keys/*; do
  if [ -f "$file" ]; then
    key_exists=true
    break
  fi
done

# If no alias is provided, raise an error if no key exists
if [ "$key_exists" = false ] && [ -z "$RAD_ALIAS" ]; then
  echo "No key found in /root/.radicle/keys/ and no alias provided. Please provide an alias to create a new key."
  exit 1
fi

# If no password is provided, print a warning
if [ -z "$RAD_PASSWORD" ]; then
  echo "No password provided. Using an empty password."
fi

if [ "$key_exists" = false ]; then
  if [ -z "$RAD_PASSWORD" ]; then
    echo $RAD_PASSWORD | rad auth --stdin --alias $RAD_ALIAS
  else
    echo "" | rad auth --alias $RAD_ALIAS --stdin
  fi
fi

# Print radicle info
rad self

# Run radicle-node and radicle-httpd and tail the logs of both
mkdir -p /root/.radicle/logs
radicle-node --force --listen 0.0.0.0:8776 > /root/.radicle/logs/node.log 2>&1 &
radicle-httpd --listen 0.0.0.0:8080 > /root/.radicle/logs/httpd.log 2>&1 &

tail -f /root/.radicle/logs/node.log /root/.radicle/logs/httpd.log