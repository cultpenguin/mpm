	subroutine vel4(bx1,bz1,c1,c2,dt,dx,nx,nz,ut,wt,
     1	denu,denw,tauxx,tauxz,tauzz,freeupper)
	
c       
c*******************************************************
c       VEL4 : 4th order staggered grid update
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
	REAL c1,c2
	
c---------------------------------------------------------------
c	LOCAL VARIABLES
c---------------------------------------------------------------
	INTEGER ix,iz
c---------------------------------------------------------------



	do iz=(3+bz1),(nz-2+bz1)
	do ix=(3+bx1),(nx-2+bx1)
	   ut(ix,iz)=ut(ix,iz)+denu(ix,iz)*(
     1     c1*(tauxx(ix,iz)-tauxx(ix-1,iz)+
     2         tauxz(ix,iz)-tauxz(ix,iz-1))+
     3     c2*(tauxx(ix-2,iz)-tauxx(ix+1,iz)+
     4	       tauxz(ix,iz-2)-tauxz(ix,iz+1)))
	enddo
	enddo

	do iz=(3+bz1),(nz-3+bz1)
	do ix=(3+bx1),(nx-3+bx1)
	   wt(ix,iz)=wt(ix,iz)+denw(ix,iz)*(
     1     c1*(tauzz(ix,iz+1)-tauzz(ix,iz)+
     2         tauxz(ix+1,iz)-tauxz(ix,iz))+
     3     c2*(tauzz(ix,iz-1)-tauzz(ix,iz+2)+
     4         tauxz(ix-1,iz)-tauxz(ix+2,iz)))
	enddo
	enddo

	return 
	end
	
