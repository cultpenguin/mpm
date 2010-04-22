	subroutine add_freesurface(freeupper,wavez,nzfreeupper,nx,bx1,bz1,
	1    bbz1,dampingwidth,tauxx,tauzz,tauxz,it)
c******************************************************************
c       
c       ADD_FREESURFACE
c       
c       TMH, AUG, 01, 2002
c       
c******************************************************************
	implicit none
	include 'mpm.inc'

c       GLOBAL VARIABLES
c       MODEL
	REAL dx
	INTEGER bx1,bz1,bbz1
        INTEGER nzfreeupper
c       MOVING BOX
	INTEGER nx,nz
	INTEGER wavex(ntmax),wavez(ntmax)
	REAL tauxx(nxmax,nzmax), tauzz(nxmax,nzmax)
	REAL tauxz(nxmax,nzmax)
c       BOUNDARIES
	INTEGER freeupper
	INTEGER dampingwidth

c       LOCAL VARIABLES
	INTEGER ix,iz,it,zfree
	INTEGER izstart,izend


c       c FREE SURFACE
c       Apply free surface condition
	if ((freeupper.eq.1).AND.(wavez(it).le.(nzfreeupper+bbz1))) then
	   zfree=(nzfreeupper+bz1)

	   izstart=(dampingwidth+1)+bz1-bbz1
	   izend=dampingwidth+nzfreeupper-bbz1
	   
c	   print*, '-- izstart,izend',izstart,izend
c	   print*, '-- it,bz1,bbz1,wavez(it)',it,bz1,bbz1,wavez(it)
	   
	   do ix=(bx1+1),(nx+bx1)
	      do iz=izstart,izend
		 tauxx(ix,iz)=0.
		 tauzz(ix,iz)=0.
		 tauxz(ix,iz)=0.
	      end do
	   end do
	end if
	

       
	return
	end
