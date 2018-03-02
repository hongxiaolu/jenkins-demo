#!/bin/sh

#自定义变量
RANCHER_URL=${RANCHER_URL}
ACCESS_KEY=${ACCESS_KEY}
SECRET_KEY=${SECRET_KEY}
ENV=${ENV:-Default}
STACKS=${STACKS}
REGISTRY=${REGISTRY}
PROJECT=${PROJECT}
LB_TAG=${LB_TAG}


cd ${JOB_NAME}

# Get new tags from remote  
git fetch --tags
# Get latest tag name  
BUILD_TAG=$(git describe --tags `git rev-list --tags --max-count=1`)  

cd ${WORKSPACE}/src

docker build -t ${REGISTRY}/${PROJECT}/${JOB_NAME}:${BUILD_TAG} .
docker push ${REGISTRY}/${PROJECT}/${JOB_NAME}:${BUILD_TAG} 

cd ${WORKSPACE}/test-build

sed -i 's/\$\$REGISTRY\$\$/'${REGISTRY}'/g' docker-compose.yml
sed -i 's/\$\$PROJECT\$\$/'${PROJECT}'/g' docker-compose.yml
sed -i 's/\$\$JOB_NAME\$\$/'${JOB_NAME}'/g' docker-compose.yml
sed -i 's/\$\$BUILD_TAG\$\$/'${BUILD_TAG}'/g' docker-compose.yml
sed -i 's/\$\$LB_TAG\$\$/'${LB_TAG}'/g' docker-compose.yml

chmod 777 ./rancher

./rancher --url ${RANCHER_URL}  --access-key ${ACCESS_KEY}  --secret-key ${SECRET_KEY}  --env ${ENV} up -s ${STACKS}  -d -p --force-upgrade -c
