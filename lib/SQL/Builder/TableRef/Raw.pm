package SQL::Builder::TableRef::Raw;

use warnings;
use strict;
use parent qw/SQL::Builder::TableRef/;
use Attribute::Args;

sub new :ARGS('scalar') {
  my ($raw) = @_;
  return bless {
    raw => $raw,
  };
}

sub toSql :ARGS(__PACKAGE__, DBI::db) {
  my ($self, $dbh) = @_;
  return $self->{raw};
}

1;