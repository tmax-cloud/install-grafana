sudo docker pull grafana/grafana:${GRAFANA_VERSION}
sudo docker save grafana/grafana:${GRAFANA_VERSION} > grafana_${GRAFANA_VERSION}.tar

sudo docker load < grafana_${GRAFANA_VERSION}.tar

sudo docker tag grafana/grafana:${GRAFANA_VERSION} ${REGISTRY}/grafana:${GRAFANA_VERSION}

sudo docker push ${REGISTRY}/grafana:${GRAFANA_VERSION}


sed -i 's/{GRAFANA_VERSION}/'${GRAFANA_VERSION}'/g' grafana.yaml

sed -i "s/grafana\/grafana/${REGISTRY}\/grafana/g" grafana.yaml

kubectl create -f yaml/