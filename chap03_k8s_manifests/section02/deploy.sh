#!/bin/bash

echo "======================================"
echo "Section02 - Kubernetes Ingress 배포"
echo "Ingress를 사용한 Vue + Spring Boot"
echo "======================================"
echo ""

# 배포 순서대로 실행
echo "1. Spring Boot 배포 중..."
kubectl apply -f boot002dep.yml
kubectl apply -f boot002ser.yml
echo ""

echo "2. Spring Boot Pod가 Ready 상태가 될 때까지 대기 중..."
kubectl wait --for=condition=ready pod -l app=boot002kube --timeout=120s
echo ""

echo "3. Vue.js 배포 중..."
kubectl apply -f vue002dep.yml
kubectl apply -f vue002ser.yml
echo ""

echo "4. Vue.js Pod가 Ready 상태가 될 때까지 대기 중..."
kubectl wait --for=condition=ready pod -l app=vue002kube --timeout=120s
echo ""

echo "5. Ingress 배포 중..."
kubectl apply -f ingress002.yml
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
kubectl get ingress
echo ""


