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

sub map :ARGS(__PACKAGE__, DBI::db, 'CODE?', 'list?') {
	my ($self, $dbh, $cb, @bp) = @_;
	my @result;
	$cb ||= sub { $_ };
	$self->foreach(
		$dbh,
		sub {
			my @r = &$cb($_);
			push @result, @r if @r;
		},
		@bp,
	);
	return @result;
}

1;