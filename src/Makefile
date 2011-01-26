####################################################################
#
# Makefile for mpm
# type 'make' and you should get a binary called 'mpm'
#
#
# /TMH APR 2010
#
########################################################################
#
#
# WHEN USING PGI COMPILERS THE FOLLOWING OPTIONS MIGHT BE GOOD :
#  -Mvect, tries to vectorize loops
#  -Minfo=loop , shows info on vectorization of loops
#  -Mconcur, to try autoparallelization
#  -Minline, if the program uses many calls to small functions
#	     (especially in loops)
#
# REMEMBER to set SETENV NCPUS 2 to use 2 CPUS (PGI)
#

# GNU FORTRAN
FC = gfortran
FFLAGS = -O3 -static
#FFLAGS = -Wall
#FFLAGS = -g

# SUN FORTRAN
#FC = f90 -f77
#FFLAGS = -fast # -O3 # -fast #-autopar -stackvar


# INTEL COMPILERS
# -W1 : WARNINGS
# -W0 : NO WARNING 
# -tpp5  optimize for Pentium(R) processor
# -tpp6  optimize for Pentium(R) Pro, Pentium(R) II and Pentium(R) III processors
# -tpp7  optimize for Pentium(R) 4 processorFC = ifc
# -parallel             enable the auto-parallelizer to generate multi-threaded
#                       code for loops that can be safely executed in parallel
#FC = ifc
#FFLAGS = -tpp6 -O3 -W0

# ABSOFT
#FC = f77
#FFLAGS = -O


OUT = ./mpm

objects = mpm.o read_mpmpar.o read_wavepos.o setup_recpos.o\
	sourcewl.o addsource.o mpm_io.o\
	vel4.o tau4.o clayeng.o vel2.o tau2.o\
	abs_cerjan.o abs_fresnel_wide.o abs_fresnel_narrow.o\
	setmpmgrid.o getmodel.o savestate.o restorestate.o\
	checkarray.o mpm_filehandles.o read_source.o transp.o\
	gethzmodel.o mpm_pad_model.o add_freesurface.o

mpm : $(objects)
	$(FC) $(FFLAGS) -o $(OUT) $(objects) 

mpm.o : mpm.f mpm.inc 
read_mpmpar.o : read_mpmpar.f mpm.inc 
#read_mpmmodel.o : read_mpmmodel.f mpm.inc 
read_wavepos.o : read_wavepos.f mpm.inc
setup_recpos.0 : setup_recpos.f mpm.inc
read_source.o : read_source.f mpm.inc
sourcewl.o : sourcewl.f mpm.inc
addsource.o : addsource.f mpm.inc
mpm_io.o : mpm_io.f mpm.inc
vel4.o : vel4.f mpm.inc
vel2.o : vel2.f mpm.inc
tau4.o : tau4.f mpm.inc
tau2.o : tau2.f mpm.inc
clayeng.o : clayeng.f mpm.inc
abs_cerjan.o : abs_cerjan.f mpm.inc
abs_fresnel_wide.o : abs_fresnel_wide.f mpm.inc
abs_fresnel_narrow.o : abs_fresnel_narrow.f mpm.inc
setmpmgrid.o : setmpmgrid.f mpm.inc
getmodel.o : getmodel.f mpm.inc
savestate.o : savestate.f mpm.inc
restorestate.o : restorestate.f mpm.inc 
checkarray.o : checkarray.f mpm.inc
mpm_filehandles.o : mpm_filehandles.f mpm.inc
transp.o : transp.f mpm.inc
gethzmodel.o : gethzmodel.f mpm.inc
mpm_pad_model.o : mpm_pad_model.f mpm.inc
add_freesurface.o : add_freesurface.f mpm.inc

.PHONY : clean
clean : 
	rm $(objects)




