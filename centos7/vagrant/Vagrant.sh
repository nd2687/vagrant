echo 'Run yum update.'
sudo yum -y update

echo 'Add yum third party repos.'
sudo cp /vagrant/nginx/nginx.repo /etc/yum.repos.d/

echo 'Install require packages.'
sudo yum -y install \
nginx \
httpd

echo 'Enabled httpd_can_network_connect of SELinux'
sudo setsebool -P httpd_can_network_connect 1

echo 'Set httpd.conf'
sudo mv /etc/httpd/conf/httpd.conf{,.bak}
sudo cp /vagrant/httpd/httpd.conf /etc/httpd/conf/httpd.conf

echo 'Set nginx.conf'
sudo mv /etc/nginx/conf.d/default.conf{,.bak}
sudo cp /vagrant/nginx/server.conf /etc/nginx/conf.d/server.conf

echo 'Run httpd'
sudo systemctl start httpd
sudo systemctl enable httpd

echo 'Run Nginx'
sudo systemctl start nginx
sudo systemctl enable nginx
