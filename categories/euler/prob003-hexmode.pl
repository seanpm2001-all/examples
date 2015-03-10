use v6;

class Prime {
  has @!primes;
  has Int $!number = 1;

  method next() {
    my $not_prime = 1;

    while $not_prime && $!number++ {
      $not_prime = @!primes.grep({$!number % $^a == 0});
    }
    @!primes.push($!number);

    my $copy = $!number;
    return $copy;
  }
}

my $p = Prime.new;
my @q = gather { take $p.next for (0..10) };
my @r;

for (0..10) {
  push @r, $p.next;
}
say @q.join(",");
say @r.join(",");

# vim: expandtab shiftwidth=4 ft=perl6