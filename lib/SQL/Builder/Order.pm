package SQL::Builder::Order;

use warnings;
use strict;
use Attribute::Args;
use SQL::Builder::Order::Raw;
use SQL::Builder::Order::Field;

sub new :ARGS('scalar') {
	my ($spec) = @_;
	$spec =~ /^([\+\-\*])(.*)$/;
	return SQL::Builder::Order::Field::new($2, 'ASC') if $1 eq '+';
	return SQL::Builder::Order::Field::new($2, 'DESC') if $1 eq '-';
	return SQL::Builder::Order::Raw::new($2) if $1 eq '*';
	die;
}

1;
