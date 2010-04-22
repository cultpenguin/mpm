	subroutine clayeng(bx1,bz1,c1,c2,dt,dx,nx,nz,ut,wt,
     1	denu,denw,l,mu,l2mu,tauxx,tauxz,tauzz,freeupper)
	
c       
c*******************************************************
c       
c       CLAYTON AND ENQVIST ABSORBING BORDERS
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
	REAL mu(nxmax,nzmax)
	REAL l(nxmax,nzmax), l2mu(nxmax,nzmax) 
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


c       TOP BOUNDARY (if no free surface)
c---------------------------------------------------------------       
	if(freeupper.eq.0) then
	   iz=1+bz1
	   do ix=(2+bx1),(nx-1+bx1)
	      ut(ix,iz)=ut(ix,iz)+sqrt(mu(ix,iz)*denu(ix,iz))
     1	      *(ut(ix,iz+1)-ut(ix,iz))
	   enddo
	   do ix=(2+bx1),(nx-2+bx1)
	      wt(ix,iz)=wt(ix,iz)+sqrt(l2mu(ix,iz)*denw(ix,iz))
     1        *(wt(ix,iz+1)-wt(ix,iz))
	   enddo
	end if


c       BOTTOM BOUNDARY 
c---------------------------------------------------------------       
        iz=nz+bz1
        do ix=(2+bx1),(nx-1+bx1)
	   ut(ix,iz)=ut(ix,iz)-sqrt(mu(ix,iz)*denu(ix,iz))
     1     *(ut(ix,iz)-ut(ix,iz-1))
	enddo
        iz=nz-1+bz1
        do ix=(2+bx1),(nx-2+bx1)
	   wt(ix,iz)=wt(ix,iz)-sqrt(l2mu(ix,iz)*denw(ix,iz))
     1     *(wt(ix,iz)-wt(ix,iz-1))
	enddo

c       RIGHT BOUNDARY 
c---------------------------------------------------------------       
        ix=nx+bx1
        do iz=(1+bz1),(nz+bz1)
	   ut(ix,iz)=ut(ix,iz)-sqrt(l2mu(ix,iz)*denu(ix,iz))
     1     *(ut(ix,iz)-ut(ix-1,iz))
	enddo
        ix=nx-1+bx1
        do iz=(1+bz1),(nz-1+bz1)
           wt(ix,iz)=wt(ix,iz)-sqrt(mu(ix,iz)*denw(ix,iz))
     1     *(wt(ix,iz)-wt(ix-1,iz))
	enddo

c       LEFT BOUNDARY 
c---------------------------------------------------------------       
        ix=1+bx1
        do iz=(1+bz1),(nz+bz1)
	   ut(ix,iz)=ut(ix,iz)+sqrt(l2mu(ix,iz)*denu(ix,iz))
     1     *(ut(ix+1,iz)-ut(ix,iz))
	enddo
	do iz=(1+bz1),(nz-1+bz1)
	   wt(ix,iz)=wt(ix,iz)+sqrt(mu(ix,iz)*denw(ix,iz))
     1     *(wt(ix+1,iz)-wt(ix,iz))
	enddo

	return 
	end
