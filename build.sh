#!/bin/bash

# -----------------------------------------------------------------------------
# AVISOWEB BUILDER
# -----------------------------------------------------------------------------

set -e

file_name="chef_exec_${RANDOM}.sh"
curr_dir=`pwd`
line_to_insert=`awk '/chef_stuff/{ print NR; exit }' $curr_dir/Dockerfile`
line_to_deploy=`awk '/deploy_artifact/{ print NR; exit }' $curr_dir/Dockerfile`
run_cmd="RUN chmod 755 \/*.sh \&\& \/${file_name}"
add_cmd="ADD ${file_name} \/${file_name}"
deploy_cmd="ADD ${1} \/usr\/local\/tomcat\/webapps\/${1}"
DATE=`date +%Y-%m-%d:%H:%M:%S`

# -----------------------------------------------------------------------------
# Populando Dockerfile
# -----------------------------------------------------------------------------
let "line_to_insert+=1"
sed -i "${line_to_insert}s/.*/${add_cmd}/" $curr_dir/Dockerfile
let "line_to_insert+=1"
sed -i "${line_to_insert}s/.*/${run_cmd}/" $curr_dir/Dockerfile
let "line_to_deploy+=1"
sed -i "${line_to_deploy}s/.*/${deploy_cmd}/" $curr_dir/Dockerfile

mv $curr_dir/chef_exec* $curr_dir/$file_name

# -----------------------------------------------------------------------------
# Artifact Handler
# -----------------------------------------------------------------------------
if [ -a $curr_dir/$1 ];then
   rm $curr_dir/$1
fi
if [ -a /tmp/jenkins/jenkins_file/target/$1 ];then
   mv /tmp/jenkins/jenkins_file/target/$1 $curr_dir/$1
fi

# ----------------------------------------------------------------------------
# GIT AND CLEANUP PROCEDURES
# ----------------------------------------------------------------------------
git add . --all && git commit -m "AUTOMATED-REBUILD --> ${DATE}"
echo "INFO --> Pushing to DEIS!!!"

#git push origin master
git push deis master
