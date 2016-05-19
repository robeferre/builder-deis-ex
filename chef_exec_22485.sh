#!/bin/bash

set -e

cd /devops/common/chef 
git init
git remote add origin http://gitlab.tokiomarine.com.br/root/Chef.git
git fetch
git checkout -t origin/master
chef-client -z -c /devops/common/chef/client.rb 

#mkdir /tmp/git && \
#git clone http://gitlab.tokiomarine.com.br/root/Chef.git /tmp/git && \
#mv /tmp/git/* /devops/common/chef && \
#rm -rf /tmp/git && \
#chef-client -z -c /devops/common/chef/client.rb
