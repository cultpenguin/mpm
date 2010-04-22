      
      subroutine read_mpmpar(autopad,dx,nx,nz,buffer,movflag,
     1boxx0,boxz0,boxvpx,boxvpz,nt,dt,xs,zs,sourcetype,rotation,
     2maxf,pulsedelay,
     3freeupper,absmode,edgefactord,dampingwidth,dampingexponent,
     4dampingtype,edgefactorf, vdamp, maxfdamp, expbase,
     5usnapflag,wsnapflag,prsnapflag,divsnapflag,rotsnapflag,snapsize,
     6beginsnap,dsnap,xyskip,traceskip,geotype,geodepth,tskip,style,
     7restoreautosave,dautosave,verbose,sumsource,bignx_disk,bignz_disk)
      
      implicit none
      include 'mpm.inc'

c 17.05.02 adding prsnapflag to mpm.par file
c 14.08.02 chaging box-def from samples to meteres
c          nx->wbox, nz->hbox, buffer->bufferwidth
c 14.08.02 chaging boxx0,boxz0, from samples to meters
c 14.08.02 tmax is read [seconds]
c 14.08.02 geopdepth is changed from samples to meters.
c 15.08.02 removed style optione from mpm.par
c 15.08.02 always use style=1 (new style)


c---------------------------------------------------------------
c     Global variables from Main program
c---------------------------------------------------------------
c     MODEL NO DISK
      REAL dx
      INTEGER bignx, bignz
      INTEGER bignx_disk, bignz_disk
      INTEGER autopad

c     MOVING BOX
      INTEGER nx,nz
      INTEGER buffer
      INTEGER movflag
      INTEGER boxx0, boxz0
      REAL boxvpx, boxvpz

c     TIME SAMPLING
      INTEGER nt
      REAL dt

c     SOURCE
      INTEGER xs,zs
      INTEGER sourcetype,rotation
      INTEGER sumsource
      REAL maxf
      INTEGER pulsedelay

c     BOUNDARIES
      INTEGER freeupper
      INTEGER absmode
      REAL edgefactord
      INTEGER dampingwidth, dampingexponent, dampingtype
      REAL edgefactorf, vdamp, maxfdamp, expbase

c     AUTOSAVE
      INTEGER restoreautosave,dautosave

c     IO
      INTEGER usnapflag, wsnapflag, divsnapflag, rotsnapflag
      INTEGER prsnapflag
      INTEGER snapsize
      INTEGER beginsnap, dsnap
      INTEGER xyskip,traceskip,tskip
      INTEGER style
      INTEGER geotype
      INTEGER geodepth
      INTEGER verbose

c---------------------------------------------------------------
c     Local variables
c---------------------------------------------------------------
      REAL boxx0_real, boxz0_real
      REAL wbox, hbox, bufferwidth
      REAL xs_real,zs_real,tmax
      REAL geodepth_meter
c     COUNTERS

      CHARACTER fwavepos*40
      
      fwavepos='wavepos.asc'

c---------------------------------------------------------------
c     READ mpm.par
c---------------------------------------------------------------

c     
c Read input parameters
c
      open(1,file='mpm.par')
      rewind(1)

      read(1,*)
      read(1,*) bignx_disk,bignz_disk
      read(1,*) dx
      read(1,*) autopad

      read(1,*)
      read(1,*) wbox,hbox,bufferwidth
      read(1,*) movflag
      read(1,*) boxx0_real, boxz0_real, boxvpx, boxvpz

c     next 5 lines added 14.08.2002 /TMH
      nx=nint(wbox/dx)
      nz=nint(hbox/dx)
      buffer=nint(bufferwidth/dx)
      boxx0=nint(boxx0_real/dx)
      boxz0=nint(boxz0_real/dx)

      read(1,*)
      read(1,*) tmax
      read(1,*) dt
      nt=nint(tmax/dt)


      read(1,*)
      read(1,*) sourcetype,rotation
      sumsource=0
      read(1,*) xs_real,zs_real
      read(1,*) maxf
      read(1,*) pulsedelay
      xs=nint(xs_real/dx)
      zs=nint(zs_real/dx)

      read(1,*) 
      read(1,*) geotype
      read(1,*) geodepth_meter
      if (geodepth_meter.eq.0) then 
         geodepth=0
      else
         geodepth=nint(geodepth_meter/dx)
c     JUST TO MAKE SURE THAT THE GEOPHONE VALUE IS NOT
c     UNINTENDED ZERO
         if (geodepth.eq.0) geodepth=0
      end if

      read(1,*) 
      read(1,*) freeupper
      read(1,*) absmode
      read(1,*) edgefactord, dampingwidth, dampingexponent, dampingtype
      read(1,*) edgefactorf, vdamp, maxfdamp, expbase

      read(1,*) 
      read(1,*) restoreautosave
      read(1,*) dautosave

      read(1,*) 
      read(1,*) usnapflag,wsnapflag,prsnapflag,divsnapflag,rotsnapflag
      read(1,*) snapsize
      read(1,*) beginsnap, dsnap
      read(1,*) xyskip
      read(1,*) traceskip
      read(1,*) tskip
c      read(1,*) style
      read(1,*) verbose
c     ALWAYS NEW STYLE
      style=1
      close(1)


      if (pulsedelay.eq.0) then
         pulsedelay=int((2/maxf)/dt)
      end if

      if (verbose.gt.0) then
         PRINT*, '-----------------------------------'
         PRINT*, 'READ_MPMPAR : MPM INPUT PARAMETERS '
         PRINT*
         PRINT*, 'MODEL ON DISK'
         PRINT*, ' bignx_disk=',bignx_disk, ' bignz_disk=',bignz_disk
         PRINT*, ' dx=',dx
         PRINT*, ' autopad=',autopad
         PRINT*, 'MOVING BOX'
         PRINT*, ' nx=',nx, ' nz=',nz
         PRINT*, ' buffer=',buffer
         if (movflag.eq.0) then
            PRINT*, ' -Reading MPM positions from "',fwavepos,'"'
         else
            PRINT*, ' -Box is moving according to :'
            PRINT*, ' -  boxx0=',boxx0,' boxz0=',boxz0
            PRINT*, ' -  boxvpx=',boxvpx,' boxvpz=',boxvpz
         end if
         
         PRINT*, 'TIME SAMPLING'
         PRINT*, ' dt=',dt,' nt=',nt
         
         PRINT*, 'SOURCE'
         if (sourcetype.eq.0) then
            PRINT*, ' Reading source from file "source.asc"'
         else
            if (sourcetype.eq.1) then
               PRINT*, ' Source=Ricker(',sourcetype,')'
            else if (sourcetype.eq.2) then
               PRINT*, ' Source=Cosinus(',sourcetype,')'
            else if (sourcetype.eq.3) then
               PRINT*, ' Source=Gaussian(',sourcetype,')'
            end if
            PRINT*, ' xs=',xs,' zs=',zs
            PRINT*, ' Max Frequyency=',maxf,' PulseDelay=',pulsedelay
         end if

         if (rotation.eq.1) then
            PRINT*, ' Inserting source as ROTATION S-wave'
         else
            PRINT*, ' Inserting source as COMPRESSIONAL P-wave'
         endif

         
         PRINT*, 'RECEIVER'
         if (geotype.eq.0) then 
            PRINT*, ' Reading receivers from "receiver.asc"'
         else
            if (geotype.eq.1) then 
               PRINT*, ' U and W geophones written out'
            else if (geotype.eq.2) then 
               PRINT*, ' U component geophones written out'
            else if (geotype.eq.3) then 
               PRINT*, ' W component geophones written out'
            end if
            PRINT*, ' Geophones written out at sample=',geodepth
         end if

         PRINT*, 'BOUNDARIES'
         if (freeupper.eq.1) then
            PRINT*, ' Using free upper surface'
         else
            PRINT*, ' Using absorbing boundary at top'
         end if
         if (absmode.eq.0) then
            PRINT*, ' Using Clay/Eng only'
         else if(absmode.eq.1) then
            PRINT*, ' Using Clay/Eng + Damping'
            PRINT*, ' -Edgefactor=',edgefactord, ' width=',dampingwidth
            PRINT*, ' -Exponent=',dampingexponent
            if (dampingtype.eq.1) then
               PRINT*, ' --Damping only velocity'
            else
               PRINT*, ' --Damping velocities AND stresses'
            end if
         else if (absmode.eq.2) then
            PRINT*, ' Using FresnelWide angle ABS BORDERS'
         else if (absmode.eq.3) then
            PRINT*, ' Using FresnelNarrow angle ABS BORDERS'
         end if
         if ((absmode.eq.2).OR.(absmode.eq.3)) then
            PRINT*, ' -Edgefactor=',edgefactorf
            PRINT*, ' -Damp Velocity=',vdamp
            PRINT*, ' -Damp Frequency=',maxfdamp
            PRINT*, ' -Exponent Base=',expbase
         end if

         if (freeupper.eq.1) then
               PRINT*,' - USING FREE SURFACE'
         end if


         PRINT*, 'AUTOSAVE'
         if (dautosave.gt.0) then
            PRINT*, ' Saving modeling state for every ',
     1dautosave,' timesample'
         else
            PRINT*, ' Autosave of "state" is turned off'
         end if
         if (restoreautosave.eq.1) then
            PRINT*, ' Restoring from autosave'
         end if
         

         PRINT*, 'OUTPUT'
         if (usnapflag.eq.1) then 
            PRINT*, ' Writing U snapshots'
         end if
         if (wsnapflag.eq.1) then 
            PRINT*, ' Writing W snapshots'
         end if
         if (divsnapflag.eq.1) then 
            PRINT*, ' Writing Divergence snapshots'
         end if
         if (rotsnapflag.eq.1) then 
            PRINT*, ' Writing Rotation snapshots'
         end if
         if (snapsize.eq.1) PRINT*,' Active grid-size snapshots'
         if (snapsize.eq.2) PRINT*,' Box grid-size snapshots'
         if (snapsize.eq.3) PRINT*,' Disk grid-size snapshots'
         PRINT*, ' First snapshot=',beginsnap,'(',dsnap,')'
         PRINT*, ' Skipping every',xyskip,' spacesample'
         PRINT*, ' Skipping every',tskip,' timesample'
         if (dautosave.gt.0) then
            PRINT*, ' Saving modeling state for every ',
     1dautosave,' timesample'
         else
            PRINT*, ' Autosave of "state" is turned off'
         end if
         
         PRINT*
         PRINT*, 'READ_MPMPAR : END'
         PRINT*, '-----------------------------------'
      end if
      return
      end
      





