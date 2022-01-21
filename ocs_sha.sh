OCS_VERSION=$1

echo Creating temporary directory /tmp/$OCS_VERSION/
mkdir -p /tmp/$OCS_VERSION/
cd /tmp/$OCS_VERSION/
echo ""
echo Collecting SHA value of ODF-$OCS_VERSION images

oc image info  registry.redhat.io/ocs4/ocs-operator-bundle:$OCS_VERSION  --filter-by-os=linux/amd64 | grep "Manifest" | awk '{print $3}' | awk '{print "/ocs4/ocs-operator-bundle@"$0}' >> collect_SHA.txt
oc image extract registry.redhat.io/ocs4/ocs-operator-bundle:$OCS_VERSION --path /manifests/ocs-operator.clusterserviceversion.yaml:./ --confirm
cat ocs-operator.clusterserviceversion.yaml | grep "image:" | sort -u >> collect_SHA.txt
cat collect_SHA.txt | sed -e 's/^[ \t]*//' > SHA.txt
sed -i 's/- image: registry.redhat.io//g' SHA.txt
sed -i 's/image: registry.redhat.io//g' SHA.txt
sed -i 's/@sha256:/ | /g' SHA.txt
sed -i 's/[/]//' SHA.txt
awk '!seen[$0]++' SHA.txt > SHA_final.txt
echo ---------------------------------------------------------------------------------
echo Printing SHA value of OCS-$OCS_VERSION images
echo ---------------------------------------------------------------------------------
cat SHA_final.txt
echo ---------------------------------------------------------------------------------
echo ""
echo Deleting temporary directory /tmp/$OCS_VERSION/
cd ..
rm -rf /tmp/$OCS_VERSION/
echo ""

