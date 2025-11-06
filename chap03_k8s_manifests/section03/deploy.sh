#!/bin/bash

echo "======================================"
echo "Section03 - Kubernetes 통합 환경 배포"
echo "======================================"
echo ""

# 배포 순서대로 실행
echo "1. PersistentVolumeClaim 생성..."
kubectl apply -f mariadb-pvc.yml
echo ""

echo "2. MariaDB 배포 중..."
kubectl apply -f mariadb003dep.yml
kubectl apply -f mariadb003ser.yml
echo ""

echo "3. MariaDB Pod가 Ready 상태가 될 때까지 대기 중..."
kubectl wait --for=condition=ready pod -l app=mariadb003kube --timeout=120s
echo ""

echo "4. Spring Boot 배포 중..."
kubectl apply -f boot003dep.yml
kubectl apply -f boot003ser.yml
echo ""

echo "5. Spring Boot Pod가 Ready 상태가 될 때까지 대기 중..."
kubectl wait --for=condition=ready pod -l app=boot003kube --timeout=120s
echo ""

echo "6. Vue.js 배포 중..."
kubectl apply -f vue003dep.yml
kubectl apply -f vue003ser.yml
echo ""

echo "7. Ingress 배포 중..."
kubectl apply -f ingress003.yml
echo ""

echo "======================================"
echo "배포 완료!"
echo "======================================"
echo ""

echo "리소스 상태 확인:"
kubectl get pods
echo ""
kubectl get svc
echo ""
kubectl get pvc
echo ""
kubectl get ingress
echo ""


