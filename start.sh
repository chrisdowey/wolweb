#!/bin/sh

if [ ! -f /wolweb/data/devices.json ]; then
  mkdir -p /wolweb/data
  echo '{}' > /wolweb/data/devices.json
fi

/wolweb/wolweb
