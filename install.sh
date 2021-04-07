sudo chmod +x version.conf
source version.conf

cd yaml
if [ $REGISTRY != "{REGISTRY}" ]; then
  sudo docker tag grafana/grafana:${GRAFANA_VERSION} ${REGISTRY}/grafana:${GRAFANA_VERSION}
  sudo docker push ${REGISTRY}/grafana:${GRAFANA_VERSION}
  sed -i "s/grafana\/grafana/${REGISTRY}\/grafana/g" grafana.yaml
fi


sed -i 's/{GRAFANA_VERSION}/'${GRAFANA_VERSION}'/g' grafana.yaml

cd ..

kubectl create -f yaml/
