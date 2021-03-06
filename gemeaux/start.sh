#!/bin/bash

# create certificates if not availes and expose them via the volume
if [ ! -f "/var/capsule/conf/cert.pem" ]; then
    cd /var/capsule/conf/ && /bin/sh -c /git/gemeaux/cert.sh
    cp -v /git/gemeaux/cert.sh /var/capsule/conf/cert.sh
fi

# create basic example app from gemini and expose the python script to the volume
if [ ! -f "/var/capsule/bin/gemini.py" ]; then
    cp -riv /git/gemeaux/example_app.py /var/capsule/bin/gemini.py
fi

# copy example directories on the volume and expose them to the volume
if [ -z "$(ls -A /var/capsule/gmi/)" ]; then
    cp -riv /git/gemeaux/examples/* /var/capsule/gmi/
fi

# not really a clean solution, as we are changing the permission of the cert from root to gemini and copy into the image, but no real easy way to drop privileges 
cp /var/capsule/conf/key.pem /tmp/
chown gemini:nogroup /tmp/key.pem
for i in access.log error.log gemeaux.log hall_of_shame.log RateLimiter.log
do
    touch /var/log/gemeaux/$i
    chown gemini:nogroup /var/log/gemeaux/$i
done

# delete key after 10 seconds 
(sleep 10; rm -fv /tmp/key.pem; echo 'Erased key') &
runuser -u gemini -- /var/capsule/bin/gemini.py --keyfile /tmp/key.pem --certfile /var/capsule/conf/cert.pem --ip ""
