#!/bin/sh

cd /var/tmp
git clone https://github.com/RexOps/Rex.git rex
cd rex
mkdir -p doc/html/Rex/{Box,Commands,Virtualization,FS}
misc/create_pod.sh

cp -R doc/html/Rex* /var/project/templates/api/

hypnotoad -f website.pl


