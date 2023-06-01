#!/bin/bash

DOCKER_REPOSITORY_NAME=neobns-master
ID=neobns
PW=neobns06181!

#docker image�� ù tag�� Ȯ�� ��, ���� ������ image�� ����
#���� ó�� �����Ǵ� �̸��̶�� 0.01 �̸����� �������ش�.

TAG=$(docker images | awk -v DOCKER_REPOSITORY_NAME=$DOCKER_REPOSITORY_NAME '{if ($1 == DOCKER_REPOSITORY_NAME) print $2;}')

# ���� [0-9]\.[0-9]{1,2} ���� ������ ������ ������ �̹��� �� ���
if [[ $TAG =~ [0-9]\.[0-9]{1,2} ]]; then
    NEW_TAG_VER=$(echo $TAG 0.01 | awk '{print $1+$2}')
    echo "���� ������ $TAG �Դϴ�."
    echo "���ο� ������ $NEW_TAG_VER �Դϴ�"

# �� �� ���Ӱ� ����ų�, lastest or lts �� tag �� ��
else
    # echo "���Ӱ� ������� �̹��� �Դϴ�."
    NEW_TAG_VER=0.01
fi

# ���� ��ġ�� �����ϴ� DOCKER FILE�� ����Ͽ� ����
docker build -t $DOCKER_REPOSITORY_NAME:$NEW_TAG_VER .

# docker hub�� push �ϱ����� login
docker login -u $ID -p $PW

if [ $NEW_TAG_VER != "0.01" ]; then
    docker rmi $DOCKER_REPOSITORY_NAME:$TAG
fi
# ���ο� �±׸� ������ image�� ����
docker tag $DOCKER_REPOSITORY_NAME:$NEW_TAG_VER $ID/$DOCKER_REPOSITORY_NAME:$NEW_TAG_VER

# docker hub�� push
docker push $ID/$DOCKER_REPOSITORY_NAME:$NEW_TAG_VER

# tag�� "latest"�� image�� �ֽ� ������ ���� ����
docker tag $DOCKER_REPOSITORY_NAME:$NEW_TAG_VER $ID/$DOCKER_REPOSITORY_NAME:latest

# latest�� docker hub�� push
docker push $ID/$DOCKER_REPOSITORY_NAME:latest

# ���� ������ ������ �־� latest�� ����
docker rmi $ID/$DOCKER_REPOSITORY_NAME:latest
docker rmi $ID/$DOCKER_REPOSITORY_NAME:$NEW_TAG_VER