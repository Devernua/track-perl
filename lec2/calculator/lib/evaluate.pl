=head1 DESCRIPTION

Эта функция должна принять на вход ссылку на массив, который представляет из себя обратную польскую нотацию,
а на выходе вернуть вычисленное выражение

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

sub evaluate {
	my $rpn = shift;
	my @stack;
	eval{
		for (@$rpn) {
			if (/\d+/) 			{ push(@stack, $_) }
			elsif (s/U([-+])/${1}1/) 	{ push(@stack, pop(@stack) * $_)}
			else {
				my $one = pop(@stack);
				my $two = pop(@stack);
				given ($_){
					when (m{^[+]$}) {push(@stack, $two +  $one)}
					when (m{^[-]$}) {push(@stack, $two -  $one)}
					when (m{^[*]$}) {push(@stack, $two *  $one)}
					when (m{^[/]$}) {push(@stack, $two /  $one)}
					when (m{^\^$} ) {push(@stack, $two ** $one)}	
				}
			}
		}
	1} or die "NOOoo";

	return pop(@stack);
}

1;
