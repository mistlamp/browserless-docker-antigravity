#!/bin/bash

# Browserless Docker 컨테이너 설치 및 실행 스크립트
# Windows WSL 환경에서 실행

echo "Docker 버전 확인 중..."
if ! command -v docker &> /dev/null; then
    echo "Docker가 설치되어 있지 않습니다. WSL에서 Docker를 설치하세요."
    exit 1
fi

echo "Docker 버전: $(docker --version)"

echo "Browserless Chrome 이미지 다운로드 중..."
docker pull browserless/chrome

echo "기존 Browserless 컨테이너 정리 중..."
docker stop browserless 2>/dev/null || true
docker rm browserless 2>/dev/null || true

echo "Browserless 컨테이너 실행 중..."
# 포트 3000을 호스트에 매핑하여 실행, HTTP API 활성화
docker run -d --name browserless -p 4040:3000 -e ENABLE_API_GET=true browserless/chrome

echo "Browserless 컨테이너가 실행되었습니다."
echo "접속 URL: http://localhost:4040"
echo "컨테이너 상태 확인: docker ps"

echo "테스트를 위한 Node.js 설치 중..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "puppeteer-core 설치 중..."
npm install puppeteer-core

echo "설치 완료. 테스트: node test_browserless.js"