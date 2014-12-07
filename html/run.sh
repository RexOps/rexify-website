#!/bin/sh

cd /var/tmp
git clone https://github.com/RexOps/Rex.git rex
cd rex
mkdir -p doc/html/Rex/Box
mkdir -p doc/html/Rex/Commands
mkdir -p doc/html/Rex/Virtualization
mkdir -p doc/html/Rex/FS

misc/create_pod.sh

cp -R doc/html/Rex* /var/project/templates/api/

cd /var/project

hypnotoad -f website.pl


