#!/bin/bash
#!/bin/bash
if ss -ntl | grep -q ':88 '; then
    echo "HAProxy is UP"
    exit 0
else
    echo "HAProxy is DOWN"
    exit 1
fi
