# run :set fileformat=unix in VIM if interpreter problem
#!/bin/bash

export LC_ALL=C

# update system
sudo apt-get update
sudo apt-get --assume-yes upgrade
sudo apt-get --assume-yes install tmux build-essential gcc g++ make binutils zip htop cmake
sudo apt-get --assume-yes install software-properties-common

# install and upgrade python pip
sudo apt-get install python-pip
sudo pip --no-cache-dir install --upgrade pip

# Create ssl keys for jupyter
mkdir ssl
cd ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout "cert.key" -out "cert.pem" -batch
cd ~

# install libraries
sudo pip install -r requirements.txt
sudo python -m spacy download fr

# configure jupyter
jupyter notebook --generate-config
jupyter notebook password

echo "c = get_config()  # get the config object" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.certfile = u'/home/ubuntu/ssl/cert.pem' # path to the certificate we generated" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.keyfile = u'/home/ubuntu/ssl/cert.key' # path to the certificate key we generated" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'  # serve the notebooks locally" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False  # do not open a browser window by default when using notebooks" >> .jupyter/jupyter_notebook_config.py
