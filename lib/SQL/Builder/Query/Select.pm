package SQL::Builder::Query::Select;

use warnings;
use strict;
use parent qw/SQL::Builder::Query/;
use Attribute::Args;
use SQL::Builder::TableRef;
use SQL::Builder::Query;
use SQL::Builder::Condition;
use SQL::Builder::Order;
use SQL::Builder::Limit;

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

sub order :ARGS(__PACKAGE__, 'list?') {
	my ($self, @order) = @_;
	$self->{order} = [ map { SQL::Builder::Order::new($_) } @order];
	return $self;
}

sub limit :ARGS(__PACKAGE__, 'scalar', 'scalar') {
	my ($self, $offset, $count) = @_;
	$self->{limit} = SQL::Builder::Limit::new($offset, $count);
	return $self;
}

sub toSql :ARGS(__PACKAGE__, DBI::db) {
  my ($self, $dbh) = @_;
  die 'must specify from() before executing select query' unless UNIVERSAL::isa($self->{from}, 'SQL::Builder::TableRef');
  $self->{where} ||= SQL::Builder::Condition::new('-RAW' => '1 = 1');
  die sprintf '%s is not a valid SQL::Builder::Condition', $self->{where} unless UNIVERSAL::isa($self->{where}, 'SQL::Builder::Condition');
  my $order = join ', ', map { $_->toSql($dbh) } @{$self->{order} || []};
  $order = sprintf 'ORDER BY %s', $order if $order;
  my $limit = $self->{limit} ? $self->{limit}->toSql($dbh) : '';
  return sprintf 
    'SELECT * FROM %s WHERE %s %s %s', 
    (map { $_->toSql($dbh) }
    $self->{from},
    $self->{where}),
    $order,
    $limit;
}

1;
