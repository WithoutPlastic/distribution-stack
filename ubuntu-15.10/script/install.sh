# copy bootstrap control script to /etc/init.d
sudo cp disable-transparent-hugepages /etc/init.d/
# add executable mark
sudo chmod 755 /etc/init.d/disable-transparent-hugepages
# activate bootstrap control script
sudo update-rc.d disable-transparent-hugepages defaults
