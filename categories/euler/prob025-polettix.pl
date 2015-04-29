use v6;

=begin pod

=TITLE 1000-digit Fibonacci number

=AUTHOR Flavio Poletti

L<https://projecteuler.net/problem=25>

The Fibonacci sequence is defined by the recurrence relation:

Fn = Fn1 + Fn2, where F1 = 1 and F2 = 1.
Hence the first 12 terms will be:

   F1 = 1
   F2 = 1
   F3 = 2
   F4 = 3
   F5 = 5
   F6 = 8
   F7 = 13
   F8 = 21
   F9 = 34
   F10 = 55
   F11 = 89
   F12 = 144

The 12th term, F12, is the first term to contain three digits.

What is the first term in the Fibonacci sequence to contain 1000 digits?

Expected result: 4782

=end pod

our $limit;
our $digits;
# You can optionally pass how many digits you're looking for, defaults
# to the request in the original challenge.
sub MAIN(Int :$length = 1000, Bool :$verbose = False) {
    # As of August 12, 2009 we don't have big integers, so we'll have
    # to conjure up something. We'll represent each number with an
    # array of digits, base 10 for ease of length computation. The most
    # significant part is at the end of the array, i.e. the array should
    # be read in reverse.
    $digits = 10;
    $limit = 10 ** $digits;
    my @x = (0);
    my @y = (1);

    # This will count the n-th Fibonacci number
    my $c = 1;
    my $current_length = 1;
    while ($current_length < $length) {
        ++$c;

        # (x, y) = (y, x + y)
        my @z = @y;
        addto(@y, @x); # modifies @y in-place
        @x = @z;

        # The most significant part of the number is in the last element
        # of the array; every other element is $digits bytes long by
        # definition.
        my $msb = printable([@y[*-1]]);
        $current_length = $msb.encode('utf-8').bytes + (@y - 1) * $digits;

        # Print a feedback every 20 steps
        if $verbose {
            say "$c -> $current_length" unless $c % 100;
        }
    }

    say $c;
}

# Add a "number" to another, modifies first parameter in place.
# This assumes that length(@y) <= length(@x), which will be true in
# our program because @y is lower than @x
sub addto (@x is rw, @y) {
    my $rest = 0;
    # Assuming length(@y) <= length(@x) means that we have to
    # put "0"s to iterate over the whole $x. This could be
    # improved, but it's unlikely that two consecutive Fibonacci
    # numbers differ by more than one digit
    for (@x Z (@y, 0, *)).flat -> $x is rw, $y {
        $x += $y + $rest;
        $rest = ($x / $limit).Int;
        $x %= $limit;
    }
    push @x, $rest if $rest;
    return;
}

sub printable (@x is copy) {
    my $msb = pop @x;
    return $msb ~ @x.reverse.map({sprintf '%0'~$digits~'d', $_ }).join('');
}

# vim: expandtab shiftwidth=4 ft=perl6
