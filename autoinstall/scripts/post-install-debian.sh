#!/bin/bash

# update and install dependencies
sudo apt-get -y update
# python and general
sudo apt-get install -y \
    -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" \
    make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
    libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev \
    libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev htop tmux vim
# licorice
sudo apt-get install -y \
    -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" \
    libevent-dev libsqlite3-dev libmsgpack-dev libopenblas-base \
    libopenblas-dev gfortran sqlite3
# X server
sudo apt-get install -y \
    -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" \
    xinit openbox lxterminal

# setup xinit
touch /home/lico/.xinitrc
echo "openbox &" >> /home/lico/.xinitrc
echo "lxterminal --geometry=1000x1000" >> /home/lico/.xinitrc

# install licorice source for kernel hacking and python setup
pushd /home/lico
git clone https://github.com/bil/licorice
git fetch --all --tags
pushd licorice/install
#LICO_ENABLE_USB=0 ./kernel_setup_usb.sh

# create python environment
export HOME=/home/lico
export PYENV_ROOT=$HOME/.pyenv
curl https://pyenv.run | bash
source pyenv_config.sh
cat pyenv_config.sh >> /home/lico/.bashrc
PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.8.12 -f
pyenv virtualenv -f 3.8.12 licorice
./update-deps.sh
exec $SHELL
pre-commit install
popd
popd

# set up permissions
sudo touch /etc/security/limits.d/licorice.conf
echo "lico - rtprio 95" | sudo tee -a /etc/security/limits.d/licorice.conf
echo "lico - memlock unlimited" | sudo tee -a /etc/security/limits.d/licorice.conf
echo "lico - nice -20" | sudo tee -a /etc/security/limits.d/licorice.conf
sudo chown -R lico:lico /home/lico
sudo usermod -aG lp lico

sudo sed -i "s/quiet splash/nosplash/" /etc/default/grub
sudo sed -i "s/GRUB_TIMEOUT_STYLE=hidden/GRUB_TIMEOUT_STYLE=menu/" /etc/default/grub
sudo sed -i "s/GRUB_TIMEOUT=0/GRUB_TIMEOUT=5/" /etc/default/grub
sudo update-grub
