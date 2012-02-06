package SQL::Builder::Query;

use warnings;
use strict;
use Attribute::Args;

sub foreach :ARGS(__PACKAGE__, DBI::db, 'CODE', 'list?') {
	my ($self, $dbh, $cb, @bp) = @_;
	$cb ||= sub { $_ };
	my $sth = $dbh->prepare($self->toSql($dbh));
	$sth->execute(@bp);
	while (my $r = $sth->fetchrow_hashref) {
		local $_ = $r;
		&$cb($r);
	}
	return;
}

1;