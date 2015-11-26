#wget http://mirrors.softliste.de/cran/src/base/R-3/R-3.0.1.tar.gz
#mkdir bin/R-mkl
#mv R-2.13.2.tar.gz bin/R-mkl
#cd bin/R-mkl
#tar -xzvf R-3.0.1.tar.gz
cd R-3.0.1
#ssh node102
#export MKLROOT=/opt/intel12/composer_xe_2011_sp1.6.233/mkl
#export INTEL_LICENSE_FILE=/opt/intel12/composer_xe_2011_sp1.6.233/licenses:/opt/intel/licenses:/home/margraf/intel/licenses:/opt/intel12/composer_xe_2011_sp1.6.233/licenses:/opt/intel/licenses:/home/margraf/intel/licenses:/opt/intel12/composer_xe_2011_sp1.6.233/licenses:/opt/intel/licenses:/home/margraf/intel/licenses
#export IPPROOT=/opt/intel12/composer_xe_2011_sp1.6.233/ipp
#export LIBRARY_PATH=/opt/intel12/composer_xe_2011_sp1.6.233/compiler/lib/intel64:/opt/intel12/composer_xe_2011_sp1.6.233/ipp/../compiler/lib/intel64:/opt/intel12/composer_xe_2011_sp1.6.233/ipp/lib/intel64:/opt/intel12/composer_xe_2011_sp1.6.233/compiler/lib/intel64:/opt/intel12/composer_xe_2011_sp1.6.233/mkl/lib/intel64:/opt/intel12/composer_xe_2011_sp1.6.233/tbb/lib/intel64//cc4.1.0_libc2.4_kernel2.6.16.21
#export LD_LIBRARY_PATH=/opt/intel12/composer_xe_2011_sp1.6.233/compiler/lib/intel64:/opt/intel12/composer_xe_2011_sp1.6.233/ipp/../compiler/lib/intel64:/opt/intel12/composer_xe_2011_sp1.6.233/ipp/lib/intel64:/opt/intel12/composer_xe_2011_sp1.6.233/compiler/lib/intel64:/opt/intel12/composer_xe_2011_sp1.6.233/mkl/lib/intel64:/opt/intel12/composer_xe_2011_sp1.6.233/tbb/lib/intel64//cc4.1.0_libc2.4_kernel2.6.16.21:/opt/n1ge6/lib/lx24-amd64
#CPATH=/opt/intel12/composer_xe_2011_sp1.6.233/mkl/include:/opt/intel12/composer_xe_2011_sp1.6.233/tbb/include:/opt/intel12/composer_xe_2011_sp1.6.233/tbb/include:/opt/intel12/composer_xe_2011_sp1.6.233/tbb/include
export OMP_LIB_PATH=/work/margraf/intel/composerxe/lib/intel64
export MKL_LIB_PATH="/work/margraf/intel/mkl/lib/intel64"
#export ICC_LIBS="/opt/intel12/lib/intel64"
#export IFC_LIBS="/opt/intel12/lib/intel64"
#export LD_LIBRARY_PATH="$LIBRARY_PATH:$MKL_LIB_PATH:$ICC_LIBS:$IFC_LIBS"
export SHLIB_LDFLAGS="-lpthread"
export MKL="-L${MKL_LIB_PATH} -L${OMP_LIB_PATH} -lifport -lifcore -limf -lsvml -lirc -lmkl_intel_lp64 -lintlc -Wl,--start-group -lmkl_gf_lp64 -lmkl_intel_thread -lmkl_lapack -lmkl_core -Wl,--end-group -liomp5 -lpthread"
#export MKL="-L${MKL_LIB_PATH} -lmkl_gf_lp64 -lmkl_intel_thread -lmkl_lapack -lmkl_core -liomp5 -lpthread"
#export MKL="-L$MKL_LIB_PATH -lifport -lifcore -limf -lsvml -lirc -lmkl_intel_lp64 -lintlc -lmkl_gf_lp64 -lmkl_intel_thread -lmkl_lapack -lmkl_core -liomp5 -lpthread"
#MKL="-L${MKL_LIB_PATH} -mkl -lpthread"


export CC="/work/margraf/intel/bin/icc"
export F77="/work/margraf/intel/bin/ifort"
export CXX="/work/margraf/intel/bin/icpc"
export FC="/work/margraf/intel/bin/ifort"
export AR="/work/margraf/intel/bin/xiar"
export LD="/work/margraf/intel/bin/xild"
export FFLAGS="-cxxlib -O3 -ipo -openmp -xHost"
export CFLAGS="-O3 -ipo -openmp -xHost"
export CXXFLAGS="-O3 -ipo -openmp -xHost"
export FCFLAGS="-cxxlib -O3 -ipo -openmp -xHost"
#export LD_LIBRARY_PATH=/work/margraf/intel/composer_xe_2011_sp1.6.233/compiler/lib/intel64:/work/margraf/intel/composer_xe_2011_sp1.6.233/ipp/../compiler/lib/intel64:/work/margraf/intel/composer_xe_2011_sp1.6.233/ipp/lib/intel64:/work/margraf/intel/composer_xe_2011_sp1.6.233/compiler/lib/intel64:/work/margraf/intel/composer_xe_2011_sp1.6.233/mkl/lib/intel64:/work/margraf/intel/composer_xe_2011_sp1.6.233/tbb/lib/intel64//cc4.1.0_libc2.4_kernel2.6.16.21:/opt/n1ge6/lib/lx24-amd64
export LD_LIBRARY_PATH=${MKL_LIB_PATH}:${OMP_LIB_PATH}
export MKL_LIB_PATH="/work/margraf/intel/mkl/lib/intel64"
export ICC_LIBS="/work/margraf/intel/lib/intel64"
export LDFLAGS="-L$LIBRARY_PATH -L/usr/local/lib64 -Wl -O1 -mkl"
export LD_RUN_PATH="$LD_RUN_PATH:$ICC_LIBS:/usr/local/lib64:${MKL_LIB_PATH}"
#export LDFLAGS="-L$ICC_LIBS -L$IFC_LIBS -L/usr/local/lib64 "
export OMP_NUM_THREADS=8

./configure --with-blas="$MKL" --with-lapack --prefix=$HOME/bin
make -j8
make install

