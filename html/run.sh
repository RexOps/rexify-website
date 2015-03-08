#!/bin/sh

cd /var/tmp
git clone https://github.com/RexOps/Rex.git rex
git clone https://github.com/RexOps/rexify-website.git website

cd rex
mkdir -p doc/html/Rex/Box
mkdir -p doc/html/Rex/Commands
mkdir -p doc/html/Rex/Virtualization
mkdir -p doc/html/Rex/FS

misc/create_pod.sh

cp -R doc/html/Rex* /var/project/templates/api/

cd /var/tmp/website

#perl create_index.pl 172.17.42.1 9200 /var/project/templates

cd /var/project

hypnotoad -f website.pl


