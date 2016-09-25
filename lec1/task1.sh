perl -lnae 'print(join (";", splice(@F, 0, 8), join(" ",@F))) if $. > 1'
