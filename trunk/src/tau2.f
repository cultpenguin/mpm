	subroutine tau2(bx1,bz1,c1,c2,dt,dx,nx,nz,ut,wt,
     1    tauxx,tauxz,tauzz,l,mu,l2mu)
	
c       
c*******************************************************
c       TAU2 : 2nd order staggered grid update
c                  of the stress field
c
c       The existence of free surface is ignored, since
c       the stresses in the free surface are reset to zero
c       right after this update
c
c*******************************************************
	
	implicit none	
	include 'mpm.inc'
	
c---------------------------------------------------------------
c       GLOBAL VARIABLES FROM MAIN PROGRAM
c---------------------------------------------------------------
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

c       BOUNDARIES

c       CONSTANTS
	REAL c1,c2
	
c---------------------------------------------------------------
c	LOL2MUL VARIABLES
c---------------------------------------------------------------
	INTEGER ix,iz
	REAL dxut,dzwt

c---------------------------------------------------------------
c UPDATE NORMAL STRESSES
c---------------------------------------------------------------       



c
c IXudge boundary conditions at top and compute values of stresses. 
c
	iz=(2+bz1)
	do ix=(2+bx1),(nx-2+bx1)
	   dxut=+ut(ix+1,iz)-ut(ix,iz)
	   dzwt=+wt(ix,iz)-wt(ix,iz-1)
	   tauxx(ix,iz)=tauxx(ix,iz)+
     1         (l2mu(ix,iz)*dxut+l(ix,iz)*dzwt)
	   tauzz(ix,iz)=tauzz(ix,iz)+
     1         (l(ix,iz)*dxut+l2mu(ix,iz)*dzwt )
	enddo
	iz=1+bz1
	do ix=(3+bx1),(nx-2+bx1)
	   tauxz(ix,iz)=tauxz(ix,iz)+mu(ix,iz)*(
     1	      +ut(ix,iz+1)-ut(ix,iz)+wt(ix,iz)-wt(ix-1,iz))
	enddo
c
c Compute stresses near bottom bnd by 2nd order correct fd
c       
	iz=nz-1+bz1	
	do ix=(2+bx1),(nx-2+bx1)
     	  dxut=+ut(ix+1,iz)-ut(ix,iz)
     	  dzwt=+wt(ix,iz)-wt(ix,iz-1)
	  tauxx(ix,iz)=tauxx(ix,iz)+
     1       (l2mu(ix,iz)*dxut+l(ix,iz)*dzwt)
	  tauzz(ix,iz)=tauzz(ix,iz)+
     1       (l(ix,iz)*dxut+l2mu(ix,iz)*dzwt)
	enddo
	do ix=(3+bx1),(nx-2+bx1)
	   tauxz(ix,iz)=tauxz(ix,iz)+mu(ix,iz)*(
     1	  +ut(ix,iz+1)-ut(ix,iz)+wt(ix,iz)-wt(ix-1,iz) )
	enddo
c
c Second-order fd at left hand bnd
c
	ix=1+bx1
	do iz=(2+bz1),(nz-1+bz1)
       	  dxut=+ut(ix+1,iz)-ut(ix,iz)
     	  dzwt=+wt(ix,iz)-wt(ix,iz-1)
	  tauxx(ix,iz)=tauxx(ix,iz)+
     1        (l2mu(ix,iz)*dxut+l(ix,iz)*dzwt)
  	  tauzz(ix,iz)=tauzz(ix,iz)+
     1        (l(ix,iz)*dxut+l2mu(ix,iz)*dzwt)
	enddo
	ix=2+bx1
        do iz=(1+bz1),(nz-1+bz1)
          tauxz(ix,iz)=tauxz(ix,iz)+mu(ix,iz)*(
     1	  +ut(ix,iz+1)-ut(ix,iz)+wt(ix,iz)-wt(ix-1,iz) )
	enddo
c
c Second-order fd at right hand bnd
c
	ix=nx-1+bx1
	do iz=(2+bz1),(nz-1+bz1)
     	  dxut=+ut(ix+1,iz)-ut(ix,iz)
     	  dzwt=+wt(ix,iz)-wt(ix,iz-1)
	  tauxx(ix,iz)=tauxx(ix,iz)+
     1       (l2mu(ix,iz)*dxut+l(ix,iz)*dzwt)
	  tauzz(ix,iz)=tauzz(ix,iz)+
     1       (l(ix,iz)*dxut+l2mu(ix,iz)*dzwt)
	enddo
	do iz=(1+bz1),(nz-1+bz1)
	   tauxz(ix,iz)=tauxz(ix,iz)+mu(ix,iz)*(
     1	  +ut(ix,iz+1)-ut(ix,iz)+wt(ix,iz)-wt(ix-1,iz))
	enddo
	return
	end

