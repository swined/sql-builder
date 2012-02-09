package SQL::Builder::Query::Delete;

use warnings;
use strict;
use parent qw/SQL::Builder::Query/;
use Attribute::Args;
use SQL::Builder::TableRef::Table;
use SQL::Builder::Query;
use SQL::Builder::Condition;
use SQL::Builder::Order;
use SQL::Builder::Limit;

sub new :ARGS('scalar') {
  my ($table) = @_;
  return bless { 
	table => SQL::Builder::TableRef::Table::new($table)
  };
}

sub where :ARGS(__PACKAGE__, 'list?') {
  my ($self, @where) = @_;
  $self->{where} = SQL::Builder::Condition::new(@where);
  return $self;
}

sub toSql :ARGS(__PACKAGE__, DBI::db) {
  my ($self, $dbh) = @_;
  die sprintf '%s is not a valid SQL::Builder::Condition', $self->{where} unless UNIVERSAL::isa($self->{where}, 'SQL::Builder::Condition');
  return sprintf 
    'DELETE FROM %s WHERE %s', 
    map { $_->toSql($dbh) }
    $self->{from},
    $self->{where},
}

1;
