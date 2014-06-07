#!/usr/bin/perl

use strict;
use warnings;

use Benchmark;

# Results:
# Benchmark: timing 10 iterations of Functional, Imperative...
# Functional: 17 wallclock secs (16.86 usr +  0.01 sys = 16.87 CPU) @  0.59/s (n=10)
# Imperative: 16 wallclock secs (16.15 usr +  0.01 sys = 16.16 CPU) @  0.62/s (n=10)

sub isPrime {
  my $n = shift;
  return (grep { $n % $_ == 0 } (2 .. ($n - 1))) ? 0 : 1;
}

sub combine {
  my ($i, @nums) = @_;
  map { [$i, $_] } @nums;
}

sub functional {
  for my $n (1 .. 100) {
    my @pairs  = grep { isPrime($_->[0] + $_->[1]) } 
                 map  { combine($_, (1 .. $_ - 1)) } 
                 (1 .. $n - 1);
  }
}

sub imperative {
  for my $n (1 .. 100) {
    my @imperative_pairs;
    for my $i (1 .. ($n - 1)) {
      for my $j (1 .. ($i - 1)) {
        if (isPrime($i + $j)) {
          push \@imperative_pairs, [$i, $j];
        }
      }
    }
  }
}

timethese (
  10,
  {'Functional' => '&functional',
   'Imperative' => '&imperative'}
);
