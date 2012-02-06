package SQL::Builder::Condition;

use warnings;
use strict;
use Attribute::Args;
use SQL::Builder::Condition::Eq;
use SQL::Builder::Condition::And;
use SQL::Builder::Condition::Or;

sub pairs :ARGS('list?') {
  my @results = ();
  push @results, single(shift(), shift()) while @_;
  return @results;
}

sub single :ARGS('scalar', 'any') {
  my ($key, $value) = @_;
  return SQL::Builder::Condition::And::new(pairs @$value) if ($key eq '-AND') and ('ARRAY' eq ref $value);
  return SQL::Builder::Condition::Or::new(pairs @$value) if ($key eq '-OR') and ('ARRAY' eq ref $value);
  return SQL::Builder::Condition::Raw::new($value) if ($key eq '-RAW') and (!ref $value);
  return SQL::Builder::Condition::Eq::new($key, $value);
}

sub new :ARGS('list?') {
  my (@spec) = @_;
  return single '-AND' => [ @spec ];
}

1;
