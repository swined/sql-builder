package SQL::Builder;

use warnings;
use strict;
use Attribute::Args;
use SQL::Builder::Query::Select;
use SQL::Builder::Query::Insert;

our $VERSION = 0.01;

sub select :ARGS {
  return SQL::Builder::Query::Select::new;
}

sub insert :ARGS('scalar', 'hash') {
  my ($table, %values) = @_;
  return
    SQL::Builder::Query::Insert::new
    ->into($table, keys %values)
    ->values(values %values);
}

1;
