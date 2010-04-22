      
      subroutine read_wavepos(nx,nz,buffer,bignx,bignz,movflag,
     1boxx0,boxz0,boxvpx,boxvpz,nt,dt,dx,wavex,wavez,
     2padleft,padtop,verbose)
      implicit none
      include 'mpm.inc'

c
c CHECK THAT nt2(Number of deifned timesteps for box) 
c     IS ABOVE nt and BELOW ntmax 
c     OTHERWISE ADD/REMOVE
c
c
c
c WAVEX,WAVEZ DENOTES THE ORGIN OF THE MOVING GRID
c     WITH RESPECT TO THE HUGE MODEL ON DISK(bignx,bignz)
c
c


c---------------------------------------------------------------
c     Global variables from Main program
c---------------------------------------------------------------
c     MODEL 
      INTEGER bignx,bignz
      REAL dx
      INTEGER padleft,padtop

c     MOVING BOX
      INTEGER nx,nz
      INTEGER buffer
      INTEGER movflag
      INTEGER boxx0, boxz0
      REAL boxvpx, boxvpz
      INTEGER wavex(ntmax),wavez(ntmax)

c     TIME SAMPLING
      INTEGER nt
      REAL dt

c     IO
      INTEGER verbose
c---------------------------------------------------------------
c     Local variables
c---------------------------------------------------------------
      INTEGER nxhalf, nzhalf
      REAL ttt,ttx,ttz
      INTEGER ntravel
      REAL ittt(ntmax),ittx(ntmax),ittz(ntmax)
      REAL dzdt,dxdt
      INTEGER it1,it,it2,iit
      REAL dummy1, dummy2, dummy3
      CHARACTER fwavepos*40
      CHARACTER fwaveposout*40
      fwavepos='wavepos.asc'
      fwaveposout='waveposout.asc'

      nxhalf=int(nx/2)
      nzhalf=int(nz/2)

c---------------------------------------------------------------
c     READ wavepos.asc
c---------------------------------------------------------------
c
      if (verbose.gt.0) then
         PRINT*, '-----------------------------------'
         PRINT*, 'READ_WAVEPOS',nt
         PRINT*
      end if

      if (movflag.eq.0) then
c     GET NUMBER OF POSITIONS
         open(1,file='wavepos.asc',status='OLD')
         rewind(1)
         ntravel=0
 5       if (ttt.ne.999999) then
           read(1,*) ttt,ttx,ttz
           ntravel=ntravel+1
           goto 5
         end if
         close(1)
         ntravel=ntravel-1

c     READ POSITIONS
         open(1,file='wavepos.asc',status='old')
         rewind(1)

         if (verbose.gt.0) PRINT*, ' Ntraveltimes ',ntravel
         read(1,*) ttt,ttx,ttz
         ittt(1)=ttt/dt
         ittx(1)=ttx/dx
         ittz(1)=ttz/dx
c         PRINT*, 'ttt,ttx,ttz ',ittt(1),ittx(1),ittz(1)
         do 500 it=2,ntravel
            read(1,*) ttt,ttx,ttz
            ittt(2)=ttt/dt
            ittx(2)=ttx/dx
            ittz(2)=ttz/dx
c            PRINT*, 'ttt,ttx,ttz ',ittt(2),ittx(2),ittz(2)
            
c     INTERPOLATE
            it1=nint(ittt(1))
            if (it1.eq.0) then
               it1=1
            end if
            it2=nint(ittt(2))
c     CHECK THAT itt-range os within limits set in mpm.inc
            if (ntmax.le.it2) then
               PRINT*, ' -----------------------'
               PRINT*, ' -- SERIOUS WARNING'
               PRINT*, ' -- data in traveltime-input file'
               PRINT*, ' -- conflicts with ntmax boundary in mpm.inc'
               PRINT*, ' -- THIS COULD BE FATAL '
               PRINT*, ' -----------------------'
            end if
            dxdt=(ittx(2)-ittx(1))/(ittt(2)-ittt(1))
            dzdt=(ittz(2)-ittz(1))/(ittt(2)-ittt(1))
            do 400 iit=it1,it2,1
c               wavex(iit)=int(ittx(1)+(dxdt)*(iit-it1))
               wavex(iit)=int(ittx(1)+(dxdt)*(iit-it1))+padleft
               dummy1=ittz(1)
               dummy2=(dzdt)*(iit-it1)
               dummy3=int(dummy1+dummy2)
c               wavez(iit)=int(ittz(1)+(dzdt)*(iit-it1))
               wavez(iit)=int(ittz(1)+(dzdt)*(iit-it1))+padtop
 400        continue           
            
            ittt(1)=ittt(2)
            ittx(1)=ittx(2)
            ittz(1)=ittz(2)
 500     continue
      else
         do it=1,nt
            wavex(it)=nint(boxx0+(it*boxvpx*dt)/dx)+padleft
            wavez(it)=nint(boxz0+(it*boxvpz*dt)/dx)+padtop
         enddo
         if (verbose.gt.0) PRINT*, ' CONSTANTLY MOVING BOX'
      end if

      do iit=1,nt
         wavex(iit)=wavex(iit)-nxhalf
         wavez(iit)=wavez(iit)-nzhalf
         if (wavex(iit).lt.1) wavex(iit)=1
         if (wavez(iit).lt.1) wavez(iit)=1
c
c     NEXT SIX LINES SHOULD GIVE POSITION
c     OF SMALL BOX CORRECTLY IN LAST VERTICAL
c     STRIP
c     HOWEVER THIS CONFLICTS WITH THE DATA IS 
c     READ INTO MEMORY
c     FOR NOW WE KEEP THE IMPLEMENTATION BELOW
c     WHICH CASUES A REGION OF 'BUFFER' NOT
c     TO BE USED TO THE RIGHT
c
c         if ((wavex(iit)+nx).gt.bignx) then
c            wavex(iit)=bignx+1-nx
c         end if
c         if ((wavez(iit)+nz).gt.bignz) then
c            wavez(iit)=bignz+1-nz
c         end if 
         if ((wavex(iit)+nx+buffer).gt.bignx) then
            wavex(iit)=bignx+1-nx-buffer
         end if
         if ((wavez(iit)+nz+buffer).gt.bignz) then
            wavez(iit)=bignz+1-nz-buffer
         end if 

      enddo


      if (verbose.gt.0) write (*,*) ' Writing interp. wavepath to disk'
      open(unit=12,file=fwaveposout)
      rewind(12)
      do 600 iit = 1,nt
         write(12,*) iit*dt,((wavex(iit)+nxhalf)*dx),
     1((wavez(iit)+nzhalf)*dx)
 600  continue
      close(12)
    
      if (verbose.gt.0) then 
         PRINT*
         PRINT*, 'READ_WAVEPOS : END'
         PRINT*, '-----------------------------------'
      end if
      return
      end
      







