perl -lnaF";" -e 'if($F[4]>1024*1024){print $F[8]; $c2+=1}}{print "$.:$c2"'
