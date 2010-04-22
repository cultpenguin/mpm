      subroutine setup_recpos(bignx,bignz,ixgeo,izgeo,nrec,geodepth,
     1    dx,padleft,padright,padtop,verbose)
      implicit none
      include 'mpm.inc'

c 23.05.02 Changing coordinats from gridpoint to meters


c---------------------------------------------------------------
c     HCS 18/01/01
c---------------------------------------------------------------
c     Global variables from Main program
c---------------------------------------------------------------
c     MODEL
      INTEGER padleft, padright, padtop
      
c     RECEIVERS
      real dx
      INTEGER bignx,bignz,geodepth,nrec
      REAL ixgeo(nreceivers),izgeo(nreceivers)
      INTEGER verbose      

c---------------------------------------------------------------
c     Local variables
c---------------------------------------------------------------
      INTEGER irec
      REAL dumx,dumz


c---------------------------------------------------------------
c     READ FILE geopos.asc
c---------------------------------------------------------------
c
      if (geodepth.eq.0) then
c     GET NUMBER OF RECEIVERS
         open(1,file='geopos.asc',status='OLD')
         rewind(1)
         nrec=0
         dumx=0
         dumz=0
         irec=0
 5       if (dumx.ne.999999) then
            read(1,*) dumx,dumz
            irec=irec+1
            goto 5
         end if
         close(1)
         nrec=irec-1

c     OPEN FILE
         open(1,file='geopos.asc')
         irec=0   
         rewind(1)
         do irec=1,nrec
            read(1,*) dumx,dumz        
c -------------- 23.05.02 -------------------------------------
c -- changed to use x,z in meters 
            ixgeo(irec) = nint(dumx/dx)+padleft
            izgeo(irec) = nint(dumz/dx)+padtop
c -------------------------------------------------------------
         enddo
         close(1)
      end if

c---------------------------------------------------------------
c     ASSIGN GEOPHONE COORDINATES
c---------------------------------------------------------------


      if (geodepth.gt.0) then
        if (verbose.gt.0) then  
            PRINT*, 'geodepth > 0'
         end if
c        irec=1
        nrec=bignx-padleft-padright
        do irec=1,nrec
            ixgeo(irec) = irec+padleft
            izgeo(irec) = geodepth+padtop
        enddo   
      end if

c---------------------------------------------------------------
c     WRITE GEOPHONE POSITIONS TO DISK
c---------------------------------------------------------------

      open(unit=12,file='geophoneposout.asc')
      rewind(12)
      do irec = 1,nrec
         write(12,*) irec, ixgeo(irec), izgeo(irec)
      enddo
      close(12)


      return
      end

