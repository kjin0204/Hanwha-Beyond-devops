#!/bin/bash

echo "======================================"
echo "Section02 - Kubernetes 리소스 삭제"
echo "======================================"
echo ""

read -p "모든 리소스를 삭제하시겠습니까? (y/N): " confirm
if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
    echo "취소되었습니다."
    exit 0
fi

echo ""
echo "1. Ingress 삭제 중..."
kubectl delete -f ingress002.yml --ignore-not-found=true
echo ""

echo "2. Vue.js 리소스 삭제 중..."
kubectl delete -f vue002ser.yml --ignore-not-found=true
kubectl delete -f vue002dep.yml --ignore-not-found=true
echo ""

echo "3. Spring Boot 리소스 삭제 중..."
kubectl delete -f boot002ser.yml --ignore-not-found=true
kubectl delete -f boot002dep.yml --ignore-not-found=true
echo ""

echo "======================================"
echo "삭제 완료!"
echo "======================================"
echo ""

echo "남은 리소스 확인:"
kubectl get pods 
echo ""
kubectl get svc 
echo ""
kubectl get ingress 
echo ""

echo "모든 리소스가 삭제되었습니다."

