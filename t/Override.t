#!/usr/bin/perl -w

use Test::More tests => 4;

BEGIN { use_ok 'Function::Override' }

sub foo {
    my($blech) = @_;
    return "BLECH!";
}

use vars qw($NumArgs);
#$Function::Override::Debug = 1;

my $callback = sub { $NumArgs = scalar @_ };
override('foo', $callback);

is( foo(qw(this that)), 'BLECH!' );
is( $NumArgs, 2 );

BEGIN {
override('open', 
         sub { 
             my $wantarray = (caller(1))[5];
             die "Void context\n" unless defined $wantarray 
         }
        );
}
eval { open(FILE, 'bogus'); };
is( $@, "Void context\n" );
