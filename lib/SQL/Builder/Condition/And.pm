package SQL::Builder::Condition::And;

use warnings;
use strict;
use parent qw/SQL::Builder::Condition/;
use Attribute::Args;

sub new :ARGS('list') {
	die 'all args must be a SQL::Builder::Condition' if grep { !UNIVERSAL::isa($_, 'SQL::Builder::Condition') } @_;
	return bless {
		args => [@_],
	};
}

sub toSql :ARGS(__PACKAGE__, DBI::db) {
	my ($self, $dbh) = @_;
	return sprintf '(%s)', join ' AND ', map { $_->toSql($dbh) } @{$self->{args}};
}

1;
