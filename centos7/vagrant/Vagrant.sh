echo 'Run yum update.'
sudo yum -y update

echo 'Add yum third party repos.'
sudo cp /vagrant/nginx/nginx.repo /etc/yum.repos.d/

echo 'Install require packages.'
sudo yum -y install \
nginx \
httpd \
gcc \
gcc-c++ \
openssl-devel \
zlib-devel \
make \
patch \
git \
gettext \
perl \
rpm-build \
httpd-devel \
curl-devel \
ncurses-devel \
gdbm-devel \
readline-devel \
sqlite-devel \
ruby-devel \
vim \
wget

echo 'Enabled httpd_can_network_connect of SELinux'
sudo setsebool -P httpd_can_network_connect 1

echo 'Uninstall ruby on system'
sudo rm -rf /usr/local/lib/ruby
sudo rm -rf /usr/lib/ruby
sudo rm -f /usr/local/bin/ruby
sudo rm -f /usr/bin/ruby
sudo rm -f /usr/local/bin/irb
sudo rm -f /usr/bin/irb
sudo rm -f /usr/local/bin/gem
sudo rm -f /usr/bin/gem

echo 'Setup rbenv'
if [ ! -e ~/.rbenv ]; then
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
fi
if [ ! -e ~/.rbenv/plugins ]; then
mkdir ~/.rbenv/plugins
fi
if [ ! -e ~/.rbenv/plugins/ruby-build ]; then
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
fi
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
sudo .rbenv/plugins/ruby-build/install.sh
echo 'Install ruby'
rbenv install -v 2.5.1
rbenv rehash
rbenv global 2.5.1
sudo chmod o+x /home/vagrant
gem install passenger --no-ri --no-rdoc -V
rbenv rehash
passenger-install-apache2-module

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

