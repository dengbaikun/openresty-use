#!/bin/bash
REDIS_HOME=/data/redis/redis-cluster
for port in `seq 7001 7006`;
do
  mkdir -p ${REDIS_HOME}/${port}/conf && PORT=${port} envsubst < ./redis-config.tmpl > ${REDIS_HOME}/${port}/conf/redis.conf && mkdir -p ${REDIS_HOME}/${port}/data;
done
#创建6个redis容器
#for port in `seq 7001 7006`;
#do
#	docker run -d -it -p ${port}:${port} -p 1${port}:1${port} -v ${REDIS_HOME}/${port}/conf/redis.conf:/usr/local/etc/redis/redis.conf -v ${REDIS_HOME}/${port}/data:/data --privileged=true --restart always --name redis-${port} --net redis-net --sysctl net.core.somaxconn=1024 redis redis-server /usr/local/etc/redis/redis.conf;
#done
##查找ip
#for port in `seq 7001 7006`;
#do
#	echo  -n "$(docker inspect --format '{{ (index .NetworkSettings.Networks "redis-net").IPAddress }}' "redis-${port}")":${port}" ";
#done
##换行
#echo -e "\n"
##输入信息
#read -p "输入要进入的Docker容器名字，默认redis-7001：" DOCKER_NAME
##判断是否为空
#if [ ! $DOCKER_NAME ];
#	then DOCKER_NAME='redis-7001';
#fi
##进入容器
#docker exec -it redis-7001 /bin/bash