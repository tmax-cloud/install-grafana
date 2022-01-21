sudo chmod +x version.conf
source version.conf

cd yaml
if [ $REGISTRY != "{REGISTRY}" ]; then
  sudo docker tag grafana/grafana:${GRAFANA_VERSION} ${REGISTRY}/grafana:${GRAFANA_VERSION}
  sudo docker push ${REGISTRY}/grafana:${GRAFANA_VERSION}
  sed -i "s/grafana\/grafana/${REGISTRY}\/grafana/g" grafana.yaml
fi


sed -i 's/{GRAFANA_VERSION}/'${GRAFANA_VERSION}'/g' grafana.yaml
sed -i 's/{DOMAIN}/'${DOMAIN}'/g' grafana-config.yaml
sed -i 's/{CLIENT_ID}/'${CLIENT_ID}'/g' grafana-config.yaml
sed -i 's/{CLIENT_SECRET}/'${CLIENT_SECRET}'/g' grafana-config.yaml
sed -i 's/{KEYCLOAK_ADDR}/'${KEYCLOAK_ADDR}'/g' grafana-config.yaml
sed -i 's/{GRAFANA_PVC}/'${GRAFANA_PVC}'/g' grafana-pvc.yaml
sed -i 's/{DOMAIN_NAME}/'${DOMAIN_NAME}'/g' grafana-service.yaml


cd ..

kubectl create -f yaml/
