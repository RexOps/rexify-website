#!/bin/sh

cd /var/tmp
git clone https://github.com/RexOps/Rex.git rex
cd rex
mkdir -p doc/html/Rex/Box
mkdir -p doc/html/Rex/Commands
mkdir -p doc/html/Rex/Virtualization
mkdir -p doc/html/Rex/FS

misc/create_pod.sh

cp -R doc/html/Rex* /var/project/html/templates/api/

cd /var/project

perl create_index.pl 172.17.42.1 9200 html/templates

cd /var/project/html

hypnotoad -f website.pl


