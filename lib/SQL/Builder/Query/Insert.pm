package SQL::Builder::Query::Insert;

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

sub into :ARGS(__PACKAGE__, 'any', 'list?') {
  my ($self, $table, @fields) = @_;
  $table = SQL::Builder::TableRef::Table::new($table) unless ref $table;
  $self->{table} = $table;
  $self->{fields} = [ @fields ];
  return $self;
}

sub values :ARGS(__PACKAGE__, 'list?') {
  my ($self, @values) = @_;
  $self->{values} ||= [];
  push @{$self->{values}}, [@values];
  return $self;
}

sub toSql :ARGS(__PACKAGE__, DBI::db) {
  my ($self, $dbh) = @_;
  die unless UNIVERSAL::isa($self->{table}, 'SQL::Builder::TableRef::Table');
  die unless $self->{values};
  return sprintf 
    'INSERT INTO %s %s VALUES %s', 
    $self->{table}->toSql($dbh),
    ($self->{fields} ? (sprintf '(%s)', join ', ', map { $dbh->quote_identifier($_) } @{$self->{fields}} ) : ''),
    (join ', ', map { sprintf '(%s)', join ', ', map { $dbh->quote_identifier($_) } @$_ } @{$self->{values}});
}

1;