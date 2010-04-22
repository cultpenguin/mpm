	subroutine tau4(bx1,bz1,c1,c2,dt,dx,nx,nz,ut,wt,
     1    tauxx,tauxz,tauzz,l,mu,l2mu)
	
c       
c*******************************************************
c       TAU4 : 4th order staggered grid update
c                  of the stress field
c
c       The existence of free surface is ignored, since
c       the stresses in the free surface are reset to zero
c       right after this update
c
cc*******************************************************
	
	implicit none	
	include 'mpm.inc'
	
c----------------------------------------------------------------------
c       GLOBAL VARIABLES FROM MAIN PROGRAM
c----------------------------------------------------------------------
c       MODEL
	REAL dx
	INTEGER bx1,bz1

c       MOVING BOX
	INTEGER nx,nz
	REAL mu(nxmax,nzmax)
	REAL l(nxmax,nzmax), l2mu(nxmax,nzmax) 
	REAL ut(nxmax,nzmax), wt(nxmax,nzmax)
	REAL tauxx(nxmax,nzmax), tauzz(nxmax,nzmax)
	REAL tauxz(nxmax,nzmax)

c       TIME SAMPLING
	REAL dt

c       CONSTANTS
	REAL c1,c2
	
c----------------------------------------------------------------------
c	LOCAL VARIABLES
c----------------------------------------------------------------------
	INTEGER ix,iz
	REAL dxut,dzwt
c----------------------------------------------------------------------
c UPDATE NORMAL STRESSES
c----------------------------------------------------------------------

        do iz=(3+bz1),(nz-2+bz1)
        do ix=(2+bx1),(nx-2+bx1)
	   dxut=c1*(ut(ix+1,iz)-ut(ix,iz))+c2*(ut(ix-1,iz)-ut(ix+2,iz))
	   dzwt=c1*(wt(ix,iz)-wt(ix,iz-1))+c2*(wt(ix,iz-2)-wt(ix,iz+1))
	   tauxx(ix,iz)=tauxx(ix,iz)+ 
     1	(l2mu(ix,iz)*dxut+l(ix,iz)*dzwt)
	   tauzz(ix,iz)=tauzz(ix,iz)+
     1	(l2mu(ix,iz)*dzwt+l(ix,iz)*dxut)
	enddo
	enddo
c---------------------------------------------------------------
c UPDATE SHEAR STRESSES
c---------------------------------------------------------------       

        do iz=(2+bz1),(nz-2+bz1)
        do ix=(3+bx1),(nx-2+bx1)
        tauxz(ix,iz)=tauxz(ix,iz)+mu(ix,iz)*(
     1	   c1*(ut(ix,iz+1)-ut(ix,iz)+wt(ix,iz)-wt(ix-1,iz))+
     2	   c2*(ut(ix,iz-1)-ut(ix,iz+2)+wt(ix-2,iz)-wt(ix+1,iz)))
	enddo
	enddo

	return 
	end
	
