
# Grafana 설정 가이드

## 구성 요소
* grafana ([grafana/grafana:6.4.3](https://grafana.com/grafana/download))

## Prerequisite


## 폐쇄망 구축 가이드

* 작업 디렉토리 생성 및 환경 설정
```
$ mkdir -p ~/grafana-install
$ export GRAFANA_HOME=~/grafana-install
$ export GRAFANA_VERSION=6.4.3
$ export REGISTRY=registryip:port
$ cd $GRAFANA_HOME
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
$ sed -i 's/{GRAFANA_VERSION}/'${GRAFANA_VERSION}'/g' grafana.yaml
```

* 폐쇄망에서 설치를 진행하여 별도의 image registry를 사용하는 경우 registry 정보를 추가로 설정해준다.
```
$ sed -i "s/grafana\/grafana/${REGISTRY}\/grafana/g" grafana.yaml		 
```

## Install Steps

1. [Prometheus 확인](https://github.com/tmax-cloud/install-grafana/blob/4.1/README.md#step-1-prometheus-%ED%99%95%EC%9D%B8)
2. [Grafana deploy](https://github.com/tmax-cloud/install-grafana/blob/4.1/README.md#step-2-grafana-deploy)
3. [Grafana 확인](https://github.com/tmax-cloud/install-grafana/blob/4.1/README.md#step-3-grafana-%ED%99%95%EC%9D%B8)	



***

## Step 0. Keycloak 연동
* 목적 : 'Keycloak 연동'
* 순서: 
	* keycloak에서 client 생성 후
	* Client protocol = openid-connect , Access type = confidential Standard Flow Enabled = On, Direct Access Grants Enabled = On
	* Client > grafana > Credentials > Secret 복사 후 version.conf CLIENT_SECRET,CLIENT_ID 를 채운다
	* version.conf KETCLOAK_ADDR에  keycloak 주소를 채운다.
	* Root URL = https://${DOMAIN}/api/grafana/, Valid Redirect URIs = https://${DOMAIN}/api/grafana/login/generic_oauth/* , Admin URL = https://${DOMAIN}/api/grafana/, Web Origins = https://${DOMAIN}/api/grafana/ 
	* DOMAIN = grafana dns 주소(ex grafana.tmaxcloud.org)
![image](https://user-images.githubusercontent.com/66110096/118447268-8a7f3000-b72b-11eb-9bdd-01d4252427c6.png)

## Step 1. Grafana Config 설정

* 목적 : `grafana-config.yaml 파일에 설치를 위한 정보 기입`
* 순서: 
	* 환경에 맞는 config 내용 작성
		* DOMAIN_NAME = apigateway dns address
		* DOMAIN = grafana dns 주소(ex grafana.tmaxcloud.org)
		* KEYCLOAK_ADDR = hyperauth 주소
		* CLIENT_ID = hyperauth에 등록한 grafana client id( grafana로 설정해주세요)
		* CLIENT_SECRET = hyperauth에서 Client > grafana > Credentials > Secret의 문자열
		* REGISTRY = private registry가 존재하지 않는다면 그대로 둔다.
		* GRAFANA_PVC = grafana pvc 용량
		* DOMAIN_NAME = apigateway dns address

***


## Step 1. Prometheus 확인
* 목적 : prometheus 설치 여부를 확인
* monitoring 네임스페이스와 prometheus pod 등을 확인
	* kubectl get ns monitoring - 네임스페이스 확인
	* kubectl get pod -n monitoring - pod 확인
* 설치가 안되어 있다면 promethuse 설치를 참고하여 설치
	* https://github.com/tmax-cloud/install-prometheus
	* grafana 설치와 통합되어 있어서 grafana 가 함께 설치 됨


***

## Step 2. Grafana deploy
* 목적 : grafana 모듈 deploy
* kubectl create -f yaml/ 명령어를 통해 grafana 모듈을 deploy
* 비고
	* grafana 기본 대시보드 설정에서 uid와 변수의 hide값을 변경한 것이다


***


## Step 3. Grafana 확인
* 목적 : grafana 정상 동작 확인
* edit svc $GRAFANA_SVC -n monitoring 명령어를 통해 ClusterIP 타입으로 생성된 서비스를 NodePort 또는 LoadBalancer 타입으로 수정한 뒤 해당 IP:port 를 통해 대시보드에 접근할 수 있음



## 자원 할당 가이드
* 목적 : grafana의 자원 할당
* grafana :
	limits : cpu: 200m / memory: 200Mi
	requests : cpu: 100m / memory: 100Mi

## 삭제 가이드
* 목적: grafana 삭제
* kubectl delete -f /yaml 를 실행한다.
