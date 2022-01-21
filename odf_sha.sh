ODF_VERSION=$1

echo Creating temporary directory /tmp/$ODF_VERSION/
mkdir -p /tmp/$ODF_VERSION/
cd /tmp/$ODF_VERSION/
echo ""
echo Collecting SHA value of ODF-$ODF_VERSION images

oc  image info  registry.redhat.io/odf4/odf-operator-bundle:$ODF_VERSION --filter-by-os=linux/amd64 | grep "Manifest" | awk '{print $3}' | awk '{print "/odf4/odf-operator-bundle@"$0}' > collect_SHA.txt
oc  image info  registry.redhat.io/odf4/ocs-operator-bundle:$ODF_VERSION  --filter-by-os=linux/amd64 | grep "Manifest" | awk '{print $3}' | awk '{print "/odf4/ocs-operator-bundle@"$0}' >> collect_SHA.txt
oc  image info  registry.redhat.io/odf4/mcg-operator-bundle:$ODF_VERSION  --filter-by-os=linux/amd64 | grep "Manifest" | awk '{print $3}' | awk '{print "/odf4/mcg-operator-bundle@"$0}' >> collect_SHA.txt
oc  image info  registry.redhat.io/odf4/odf-multicluster-operator-bundle:$ODF_VERSION --filter-by-os=linux/amd64 | grep "Manifest" | awk '{print $3}' | awk '{print "/odf4/odf-multicluster-operator-bundle@"$0}' >> collect_SHA.txt
oc  image info  registry.redhat.io/odf4/odr-hub-operator-bundle:$ODF_VERSION  --filter-by-os=linux/amd64 | grep "Manifest" | awk '{print $3}' | awk '{print "/odf4/odr-hub-operator-bundle@"$0}' >> collect_SHA.txt
oc  image info  registry.redhat.io/odf4/odr-cluster-operator-bundle:$ODF_VERSION --filter-by-os=linux/amd64 | grep "Manifest" | awk '{print $3}' | awk '{print "/odf4/odr-cluster-operator-bundle@"$0}' >> collect_SHA.txt

oc image extract registry.redhat.io/odf4/odf-operator-bundle:$ODF_VERSION --path /manifests/odf-operator.clusterserviceversion.yaml:./ --confirm
oc image extract registry.redhat.io/odf4/ocs-operator-bundle:$ODF_VERSION --path /manifests/ocs-operator.clusterserviceversion.yaml:./ --confirm
oc image extract registry.redhat.io/odf4/mcg-operator-bundle:$ODF_VERSION --path /manifests/mcg-operator.clusterserviceversion.yaml:./ --confirm
oc image extract registry.redhat.io/odf4/odf-multicluster-operator-bundle:$ODF_VERSION --path /manifests/odf-multicluster-orchestrator.clusterserviceversion.yaml:./ --confirm
oc image extract registry.redhat.io/odf4/odr-hub-operator-bundle:$ODF_VERSION --path /manifests/odr-hub-operator.clusterserviceversion.yaml:./ --confirm
oc image extract registry.redhat.io/odf4/odr-cluster-operator-bundle:$ODF_VERSION --path /manifests/odr-cluster-operator.clusterserviceversion.yaml:./ --confirm

cat odf-operator.clusterserviceversion.yaml | grep "image:" | sort -u >> collect_SHA.txt
cat ocs-operator.clusterserviceversion.yaml | grep "image:" | sort -u >> collect_SHA.txt
cat mcg-operator.clusterserviceversion.yaml  | grep "image:" | sort -u >> collect_SHA.txt
cat odf-multicluster-orchestrator.clusterserviceversion.yaml  | grep "image:" | sort -u >> collect_SHA.txt
cat odr-hub-operator.clusterserviceversion.yaml| grep "image:" | sort -u >> collect_SHA.txt
cat odr-cluster-operator.clusterserviceversion.yaml| grep "image:" | sort -u >> collect_SHA.txt

cat collect_SHA.txt | sed -e 's/^[ \t]*//' > SHA.txt
sed -i 's/- image: registry.redhat.io//g' SHA.txt
sed -i 's/image: registry.redhat.io//g' SHA.txt
sed -i 's/@sha256:/ | /g' SHA.txt
sed -i 's/[/]//' SHA.txt
awk '!seen[$0]++' SHA.txt > SHA_final.txt
echo ---------------------------------------------------------------------------------
echo Printing SHA value of ODF-$ODF_VERSION images
echo ---------------------------------------------------------------------------------
cat SHA_final.txt
echo ---------------------------------------------------------------------------------
echo ""
echo Deleting temporary directory /tmp/$ODF_VERSION/
cd ..
rm -rf /tmp/$ODF_VERSION/
echo ""

