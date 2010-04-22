	subroutine mpm_filehandles(restoreautosave,bignx,bignz,
     1             geotype,xyskip,tskip,geou,geow,verbose)
	
c       
c*******************************************************
c       MPM_FILEHANDLES : 
c*******************************************************
	
	implicit none	
	include 'mpm.inc'

c---------------------------------------------------------------	
c       GLOBAL VARIABLES FROM MAIN PROGRAM
c---------------------------------------------------------------
c       MODEL
	INTEGER bignx, bignz
c       IO
	INTEGER usnapflag, wsnapflag, divsnapflag, rotsnapflag
	INTEGER snapsize
	INTEGER beginsnap, dsnap
	INTEGER xyskip
	INTEGER geotype
	INTEGER tskip
	REAL geou(nreceivers),geow(nreceivers)
c       AUTOSAVE
	INTEGER restoreautosave
	INTEGER verbose

c---------------------------------------------------------------	
c       LOCAL VARIABLES
c---------------------------------------------------------------	
c       COUNTER
	INTEGER it1,restoreautosave
	INTEGER ix,iz,it
	INTEGER xmax,zmax,tmax

c---------------------------------------------------------------
c OPEN FILE HANDLES
c---------------------------------------------------------------
	
	if (restoreautosave.eq.1) then
c       GET TIME OF LAST SAVED STATE
	   open(36,file='time.autosave') 
	   rewind(36)
	   read(36,*) it1
	   close(36)
	   it1=it1-1
	   xmax=bignx/xyskip
	   tmax=it1/tskip

	   PRINT*, ' tmax=',tmax,it1,tskip
c	   exit
c       GEOPHONE DATA :
c	MOVE OLD DATA INTO TEMPORARY DISK FILES
	   if ((geotype.eq.1).OR.(geotype.eq.3)) then
	      open(10,file='geou.f77',form='unformatted')      

	      open(11,file='geow.f77',form='unformatted')      
	      open(20,file='geou.f77.back',form='unformatted')      
	      open(21,file='geow.f77.back',form='unformatted')      
	      do it=1,tmax
		 read(10) (geou(ix),ix=1,xmax)
		 read(11) (geow(ix),ix=1,xmax)
		 write(20) (geou(ix),ix=1,xmax)
		 write(21) (geow(ix),ix=1,xmax)
	      enddo
	      close(10)
	      close(11)
	      close(20)
	      close(21)
	   end if
	   if ((geotype.eq.2).OR.(geotype.eq.3)) then
	      open(12,file='geodiv.f77',form='unformatted')      
	      open(13,file='georot.f77',form='unformatted')      
	      open(22,file='geodiv.f77.back',form='unformatted')      
	      open(23,file='georot.f77.back',form='unformatted')      
	      do it=1,tmax
		 read(12) (geou(ix),ix=1,xmax)
		 read(13) (geow(ix),ix=1,xmax)
		 write(22) (geou(ix),ix=1,xmax)
		 write(23) (geow(ix),ix=1,xmax)
	      enddo
	      close(12)
	      close(13)
	      close(22)
	      close(23)
	   end if
	   
c       MOVE TEMPORARY DISK DATA TO PROPER POSITION
	   if ((geotype.eq.1).OR.(geotype.eq.3)) then
	      open(10,file='geou.f77',form='unformatted')      
	      open(11,file='geow.f77',form='unformatted')      
	      open(20,file='geou.f77.back',form='unformatted')      
	      open(21,file='geow.f77.back',form='unformatted')      
	      do it=1,tmax
		 read(20) (geou(ix),ix=1,xmax)
		 read(21) (geow(ix),ix=1,xmax)
		 write(10) (geou(ix),ix=1,xmax)
		 write(11) (geow(ix),ix=1,xmax)
	      enddo	      	      
	      close(20)
	      close(21)
c       FILEHANDLES 10,11 are left open !!
	   end if
	   if ((geotype.eq.2).OR.(geotype.eq.3)) then
	      open(12,file='geodiv.f77',form='unformatted')      
	      open(13,file='georot.f77',form='unformatted')      
	      open(22,file='geodiv.f77.back',form='unformatted')      
	      open(23,file='georot.f77.back',form='unformatted')      
	      do it=1,tmax
		 read(22) (geou(ix),ix=1,xmax)
		 read(23) (geow(ix),ix=1,xmax)
		 write(12) (geou(ix),ix=1,xmax)
		 write(13) (geow(ix),ix=1,xmax)
	      enddo	      	      
	      close(22)
	      close(23)
c       FILEHANDLES 12,13 are left open !!
	   end if

c UPDATE SNAPSHOTS
c       NOT IMPLEMENTED YET
	   open(20,file='ut.snap',form='unformatted')      
	   open(21,file='wt.snap',form='unformatted')      
	   open(22,file='div.snap',form='unformatted')      
	   open(23,file='rot.snap',form='unformatted')      
	   rewind(20)
	   rewind(21) 
	   rewind(22)
	   rewind(23)
	   
	   
	   
	   
	else
c       OPEN FILE HANDLES FOR WRITING	
	   open(10,file='geou.f77',form='unformatted')      
	   open(11,file='geow.f77',form='unformatted')      
	   open(12,file='geodiv.f77',form='unformatted')      
	   open(13,file='georot.f77',form='unformatted')      
	   open(20,file='ut.snap',form='unformatted')      
	   open(21,file='wt.snap',form='unformatted')      
	   open(22,file='div.snap',form='unformatted')      
	   open(23,file='rot.snap',form='unformatted')      
	   rewind(10)
	   rewind(11)
	   rewind(12)
	   rewind(13)
	   rewind(20)
	   rewind(21) 
	   rewind(22)
	   rewind(23)
	end if

	open(5,file='progress')     
	rewind(5)
	return
	end
	

