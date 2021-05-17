
# Grafana 설정 가이드

## 구성 요소
* grafana ([grafana/grafana:6.4.3](https://grafana.com/grafana/download))

## Step 0. Keycloak 연동
* 목적 : 'Keycloak 연동'
* 순서: 
	* keycloak에서 client 생성 후
	* Client protocol = openid-connect , Access type = confidential Standard Flow Enabled = On, Direct Access Grants Enabled = On
	* Root URL = https://${hypercloud_ip}/api/grafana/, Valid Redirect URIs = https://${hypercloud_ip}/api/grafana/login/generic_oauth/* , Admin URL = https://${hypercloud_ip}/api/grafana/, Web Origins = https://${hypercloud_ip}/api/grafana/ 
	* 
![image](https://user-images.githubusercontent.com/66110096/118447268-8a7f3000-b72b-11eb-9bdd-01d4252427c6.png)

## Step 1. Grafana Config 설정

* 목적 : `version.conf 파일에 설치를 위한 정보 기입`
* 순서: 
	* 환경에 맞는 config 내용 작성
		* version.conf 에 알맞는 버전(6.4.3)과 registry 정보를 입력한다.
	

## Step 2. installer 실행
* 목적 : `설치를 위한 shell script 실행`
* 순서: 
	* 권한 부여 및 실행
	``` bash
	$ sudo chmod +x install.sh
	$ ./install.sh
	```
