#!/bin/sh
# init script for isucon6-qualifier

set -ex

export DEBIAN_FRONTEND=noninteractive
apt update
apt install -y ansible git aptitude golang-go make
apt remove -y snapd

export GOPATH=/tmp/go
mkdir -p ${GOPATH}/src/github.com/isucon/
cd ${GOPATH}/src/github.com/isucon
rm -rf isucon6-qualify
git clone https://github.com/isucon/isucon6-qualify.git
cd isucon6-qualify/bench
go get github.com/Songmu/timeout
go get github.com/mitchellh/go-homedir
go get github.com/PuerkitoBio/goquery
go get github.com/marcw/cachecontrol
make

git clone https://github.com/tohutohu/isucon6-qualify.git /tmp/isucon6-qualifier
cd /tmp/isucon6-qualifier/provisioning/bench
PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ansible-playbook -i localhost, ansible/*.yml --connection=local
cd /tmp && rm -rf /tmp/isucon6-qualifier

git clone https://github.com/tohutohu/isucon-bench.git /tmp/isucon-bench
cd /tmp/isucon-bench
npm install
systemctl restart bench
