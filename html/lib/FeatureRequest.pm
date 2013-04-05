#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:
   
package FeatureRequest;

use strict;
use warnings;

use base qw(DBIx::ORMapper::DM::DataSource::Table);

__PACKAGE__->attr(id => "Integer");
__PACKAGE__->attr(created => "DateTime");
__PACKAGE__->attr(email => "String");
__PACKAGE__->attr(feature => "Text");

__PACKAGE__->table("feature_request");
__PACKAGE__->primary_key("id");

1;
