package SQL::Builder::TableRef;

use warnings;
use strict;
use Attribute::Args;
use SQL::Builder::TableRef::Table;
use SQL::Builder::TableRef::Raw;

sub new :ARGS('any', 'scalar?') {
  my ($ref, $spec) = @_;
  return $ref if UNIVERSAL::isa($ref, 'SQL::Builder::TableRef');
  return SQL::Builder::TableRef::Raw::new($spec) if '-RAW' eq $ref;
  return SQL::Builder::TableRef::Table::new($ref) if !ref $ref;  
  die sprintf 'unsupported TableRef definition: %s %s', $ref, $spec;
}

1;