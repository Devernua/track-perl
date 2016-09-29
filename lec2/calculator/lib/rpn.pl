=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, содержащий обратную польскую нотацию
Один элемент массива - это число или арифметическая операция
В случае ошибки функция должна вызывать die с сообщением об ошибке

=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
use FindBin;
require "$FindBin::Bin/../lib/tokenize.pl";

sub priority {
	my $op = shift;
	given ($op) {
		when(m{^U[+-]$}){ return 5 }
		when(m{^\^$}) 	{ return 5 }
		when(m{^[*/]$})	{ return 3 }
		when(m{^[+-]$})	{ return 2 }
		when(m{^[)]$}) 	{ return 1 }
		when(m{^[(]$}) 	{ return 0 }
		default 	{ die "bad op"}
	}
}


sub rpn {
	my $expr = shift;
	my $source = tokenize($expr);
	my @rpn;
	my @stack;
	
	for (@$source) {
		when (/\d+/){ push(@rpn, $_); }
		when (/[(]/) { push (@stack, $_); }
		default {	
			my $prior = (/U[+-]|\^/) ? &priority($_) + 1 : &priority($_);
			while( defined $stack[-1] && &priority($stack[-1]) >= $prior) { push(@rpn, pop(@stack))};
			if (/[)]/) { ($#stack != -1) ? pop(@stack) : die "bad brackets" }
			else {push(@stack, $_)}
		}
	}
	
	while (defined $stack[-1]) { push(@rpn, pop(@stack))};
	
	@stack = ();
	return \@rpn;
}

1;
