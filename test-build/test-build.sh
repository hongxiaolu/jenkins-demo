#!/bin/sh
cd ${WORKSPACE}/src

docker build -t 10.211.55.16:80/python-redis-demo:${BUILD_NUMBER} .


docker push 10.211.55.16:80/python-redis-demo:${BUILD_NUMBER}

cd ${WORKSPACE}/test-build

sed -i 's/\$\$BUILD_NUMBER\$\$/'${BUILD_NUMBER}'/g' docker-compose.yml

sed -i 's/\$\$PORT_NUMBER\$\$/'`expr 5000 + ${BUILD_NUMBER}`'/g' docker-compose.yml

chmod 777 ./rancher-compose

./rancher-compose -p python-redis-demo-build${BUILD_NUMBER} up -d
