=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, состоящий из отдельных токенов.
Токен - это отдельная логическая часть выражения: число, скобка или арифметическая операция
В случае ошибки в выражении функция должна вызывать die с сообщением об ошибке

Знаки '-' и '+' в первой позиции, или после другой арифметической операции стоит воспринимать
как унарные и можно записывать как "U-" и "U+"

Стоит заметить, что после унарного оператора нельзя использовать бинарные операторы
Например последовательность 1 + - / 2 невалидна. Бинарный оператор / идёт после использования унарного "-"

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

sub tokenize {
	chomp(my $expr = shift);
	
	#check input data
	die "incorrect char" 	if ($expr =~ m{[^+\d\s().*e/^-]});
	die "digit space digit" if ($expr =~ m{([\de.]\s+[\de.])});
	die "bad op" 		if ($expr =~ m{[-+*/^]\s*[*/^)]|[(+-]\s*[*/^]});
	
	$expr =~ s/\s//g; 					#delete spaces
	$expr =~ s/(?<![)e\d.])([-+])/U$1/g;			#insert U-+

	die "bad dot" 	if($expr =~ m{\.\D|\.\d?\.\d});
	die "bad op" 	if ($expr =~ m{[Ue]?[-+*/^][^U\d.(]|^[-+*/^)]|[-+*/^(]$|[Ue]{2,}});

	my @res = 	map /\d+/ ? 0 + $_ : $_, 		#convert bad digit to well digit
			grep length ,				#only non empty
			split m{(U[+-]|(?<!e)[-+]|[*()/^])}, 	#tokenize digit and op 
			$expr;
	
	return @res if wantarray;
	return \@res;
}

1;
