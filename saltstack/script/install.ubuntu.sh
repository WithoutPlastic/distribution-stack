echo "INFO Adding saltstack repository ppa"
add-apt-repository ppa:saltstack/salt
echo "INFO saltstack repository ppa add done"
echo "INFO update package indexs"
apt-get update
echo "INFO update package done"
echo "INFO install saltstack packages"
apt-get install -y salt-master salt-minion salt-syndic salt-cloud salt-ssh salt-api
echo "INFO install saltstack package done"
