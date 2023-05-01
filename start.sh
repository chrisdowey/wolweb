#!/bin/sh

if [ ! -f /wolweb/data/devices.json ]; then
  echo '{}' > /wolweb/data/devices.json
fi

/wolweb/wolweb
