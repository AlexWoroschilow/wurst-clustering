#$ -clear
#$ -S /bin/sh
#$ -w e
#$ -cwd
#$ -m e -M margraf@zbh.uni-hamburg.de
#$ -j y
#$ -q 4core.q@node125,4core.q@node123,4core.q@node111
##$ -q node111@4core.q,node123@4core.q,node125@4core.q 
#$ -p -500
#$ -pe mpi_pe 8

export R_LIBS_USER=$HOME/R
/usr/local/zbh64/bin/R --slave <pnewman.R >pnewman.out
perl_ret=$?
echo return code $perl_ret from R script at
date

exit $perl_ret
