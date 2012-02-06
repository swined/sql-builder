package SQL::Builder::TableRef::Table;

use warnings;
use strict;
use parent qw/SQL::Builder::TableRef/;
use Attribute::Args;

sub new :ARGS('scalar') {
  my ($name) = @_;
  return bless {
    name => $name,
  };
}

sub toSql :ARGS(__PACKAGE__, DBI::db) {
  my ($self, $dbh) = @_;
  return $dbh->quote_identifier($self->{name});
}

1;