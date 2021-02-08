
# Grafana 설정 가이드

## 구성 요소
* grafana ([grafana/grafana:6.4.3](https://grafana.com/grafana/download))

## Prerequisite


## 폐쇄망 구축 가이드

* 작업 디렉토리 생성 및 환경 설정
```
$ mkdir -p ~/grafana-install
$ export GRAFANA_VERSION=6.4.3
$ export REGISTRY=registryip:port
$ cd $PROMETHEUS_HOME
```
* 외부 네트워크 통신이 가능한 환경에서 필요한 이미지를 다운받는다.
```
$ sudo docker pull grafana/grafana:${GRAFANA_VERSION}
$ sudo docker save grafana/grafana:${GRAFANA_VERSION} > grafana_${GRAFANA_VERSION}.tar
```
* 생성한 이미지 tar 파일을 폐쇄망 환경으로 이동시킨 뒤 사용하려는 registry에 push한다.
```
$ sudo docker load < grafana_${GRAFANA_VERSION}.tar

$ sudo docker tag grafana/grafana:${GRAFANA_VERSION} ${REGISTRY}/grafana:${GRAFANA_VERSION}

$ sudo docker push ${REGISTRY}/grafana:${GRAFANA_VERSION}

```
* yaml파일에 version정보를 추가한다.
```
$ sed -i 's/{GRAFANA_VERSION}/'${GRAFANA_VERSION}'/g' grafana-deployment.yaml
```

* 폐쇄망에서 설치를 진행하여 별도의 image registry를 사용하는 경우 registry 정보를 추가로 설정해준다.
```
$ sed -i "s/grafana\/grafana/${REGISTRY}\/grafana/g" grafana-deployment.yaml		 
```

## Prometheus 설치


## Install Steps
1. [ConfigMap에 Grafana config 생성](https://github.com/tmax-cloud/install-grafana/blob/main/README.md#step-1-configmap%EC%97%90-grafana-config-%EC%83%9D%EC%84%B1)
2. [대시보드 UID 및 설정 변경](https://github.com/tmax-cloud/install-grafana/blob/main/README.md#step-2-%EB%8C%80%EC%8B%9C%EB%B3%B4%EB%93%9C-uid-%EB%B0%8F-%EC%84%A4%EC%A0%95-%EB%B3%80%EA%B2%BD)
3. [Deployment에 Grafana config 적용](https://github.com/tmax-cloud/install-grafana/blob/main/README.md#step-3-deployment%EC%97%90-grafana-config-%EC%A0%81%EC%9A%A9)	


***

## Step 1. ConfigMap에 Grafana config 생성
* 목적 : Default 그라파나 컨테이너에서 하이퍼클라우드 서비스를 위해 일부 설정값을 변경함
* monitoring 네임스페이스에 다음 내용의 ConfigMaps를 추가한다([grafana-config](https://github.com/tmax-cloud/install-grafana/tree/main/yaml/grafana-config.yaml))

***



## Step 2. 대시보드 UID 및 설정 변경
* 목적 : 대시보드 설정 변경
* monitoring 네임스페이스의 grafana-dashboard-k8s-resources-namespace ConfigMaps를 다음 yaml로 변경한다([dashboard](https://github.com/tmax-cloud/install-grafana/tree/main/yaml/grafana-dashboard-k8s-resources-namespace.yaml))
* 비고
	* grafana 기본 ConfigMaps의 내용에서 uid와 변수의 hide값을 변경한 것이다


***

## Step 3. Deployment에 Grafana config 적용
* 목적 : 변경한 설정값을 그라파나 Deployment에 적용함
* monitoring 네임스페이스의 grafana Deployment를 다음 yaml로 변경한다([deployment](https://github.com/tmax-cloud/install-grafana/tree/main/yaml/grafana.yaml))
* 비고
	* 기존 Deployment의 내용에서 volumes와 volumeMounts에 grafana-config를 추가한 것이다

***

## Step 4. 확인
* 목적: HyperCloud에서 Grafana의 정상 동작을 확인함
* HyperCloud UI에서 현재 pod가 존재하는 네임스페이스를 지정한다.
* 메뉴에서 그라파나를 선택한 뒤 대시보드가 출력되면 성공.


## 자원 할당 가이드
* 목적 : grafana의 자원 할당
* grafana :
	limits : cpu: 200m / memory: 200Mi
	requests : cpu: 100m / memory: 100Mi

## 삭제 가이드
* 목적: grafana 삭제
* kubectl delete -f /yaml 를 실행한다.
