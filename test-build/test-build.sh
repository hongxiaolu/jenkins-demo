#!/bin/sh

RANCHER_URL=${RANCHER_URL}
ACCESS_KEY=${ACCESS_KEY}
SECRET_KEY=${SECRET_KEY}
ENV=${ENV:-Default}
STACKS=${STACKS}

cd ${WORKSPACE}/src

docker build -t 10.211.55.16:80/python-redis-demo:${BUILD_NUMBER} .


docker push 10.211.55.16:80/python-redis-demo:${BUILD_NUMBER}

cd ${WORKSPACE}/test-build

sed -i 's/\$\$BUILD_TAG\$\$/'${BUILD_TAG}'/g' docker-compose.yml

sed -i 's/\$\$BUILD_TAG\$\$/'`expr 5000 + ${BUILD_TAG}`'/g' docker-compose.yml

chmod 777 ./rancher

./rancher --url ${RANCHER_URL}  --access-key ${ACCESS_KEY}  --secret-key ${SECRET_KEY}  --env ${ENV} up -s ${STACKS}  -d -p --force-upgrade -c
