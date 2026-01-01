#!/bin/bash

# Browserless Docker 컨테이너 설치 및 실행 스크립트
# Windows WSL 또는 Linux 환경에서 실행

# 설정 변수
CONTAINER_NAME="browserless"
PORT=4040
TOKEN=""  # 인증 토큰 (필요 시 설정)
MAX_SESSIONS=10
IMAGE="ghcr.io/browserless/chromium:latest"

echo "Docker 버전 확인 중..."
if ! command -v docker &> /dev/null; then
    echo "Docker가 설치되어 있지 않습니다. 설치 후 다시 실행하세요."
    exit 1
fi

echo "Docker 버전: $(docker --version)"

echo "Browserless Chrome 이미지 다운로드 중..."
docker pull $IMAGE

echo "기존 Browserless 컨테이너 정리 중..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

echo "Browserless($CONTAINER_NAME) 시작 중... (포트: $PORT)"
docker run -d \
  --name $CONTAINER_NAME \
  --restart always \
  -p $PORT:3000 \
  -e "TOKEN=$TOKEN" \
  -e "MAX_CONCURRENT_SESSIONS=$MAX_SESSIONS" \
  -e "MAX_QUEUE_LENGTH=5" \
  -e "PRE_REQUEST_HEALTH_CHECK=true" \
  $IMAGE

echo "Browserless 컨테이너가 실행되었습니다."
echo "접속 URL: http://localhost:4040"
echo "컨테이너 상태 확인: docker ps"

echo "테스트를 위한 Node.js 설치 중..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "puppeteer-core 설치 중..."
npm install puppeteer-core

echo "설치 완료. 테스트 실행 중..."
node test_browserless.js