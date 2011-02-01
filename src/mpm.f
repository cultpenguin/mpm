      PROGRAM mpm
c     17.05.02 implenting pressure file prt.snap (prsnapflag).
c     17.05.02 implenting moving box in big model.
c     22.05.02 Adding transp. Transforming the data to conventional
c     seismic data

c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
c     MPM : Main Phase Modelling
c     (C) Copyright 2001 Thomas Mejer Hansen and Bo Holm Jacobsen 
c     
c     This program is free software; you can redistribute it and/or
c     modify it under the terms of the GNU General Public License
c     as published by the Free Software Foundation; either version 2
c     of the License, or (at your option) any later version. 
c     This program is distributed in the hope that it will be useful,
c     but WITHOUT ANY WARRANTY; without even the implied warranty of
c     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
c     GNU General Public License for more details. You should have 
c     received a copy of the GNU General Public License
c     along with this program; if not, write to the Free Software
c     Foundation, Inc., 59 Temple Place - Suite 330, 
c     Boston, MA  02111-1307, USA.
c     
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
c     Version 1.0 of this code accompanied the paper
c     
c     Title :
c     Efficient finite difference modeling of selected phases
c     using a moving zone.
c     
c     Published in Computers and Geosciences, 2001 
c     
c     Authors :
c     Thomas Mejer Hansen
c     The Niels Bohr Institute of Astronomy, Physics and Geophysics
c     Juliane Mariesvej 30, DK-2100 Koebenhavn OE
c     tmh@gfy.ku.dk
c     
c     Bo Holm Jacobsen
c     Department of Earth Sciences, Univeristy of Aarhus, F
c     Finlandsgade 8, DK-8200 Aarhus N, 
c     bo@geo.aau.dk
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
c     VERSION HISTORY
c     1.0 Numerous updates prior to release, Christian Schioett (hcs@geo
c     .aau.dk)
c
c     1.2 Major update by Thomas Mejer Hansen and Uni Petersen
c         Units should should be more consistent
c
c     1.3 A source can be inserted either as an P or S-wave.     
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
c     CONVENTION AFTER LEVANDER, GEOPHYSICS 1988 
c     Levander, A.
c     Fourth-order finite-difference P-SV seismograms
c     Geophysics, 53(11), 1988, 1425-1436
c     
c     (See Fig.1 and Fig.2)
c     
c     l : lambda
c     l2mu : lambda + 2 mu
c     mu : mu
c     denu : Density [nx,nz]
c     denv : density [nx-1,nz-1]
c     
c     
c     
c     

      implicit none
      include 'mpm.inc'

c---------------------------------------------------------------
c     SETUP VARIABLES
c---------------------------------------------------------------

c     MODEL
      REAL dx
      INTEGER autopad
      INTEGER bignx_disk, bignz_disk
      INTEGER bignx, bignz
      INTEGER bx1,bz1
      INTEGER bbx1,bbz1
      INTEGER padleft,padright,padbot,padtop
      INTEGER nzfreeupper

c     MOVING BOX
      INTEGER nx,nz
      INTEGER buffer
      INTEGER movflag
      INTEGER boxx0, boxz0
      REAL boxvpx, boxvpz
      INTEGER wavex(ntmax),wavez(ntmax)
      REAL mu(nxmax,nzmax)
      REAL l(nxmax,nzmax), l2mu(nxmax,nzmax) 
      REAL denu(nxmax,nzmax), denw(nxmax,nzmax)
      REAL ut(nxmax,nzmax), wt(nxmax,nzmax)
      REAL tauxx(nxmax,nzmax), tauzz(nxmax,nzmax)
      REAL tauxz(nxmax,nzmax)

c     TIME SAMPLING
      INTEGER nt
      REAL dt
      
c     SOURCE
      INTEGER xs,zs
      INTEGER sourcetype,rotation
      INTEGER sumsource
      REAL maxf
      INTEGER pulsedelay
      REAL source(ntmax)

c     BOUNDARIES
      INTEGER freeupper
      INTEGER absmode
      REAL edgefactord
      INTEGER dampingwidth, dampingexponent, dampingtype
      INTEGER izfree
      REAL edgefactorf, vdamp, maxfdamp, expbase
      REAL dampf(nzmax)
c     AUTOSAVE
      INTEGER restoreautosave,dautosave
c     IO
      INTEGER usnapflag, wsnapflag, divsnapflag, rotsnapflag
      INTEGER prsnapflag
      INTEGER snapsize
      INTEGER beginsnap, dsnap
      INTEGER xyskip,traceskip,tskip
      INTEGER geotype
      INTEGER geodepth
      INTEGER verbose
      REAL geou(nreceivers),geow(nreceivers)
      REAL ixgeo(nreceivers),izgeo(nreceivers)
      INTEGER nrec,isnap,style

c     COUNTERS
      INTEGER ix,iz,it
      INTEGER zfree
      INTEGER it1

c     CONSTANTS
      REAL c1,c2

      c1=9./8.
      c2=1./24.
      nzfreeupper=3      
      
      izfree=0
c     ----------- temporary 23.05.02 --------------------
      isnap=0
c     ----------------------------------------------------


c---------------------------------------------------------------
c     READ mpm.par, l2mu.bin, mu.bin, l.bin, denu.bin, denv.bin
c---------------------------------------------------------------
      call read_mpmpar(autopad,dx,nx,nz,buffer,movflag,boxx0,boxz0,
     1     boxvpx,boxvpz,nt,dt,xs,zs,sourcetype,rotation,
     2     maxf,pulsedelay,
     3     freeupper,absmode,edgefactord,dampingwidth,dampingexponent,
     4     dampingtype,edgefactorf, vdamp, maxfdamp, expbase,
     5     usnapflag,wsnapflag,prsnapflag,divsnapflag,rotsnapflag,
     6     snapsize,beginsnap,dsnap,xyskip,traceskip,geotype,geodepth,
     7     tskip,style,restoreautosave,dautosave,verbose,sumsource,
     8     bignx_disk,bignz_disk)

c---------------------------------------------------------------
c     PAD MODEL IF CHOSEN
c---------------------------------------------------------------
      if (autopad.eq.0) then
         bignx=bignx_disk
         bignz=bignz_disk
         padleft=0
         padright=0
         padbot=0
         padtop=0
      else
         call mpm_pad_model(autopad,verbose,
     1        bignx,bignz,bignx_disk,bignz_disk,
     2        padleft,padright,padbot,padtop,
     3        dampingwidth,freeupper,nzfreeupper)

      end if

c     APPLY PADDING TO SOURCES, RECEIVERS
c     shift source positions
      xs=xs+padleft
      zs=zs+padtop
      

c     PADDING OF WAVEPOS IS HANDLED IN READ WAVEPOS.

      if (verbose.gt.0) write (*,*) '- WRITE PAD INFORMATION TO DISK'
      open(unit=12,file='modelpadding.asc')
      rewind(12)
      write(12,*) padleft,padtop,padright,padbot
      close(12)

      if (verbose.gt.0) write (*,*) '- WRITE SOURCE INFORMATION TO DISK'
      open(unit=12,file='sourcepos.asc')
      rewind(12)
      write(12,*) xs,zs
      close(12)



c---------------------------------------------------------------
c     READ WAVEPOS
c---------------------------------------------------------------
      call read_wavepos(nx,nz,buffer,bignx,bignz,movflag,
     1     boxx0,boxz0,boxvpx,boxvpz,nt,dt,dx,wavex,wavez,
     2     padleft,padtop,verbose)

c---------------------------------------------------------------
c     GET RECEIVER POSITIONS
c---------------------------------------------------------------
      call setup_recpos(bignx,bignz,ixgeo,izgeo,nrec,geodepth,dx,
     1     padleft,padright,padtop,verbose)

c---------------------------------------------------------------
c     SETUP SOURCE
c---------------------------------------------------------------
      call sourcewl(dt,maxf,pulsedelay,sourcetype,sumsource,
     1     source,verbose,nt)


c     CLEAR ARRAYS
      do ix=1,nx+buffer
         do iz=1,nz+buffer
            tauxx(ix,iz)=0
            tauzz(ix,iz)=0
            tauxz(ix,iz)=0
            ut(ix,iz)=0
            wt(ix,iz)=0
         enddo
      enddo	


c---------------------------------------------------------------
c     CHECK ARRAYS
c---------------------------------------------------------------
      call checkarray(bignx,bignz,dx,dt,nx,nz,nt,buffer,
     1     l,l2mu,mu,denu,denw,geodepth,freeupper,nzfreeupper,
     2     dampingwidth,xs,zs,autopad,padleft,padright,padtop,padbot,
     3     verbose)

      
c---------------------------------------------------------------
c     OPEN FILE HANDLES
c---------------------------------------------------------------
      call mpm_filehandles(restoreautosave,
     1     bignx,bignz,nx,nz,buffer,
     2     geotype,xyskip,traceskip,tskip,geou,geow,verbose,
     3     usnapflag, wsnapflag,prsnapflag, divsnapflag, 
     4     rotsnapflag, snapsize, beginsnap, dsnap,ixgeo,
     5     izgeo,nrec)

      
c---------------------------------------------------------------
c     START MODELING
c---------------------------------------------------------------

      it1=1 
      if (restoreautosave.eq.1) then     
         call restorestate(it1,nx,nz,buffer,ut,wt,
     1        tauxx,tauzz,tauxz)
         if (verbose.gt.0) then
            PRINT*, 'Restoring from autosave files.'
            PRINT*, '- Starting from it=',it,it1
            WRITE(5,*) 'Restoring from autosave files.'
            WRITE(5,*) '- Starting from it=',it,it1
         end if
      end if




      DO it=it1,nt

         if (verbose.gt.2)  print*, '-------- START OF it=',it,nt

c     SAVE STATE IF REQUIRED
         if ((real(it)/dautosave).eq.(it/dautosave)) then
            if (verbose.gt.0) then
               PRINT*, ' Saving current STATE to disk, at it=',it
               WRITE(5,*) ' Saving current STATE to disk, at it=',it
            end if
            call savestate(it,nx,nz,buffer,ut,wt,tauxx,tauzz,tauxz)
         end if
         
         call setmpmgrid(dt,dx,nx,nz,buffer,bx1,bz1,bbx1,bbz1,
     1        wavex,wavez,mu,l,l2mu,denu,denw,ut,wt,
     2        tauxx,tauzz,tauxz,it,it1,verbose,xs,zs,bignx,bignz,style,
     3        autopad)

         if (verbose.gt.-1) then
            if ((real(it)/100).eq.(real(it/100))) PRINT*, 
     1           ' MPM it=',it  
         end if

c     VELOCITY UPDATE 4th order
         call vel4(bx1,bz1,c1,c2,dt,dx,nx,nz,ut,wt,
     1        denu,denw,tauxx,tauxz,tauzz,freeupper)

c     CLAYTON/ENQVIST
         call clayeng(bx1,bz1,c1,c2,dt,dx,nx,nz,ut,wt,
     1        denu,denw,l,mu,l2mu,tauxx,tauxz,tauzz,freeupper)

c     VELOCITY UPDATE 2nd order
         call vel2(bx1,bz1,dt,dx,nx,nz,ut,wt,
     1        denu,denw,tauxx,tauxz,tauzz,freeupper)

         if (verbose.gt.4) then 
            print*, ut(xs,zs),wt(xs,zs),tauxx(xs,zs),
     1           tauzz(xs,zs),tauxz(xs,zs)
         end if

c     ADD SOURCE
         call addsource(dx,nx,nz,buffer,bx1,bz1,bbx1,bbz1,rotation,
     1        denu,denw,ut,wt,tauxx,tauzz,tauxz,
     2        wavex,wavez,dt,xs,zs,source,it,verbose)
         
c     c ATTENUTATE - CERJAN, FRESNEL
         if (it.gt.1100) edgefactord=0.97
         if (absmode.eq.1) then
            call abs_cerjan(bx1,bz1,dx,nx,nz,ut,wt,tauxx,tauxz,tauzz,
     1           freeupper,edgefactord,dampingwidth, dampingexponent, 
     2           dampingtype)
         else if (absmode.eq.2) then
            call abs_fresnel_wide(bx1,bz1,it,verbose,dx,nx,nz,ut,wt,
     1           tauxx,tauzz,tauxz,vdamp,maxfdamp,expbase,edgefactorf
     $           ,dampf)
         else if (absmode.eq.3) then
            call abs_fresnel_narrow(bx1,bz1,it,verbose,dx,nx,nz,ut,wt,
     1           tauxx,tauzz,tauxz,vdamp,maxfdamp,expbase,edgefactorf
     $           ,dampf)
         end if
         

c     UPDATE STRESSES 4th order
         call  tau4(bx1,bz1,c1,c2,dt,dx,nx,nz,ut,wt,
     1        tauxx,tauxz,tauzz,l,mu,l2mu)

c     UPDATE STRESSES 2nd order
         call  tau2(bx1,bz1,c1,c2,dt,dx,nx,nz,ut,wt,
     1        tauxx,tauxz,tauzz,l,mu,l2mu)

         if (verbose.gt.4) then 
            print*, ut(xs,zs),wt(xs,zs),tauxx(xs,zs),
     1           tauzz(xs,zs),tauxz(xs,zs)
         end if


         call add_freesurface(freeupper,wavez,nzfreeupper,nx,bx1,bz1,
     1        bbz1,dampingwidth,tauxx,tauzz,tauxz,it)

         
c     DISK
c     17.05.02 prsnapflag	
         call mpm_io(bbx1,bbz1,bx1,bz1,dx,bignx,bignz,nx,nz,
     1        buffer,ut,wt,wavex,wavez,snapsize,     
     2        usnapflag, wsnapflag, prsnapflag,divsnapflag, 
     3        rotsnapflag, beginsnap,dsnap,xyskip,traceskip,geotype,
     4        geodepth,tskip, verbose,geou,geow,ixgeo,izgeo,nrec,it,
     5        dampingwidth,tauxx,tauzz,l2mu,denu,isnap,
     6        padleft,padtop)

         
         if (verbose.gt.2)  print*, '-------- END OF it=',it
         
      ENDDO

      if (verbose.gt.0)  print*, '-------- END OF MODELING'
      
c      write(5,*)' - MODELING END'
      

c---------------------------------------------------------------
c     CLOSE FILE HANDLES
c---------------------------------------------------------------
      if (verbose.gt.0)  print*, '-------- CLOSING FILE HANDLES'
      close(5)
      close(10)
      close(11)
      close(12)
      close(13)
      close(20)
      close(21)
      close(22)
      close(23)

c---------------------------------------------------------------
c     TRANSPOSE SEISMIC DATA
c---------------------------------------------------------------
      if (verbose.gt.0)  print*, '-------- TRANSPOSING SEISMIC DATA'
      if (geotype.ne.2) then
c         call transp('geou',nt,nrec/traceskip,4)
c         call transp('geow',nt,nrec/traceskip,4)
      else if (geotype.ne.1) then
c         call transp('geodiv',nt,nrec/traceskip,6)
c         call transp('georot',nt,nrec/traceskip,6)
      end if


      if (verbose.gt.0)  print*, '-------- END OF MPM :)'

      STOP
      END 
      





