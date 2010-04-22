	subroutine vel2(bx1,bz1,dt,dx,nx,nz,ut,wt,
     1    denu,denw,tauxx,tauxz,tauzz,freeupper)
	
c       
c*******************************************************
c       VEL2 : 2nd order staggered grid update
c                  of the velocity field
c
c       
c
cc*******************************************************
	
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
	REAL denu(nxmax,nzmax), denw(nxmax,nzmax)
	REAL ut(nxmax,nzmax), wt(nxmax,nzmax)
	REAL tauxx(nxmax,nzmax), tauzz(nxmax,nzmax)
	REAL tauxz(nxmax,nzmax)

c       TIME SAMPLING
	REAL dt

c       BOUNDARIES
	INTEGER freeupper

c       CONSTANTS
	
c----------------------------------------------------------------------
c	LOCAL VARIABLES
c----------------------------------------------------------------------
	INTEGER ix,iz

c----------------------------------------------------------------------
c       UPDATE VELOCITY FIELDS
c----------------------------------------------------------------------


c       TOP BOUNDARY
c----------------------------------------------------------------------
        if (freeupper.eq.0) then
	   iz=2+bz1	 
	   do ix=(3+bx1),(nx-2+bx1)
	     ut(ix,iz)=ut(ix,iz)+denu(ix,iz)*(
     1       +tauxx(ix,iz)-tauxx(ix-1,iz)+tauxz(ix,iz)-tauxz(ix,iz-1))
	  enddo
	  do ix=(3+bx1),(nx-3+bx1)
12           wt(ix,iz)=wt(ix,iz)+denw(ix,iz)*(
     1	     +tauzz(ix,iz+1)-tauzz(ix,iz)+tauxz(ix+1,iz)-tauxz(ix,iz))
	  enddo
        end if

c       BOTTOM BOUNDARY
c----------------------------------------------------------------------
        iz=nz-1+bz1
        do ix=(3+bx1),(nx-2+bx1)
	   ut(ix,iz)=ut(ix,iz)+denu(ix,iz)*(
     1     +tauxx(ix,iz)-tauxx(ix-1,iz)+tauxz(ix,iz)-tauxz(ix,iz-1))
	enddo
        iz=nz-2+bz1
        do ix=(3+bx1),(nx-3+bx1)
	  wt(ix,iz)=wt(ix,iz)+denw(ix,iz)*(
     1    +tauzz(ix,iz+1)-tauzz(ix,iz)+tauxz(ix+1,iz)-tauxz(ix,iz))
	enddo


c       RIGHT BOUNDARY
c----------------------------------------------------------------------
        ix=nx-1+bx1
        do iz=(2+bz1),(nz-1+bz1)
	   ut(ix,iz)=ut(ix,iz)+denu(ix,iz)*(
     1     +tauxx(ix,iz)-tauxx(ix-1,iz)+tauxz(ix,iz)-tauxz(ix,iz-1))
	enddo
        ix=nx-2+bx1
        do iz=(2+bz1),(nz-2+bz1)
	   wt(ix,iz)=wt(ix,iz)+denw(ix,iz)*(
     1     +tauzz(ix,iz+1)-tauzz(ix,iz)+tauxz(ix+1,iz)-tauxz(ix,iz))
	enddo


c       LEFT BOUNDARY
c----------------------------------------------------------------------
        ix=2+bx1
        do iz=(2+bz1),(nz-1+bz1)
	   ut(ix,iz)=ut(ix,iz)+denu(ix,iz)*(
     1     +tauxx(ix,iz)-tauxx(ix-1,iz)+tauxz(ix,iz)-tauxz(ix,iz-1))
	enddo
        do iz=(2+bz1),(nz-2+bz1)
	   wt(ix,iz)=wt(ix,iz)+denw(ix,iz)*(
     1     +tauzz(ix,iz+1)-tauzz(ix,iz)+tauxz(ix+1,iz)-tauxz(ix,iz))
	enddo

	return 
	end
	
