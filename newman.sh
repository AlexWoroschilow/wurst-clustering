#$ -clear
#$ -S /usr/bin/zsh
#$ -w e
#$ -cwd
#$ -m e -M margraf@zbh.uni-hamburg.de
#$ -j y
#$ -q hpc.q
##$ -l os=12.2
#$ -pe mpi_pe 8
##$ -q 4core.q@node125,4core.q@node123,4core.q@node111
##$ -q node111@4core.q,node123@4core.q,node125@4core.q 
##$ -p -500

export MKL_NUM_THREADS=8
export OMP_NUM_THREADS=8
export LD_LIBRARY_PATH=/work/margraf/intel/lib/intel64
export LD_LIBRARY_PATH=/work/margraf/intel/mkl/lib/intel64:$LD_LIBRARY_PATH
source/work/margraf/intel/composerxe/bin/compilervars.sh intel64
export R_LIBS_USER=$HOME/R
~/bin/R-mkl/R-3.0.1/bin/R --max-ppsize=500000 --slave <newnewman.R >newman.out
perl_ret=$?
echo return code $perl_ret from R script at
date

exit $perl_ret
