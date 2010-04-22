	subroutine getmodel(x1,z1,nx,nz,bignx,bignz,buffer,
     1     mu,l,l2mu,denu,denw,ut,wt,tauxx,tauzz,tauxz,dx,dt,
     2     autopad,verbose)

c*******************************************************
c       GETMODEL :
c       READS IN A SPECIFIC PART OF THE MODEL ON DISK
c*******************************************************
	implicit none	
	include 'mpm.inc'

c---------------------------------------------------------------
c       GLOBAL VARIABLES FROM MAIN PROGRAM
c---------------------------------------------------------------
c       MODEL
	REAL dx
	INTEGER bignx, bignz
	INTEGER autopad
c       MOVING BOX
	INTEGER nx,nz
	INTEGER buffer
	REAL mu(nxmax,nzmax)
	REAL l(nxmax,nzmax), l2mu(nxmax,nzmax) 
	REAL denu(nxmax,nzmax), denw(nxmax,nzmax)
	REAL ut(nxmax,nzmax), wt(nxmax,nzmax)
	REAL tauxx(nxmax,nzmax), tauzz(nxmax,nzmax)
	REAL tauxz(nxmax,nzmax)
c       TIME
	REAL dt
c       IO
	INTEGER verbose
c---------------------------------------------------------------
c       GLOBAL VARIABLES FROM MAIN PROGRAM
c---------------------------------------------------------------
	INTEGER x1,z1
	INTEGER ix,iz
	CHARACTER fl*40, fl2mu*40, fmu*40
	CHARACTER fdenu*40, fdenw*40
	REAL arrayx(maxbignx) 

        if (autopad.eq.0) then 
	   fl='l.mod'
	   fmu='mu.mod'
	   fl2mu='l2mu.mod'
	   fdenu='denu.mod'
	   fdenw='denw.mod'
	else
	   fl='l_pad.mod'
	   fmu='mu_pad.mod'
	   fl2mu='l2mu_pad.mod'
	   fdenu='denu_pad.mod'
	   fdenw='denw_pad.mod'
	end if



	if (verbose.gt.5) then 
	   PRINT*, ' WRITING...',nx,buffer
	   print*, 'if (verbose.gt.5) then'
c       WRITE GRIDS TO DISK
	   open(31,file='fl_o',form='unformatted')
	   open(32,file='fmu_o',form='unformatted')
	   open(33,file='fl2mu_o',form='unformatted')
	   open(34,file='fdenu_o',form='unformatted')
	   open(35,file='fdenw_o',form='unformatted')
	   do iz = 1,nz+buffer
	      write(31)(l(ix,iz),ix=1,nx+buffer)
	      write(32)(mu(ix,iz),ix=1,nx+buffer)
	      write(33)(l2mu(ix,iz),ix=1,nx+buffer)
	      write(34)(denu(ix,iz),ix=1,nx+buffer)
	      write(35)(denw(ix,iz),ix=1,nx+buffer)
	   enddo
	   close(31)
	   close(32)
	   close(33)
	   close(34)
	   close(35)
	end if

	if (verbose.gt.1) then 
	   PRINT*, '------------------------------------'
	   PRINT*, ' READING BUFFER FROM DISK'
	   PRINT*, '  FROM (x1,z1)=',x1,z1
	end if

c       SET UP FILE HANDLES
	open(31,file=fl,form='unformatted')
c	rewind(31) 
	open(32,file=fmu,form='unformatted')
c	rewind(32)
	open(33,file=fl2mu,form='unformatted')
c	rewind(33)
	open(34,file=fdenu,form='unformatted')
c	rewind(34)
	open(35,file=fdenw,form='unformatted')
c	rewind(35)
c	do ix=1,nx+buffer
c	   do iz=1,nz+buffer
c	      denu(ix,iz)=2000
c	      denw(ix,iz)=2000
c	      l2mu(ix,iz)=denu(ix,iz)*(6000.**2)
c	      mu(ix,iz)=denu(ix,iz)*(4000.**2)
c	      l(ix,iz)=l2mu(ix,iz)-2*(mu(ix,iz))
c	   enddo
c	enddo

c       READ UNTIL z1 is reached
	if (z1.gt.1) then 
	if (verbose.gt.1) PRINT*, ' SKIPPING TOP CELLS, ncells=',iz
	do iz=1,(z1-1)
           print*, iz
	   read(31) (arrayx(ix),ix=1,bignx)        
	   read(32) (arrayx(ix),ix=1,bignx)        
	   read(33) (arrayx(ix),ix=1,bignx)        
	   read(34) (arrayx(ix),ix=1,bignx)        
	   read(35) (arrayx(ix),ix=1,bignx)        
	enddo
	end if

c       READ DATA from z1:(z1+nx+buffer-) 
	do iz=1,(nz+buffer)
	   read(31) (arrayx(ix),ix=1,bignx,1)        
	   do ix=1,(nx+buffer)
	      l(ix,iz)=arrayx(ix+x1-1)
	   enddo
	   read(32) (arrayx(ix),ix=1,bignx)        
	   do ix=1,(nx+buffer)
	      mu(ix,iz)=arrayx(ix+x1-1)
	   enddo
	   read(33) (arrayx(ix),ix=1,bignx)        
	   do ix=1,(nx+buffer)
	      l2mu(ix,iz)=arrayx(ix+x1-1)
	   enddo
	   read(34) (arrayx(ix),ix=1,bignx)        
	   do ix=1,(nx+buffer)
	      denu(ix,iz)=arrayx(ix+x1-1)
	   enddo
	   read(35) (arrayx(ix),ix=1,bignx)        
	   do ix=1,(nx+buffer)
	      denw(ix,iz)=arrayx(ix+x1-1)
	   enddo
	enddo

	do ix=1,nx+buffer
	   do iz=1,nz+buffer
	      denu(ix,iz)=(dt/dx)/denu(ix,iz)
	      denw(ix,iz)=(dt/dx)/denw(ix,iz)
	      l2mu(ix,iz)=(dt/dx)*l2mu(ix,iz)
	      mu(ix,iz)=(dt/dx)*mu(ix,iz)
	      l(ix,iz)=(dt/dx)*l(ix,iz)
	   enddo
	enddo         

c       CLOSE FILE HANDLES
	close(31)
	close(32)
	close(33)
	close(34)
	close(35)
	if (verbose.gt.0) then 
	   PRINT*, ' WRITING...',nx,buffer
c       WRITE GRIDS TO DISK
	   open(31,file='l_box.mod',form='unformatted')
	   open(32,file='mu_box.mod',form='unformatted')
	   open(33,file='l2mu_box.mod',form='unformatted')
	   open(34,file='denu_box.mod',form='unformatted')
	   open(35,file='denw_box.mod',form='unformatted')
	   do iz = 1,nz+buffer
	      write(31)(l(ix,iz),ix=1,nx+buffer)
	      write(32)(mu(ix,iz),ix=1,nx+buffer)
	      write(33)(l2mu(ix,iz),ix=1,nx+buffer)
	      write(34)(denu(ix,iz),ix=1,nx+buffer)
	      write(35)(denw(ix,iz),ix=1,nx+buffer)
	   enddo
	end if

	if (verbose.gt.1) then 
	   PRINT*, ' END OF READING DISK FILES'
	   PRINT*, '------------------------------------'
	end if
	return 
	end
