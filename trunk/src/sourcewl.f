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
      INTEGER normalize_source
      REAL t2,pi,sourcemax
      CHARACTER fsourcewl*40
      
      normalize_source=0

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

         do it=1,2*pulsedelay
            t2 = ((it-pulsedelay)*dt)*((it-pulsedelay)*dt);
            source(it)=
     1           (1.-(2*(pi*maxf)**2)*t2)*exp(-((pi*maxf)**2)*t2)
         enddo

c         do it=1,pulsedelay+1
c            t2=((it-1)*dt)**2
c            source(pulsedelay+it)=
c     1           (1.-(2*(pi*maxf)**2)*t2)*exp(-((pi*maxf)**2)*t2)
c            source(pulsedelay+2-it)=source(pulsedelay+it)
c         enddo

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
     1           ((0.2/maxf)**2))
         enddo
      end if

      sumsource = 0;
      if (sumsource.eq.1) then
         if (verbose.gt.-1) PRINT*, ' INTEGRATING SOURCE PUSLE'
c        INTEGRATING
         do it=2,ntmax 
            source(it)=source(it-1)+source(it)
         enddo
c     double integrate
c         do it=2,ntmax
c           source(it)=source(it-1)+source(it)
c         enddo
      end if


      if (normalize_source.eq.1) then
         sourcemax=0;
         do it=1,ntmax
            if (abs(source(it)).gt.sourcemax) sourcemax=source(it);
         enddo
         do it=1,ntmax
            source(it)=source(it)/sourcemax;
         enddo
      endif
      
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

