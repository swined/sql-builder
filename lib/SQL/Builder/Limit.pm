package SQL::Builder::Limit;

use warnings;
use strict;
use Attribute::Args;

sub new :ARGS('scalar', 'scalar') {
	my ($offset, $count) = @_;
	return bless {
		offset => $offset,
		count => $count,
	};
}

sub toSql :ARGS(__PACKAGE__, DBI::db) {
	my ($self, $dbh) = @_;
	return sprintf 'LIMIT %s, %s', $dbh->quote($self->{offset}), $dbh->quote($self->{count});
}

1;
