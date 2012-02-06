package SQL::Builder::Condition::Eq;

use warnings;
use strict;
use parent qw/SQL::Builder::Condition/;
use Attribute::Args;

sub new :ARGS('scalar', 'scalar') {
	my ($name, $value) = @_;
	return bless {
		name => $name,
		value => $value,
	};
}

sub toSql :ARGS(__PACKAGE__, DBI::db) {
	my ($self, $dbh) = @_;
	return sprintf 
		'(%s = %s)',
		$dbh->quote_identifier($self->{name}),
		$dbh->quote($self->{value});
}

1;
