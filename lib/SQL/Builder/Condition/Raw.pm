package SQL::Builder::Condition::Raw;

use warnings;
use strict;
use parent qw/SQL::Builder::Condition/;
use Attribute::Args;

sub new :ARGS('scalar') {
	my ($raw) = @_;
	return bless {
		raw => $raw,
	};
}

sub toSql :ARGS(__PACKAGE__, DBI::db) {
	my ($self, $dbh) = @_;
	return sprintf '(%s)', $self->{raw};
}

1;
