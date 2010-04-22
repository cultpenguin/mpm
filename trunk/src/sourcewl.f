      subroutine sourcewl(dt,maxf,pulsedelay,sourcetype,sumsource,
     1                    source,verbose,nt)
c**********************************************************
c     /TMH marts,05,2000
c
c     Cosinus,Gaussian,Ricker source
c
c     dt : sample interval in time
c     maxf : peak frequency ( XX * max frequency)
c     pulsedelay : center-sample of gassian bell
c     source : the source at each time step
c
c*********************************************************
      implicit none
      include 'mpm.inc'

c     Global (from main program) 
      INTEGER sourcetype 
      INTEGER sumsource
      REAL dt
      REAL nt
      REAL maxf
      REAL source(ntmax)
      INTEGER pulsedelay

c     IO
      INTEGER verbose

c---------------------------------------------------------------
c     Local variables
c---------------------------------------------------------------

      INTEGER it,Tstart,nnt
      REAL t2,pi
      CHARACTER fsourcewl*40
      
      fsourcewl='sourcewl.asc'

      
      pi=3.1316
      nnt=int(1./(maxf*dt))
      Tstart=int(pulsedelay-nnt/2)-1

c      b=
c      a=2.*b

      if (verbose.gt.0) then
         PRINT*, '--------------------------------------'
         PRINT*, 'SOURCEWL : MPM READING BIG MODEL '
      end if
      if (sourcetype.eq.0) then 
      if (verbose.gt.0) PRINT*, ' Reading wavelet from ',fsourcewl
c        READ FROM FILE
         call read_source(source,nt)
      else if (sourcetype.eq.1) then
      if (verbose.gt.0) PRINT*, ' Creating Ricker wavelet'
         do it = 1,ntmax
            source(it) = 0.
         enddo
         do it=1,pulsedelay+1
            t2=((it-1)*dt)**2
            source(pulsedelay+it)=
     1           (1.-(2*(pi*maxf)**2)*t2)*exp(-((pi*maxf)**2)*t2)
            source(pulsedelay+2-it)=source(pulsedelay+it)
         enddo

      else if (sourcetype.eq.2) then
      if (verbose.gt.0) PRINT*, ' Creating Cosinus wavelet'
         do it = 1,ntmax
            source(it) = 0.
         enddo
         do it=Tstart,(Tstart+nnt)
            source(it)=0.5-0.5*cos( ((it-Tstart)*2*pi)/nnt )
         enddo
      else if (sourcetype.eq.3) then
      if (verbose.gt.0) PRINT*, ' Creating Gaussian wavelet'
         do it = 1,ntmax
            source(it) = 0.
         enddo
         do it=1,ntmax
            source(it)=exp((-((it*dt)-(pulsedelay*dt))**2)/
     1           ((0.8/maxf)**2))
         enddo
      end if

      if (sumsource.eq.1) then
         if (verbose.gt.0) PRINT*, ' INTEGRATING SOURCE PUSLE'
c        INTEGRATING
         do it=2,ntmax
           source(it)=source(it-1)+source(it)
         enddo
c        NORMALIZING
         do it=2,ntmax
           source(it)=source(it)/source(ntmax)
        enddo
      end if
      
      if (verbose.gt.0) then
         PRINT*, 'SOURCEWL : '
         PRINT*, '--------------------------------------'
      end if

c     WRITE SOURCE TO FILE
      open(unit=31,file='sourceout.asc')
      rewind(31)
      do it=1,ntmax
         write(31,*) (source(it))
      enddo
      close(unit=31)
      return 
      end

