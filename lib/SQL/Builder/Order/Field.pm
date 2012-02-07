package SQL::Builder::Order::Field;

use warnings;
use strict;
use parent qw/SQL::Builder::Order/;
use Attribute::Args;

sub new :ARGS('scalar', 'scalar') {
	my ($field, $direction) = @_;
	die unless $direction =~ /^(ASC|DESC)$/;
	return bless {
		field => $field,
		direction => $direction,
	};
}

sub toSql :ARGS(__PACKAGE__, DBI::db) {
	my ($self, $dbh) = @_;
	return sprintf
		'%s %s',
		$dbh->quote_identifier($self->{field}),
		$self->{direction};
}

1;
