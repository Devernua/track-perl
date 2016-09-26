perl -lne 'print (join(";", split(" ", $_, 9))) if $. > 1'
