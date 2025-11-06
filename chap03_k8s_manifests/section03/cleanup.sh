#!/bin/bash

echo "======================================"
echo "Section03 - Kubernetes 리소스 삭제"
echo "======================================"
echo ""

read -p "모든 리소스를 삭제하시겠습니까? (y/N): " confirm
if [[ $confirm != [yY] && $confirm != [yY][eE][sS] ]]; then
    echo "취소되었습니다."
    exit 0
fi

echo ""
echo "1. Ingress 삭제 중..."
kubectl delete -f ingress003.yml --ignore-not-found=true
echo ""

echo "2. Vue.js 리소스 삭제 중..."
kubectl delete -f vue003ser.yml --ignore-not-found=true
kubectl delete -f vue003dep.yml --ignore-not-found=true
echo ""

echo "3. Spring Boot 리소스 삭제 중..."
kubectl delete -f boot003ser.yml --ignore-not-found=true
kubectl delete -f boot003dep.yml --ignore-not-found=true
echo ""

echo "4. MariaDB 리소스 삭제 중..."
kubectl delete -f mariadb003ser.yml --ignore-not-found=true
kubectl delete -f mariadb003dep.yml --ignore-not-found=true
echo ""

read -p "PersistentVolumeClaim도 삭제하시겠습니까? (데이터가 영구 삭제됩니다) (y/N): " confirm_pvc
if [[ $confirm_pvc == [yY] || $confirm_pvc == [yY][eE][sS] ]]; then
    echo ""
    echo "5. PersistentVolumeClaim 삭제 중..."
    kubectl delete -f mariadb-pvc.yml --ignore-not-found=true
    echo "데이터가 영구 삭제되었습니다."
else
    echo ""
    echo "5. PersistentVolumeClaim은 유지됩니다. (데이터 보존)"
fi

echo ""
echo "======================================"
echo "삭제 완료!"
echo "======================================"
echo ""

echo "남은 리소스 확인:"
kubectl get pods 
kubectl get svc 
kubectl get pvc 
kubectl get ingress 

