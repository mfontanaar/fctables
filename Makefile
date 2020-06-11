#****************************************************************************
# Makefile for compiling codes and linking with MPI, FFTP and FFTW libraries
# Mauro Fontana - 2/4/2019
#***************************************************************************

#****************************************************************************
# Edit library paths, compiler flags, and code options in Makefile.in
#****************************************************************************
include Makefile.in

#****************************************************************************
# Don't edit below this line
#****************************************************************************
CPP            = $(CPP_$(COMPILER))
FC             = $(FC_$(COMPILER))
CC             = $(CC_$(COMPILER))
FFLAGS         = $(FFLAGS_$(COMPILER))
TARGET_ARCH    = $(TARGET_$(COMPILER))

# OpenMP-MPI  hybdridization
DO_HYBRIDyes   = $($(COMPILER)_OMP)
DO_HYBRIDno    =
LOPENMP        = $(DO_HYBRID$(OPENMP))

MPFUNDEP_fort  = 
MPFUNDEP_mpfr  = contrib/mpfun_mpfr/mpfr/build/lib/libmpfr.a
MPFUNDEP_mpfr += $(MPFUNDER_mpfr) contrib/mpfun_mpfr/gmp/build/lib/libgmp.a

MPFUNDEP       = $(MPFUNDEP_$(MPFUN_VERSION))

export FC COMPILER CC DIGITS

fc_tables: mpfun
	$(CPP) -D_DIGITS=$(DIGITS) fc_tables.fpp -o fc_tables.f90 
	$(FC) $(FFLAGS) $(LOPENMP) mprlinalg_mod.f90 fc_tables.f90 \
		contrib/mpfun_$(MPFUN_VERSION)/*.o $(MPFUNDEP) \
		-Icontrib/mpfun_$(MPFUN_VERSION) -o fc_tables


fc_neumann: mpfun
	$(CPP) -D_DIGITS=$(DIGITS) fc_neumann.fpp -o fc_neumann.f90 
	$(FC) $(FFLAGS) $(LOPENMP) mprlinalg_mod.f90 fc_neumann.f90 \
		contrib/mpfun_$(MPFUN_VERSION)/*.o $(MPFUNDEP) \
		-Icontrib/mpfun_$(MPFUN_VERSION) -o fc_neumann


mpfun:
	$(MAKE) -C contrib/mpfun_$(MPFUN_VERSION)

test:
	$(FC) $(FFLAGS) fc_test.f08 -o fc_test

clean:
	rm -r *.mod fc_tables fc_test

distclean:
	$(MAKE) distclean -C contrib/mpfun_$(MPFUN_VERSION)
	rm -r *.mod fc_tables fc_tables.f90 fc_test
