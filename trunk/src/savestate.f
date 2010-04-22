	subroutine savestate(it,nx,nz,buffer,ut,wt,tauxx,tauzz,tauxz)
c       
c*******************************************************
c       SAVESTATE : 
c*******************************************************
	
	implicit none	
	include 'mpm.inc'
	
c       MOVING BOX
	INTEGER nx,nz
	INTEGER buffer
	REAL ut(nxmax,nzmax), wt(nxmax,nzmax)
	REAL tauxx(nxmax,nzmax), tauzz(nxmax,nzmax)
	REAL tauxz(nxmax,nzmax)
	
c       COUNTERS
	INTEGER ix,iz,it

c---------------------------------------------------------------
c       OPEN FILE HANDLES
c---------------------------------------------------------------
	open(31,file='ut.autosave',form='unformatted')      
	open(32,file='wt.autosave',form='unformatted')      
	open(33,file='tauxx.autosave',form='unformatted')      
	open(34,file='tauzz.autosave',form='unformatted')     
	open(35,file='tauxz.autosave',form='unformatted')      
	open(36,file='time.autosave')      
	rewind(31)
	rewind(32)
	rewind(33)
	rewind(34)
	rewind(35) 
	rewind(36)
	

c---------------------------------------------------------------
c       WRITE OUT ARRAYS
c---------------------------------------------------------------
	
	do iz=1,(nz+buffer)
	   write(31) (ut(ix,iz),ix=1,(nx+buffer))
	   write(32) (wt(ix,iz),ix=1,(nx+buffer))
	   write(33) (tauxx(ix,iz),ix=1,(nx+buffer))
	   write(34) (tauzz(ix,iz),ix=1,(nx+buffer))
	   write(35) (tauxz(ix,iz),ix=1,(nx+buffer))
	enddo
	write(36,*) it,'   #AUTOSAVE TIMESTEP'
c---------------------------------------------------------------
c       CLOSE FILE HANDLES
c---------------------------------------------------------------
	close(31)
	close(32)
	close(33)
	close(34)
	close(35) 
	close(36)


	end
