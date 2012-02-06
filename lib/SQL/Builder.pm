package SQL::Builder;

use warnings;
use strict;
use Attribute::Args;
use SQL::Builder::Query::Select;

our $VERSION = 0.01;

sub select :ARGS {
  return SQL::Builder::Query::Select::new;
}

1;
