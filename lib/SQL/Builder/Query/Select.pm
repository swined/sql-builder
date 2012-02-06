package SQL::Builder::Query::Select;

use warnings;
use strict;
use parent qw/SQL::Builder::Query/;
use Attribute::Args;
use SQL::Builder::TableRef;
use SQL::Builder::Query;
use SQL::Builder::Condition::Raw;

sub new :ARGS {
  return bless { };
}

sub from :ARGS(__PACKAGE__, 'list') {
  my ($self, @from) = @_;
  $self->{from} = SQL::Builder::TableRef::new(@from);
  return $self;
}

sub where :ARGS(__PACKAGE__, 'list?') {
  my ($self, @where) = @_;
  $self->{where} = SQL::Builder::Condition::new(@where);
  return $self;
}

sub toSql :ARGS(__PACKAGE__, DBI::db) {
  my ($self, $dbh) = @_;
  die 'must specify from() before executing select query' unless UNIVERSAL::isa($self->{from}, 'SQL::Builder::TableRef');
  $self->{where} ||= SQL::Builder::Condition::Raw::new('1 = 1');
  die sprintf '%s is not a valid SQL::Builder::Condition', $self->{where} unless UNIVERSAL::isa($self->{where}, 'SQL::Builder::Condition');
  return sprintf 
    'SELECT * FROM %s WHERE %s', 
    map { $_->toSql($dbh) }
    $self->{from},
    $self->{where};
}

1;