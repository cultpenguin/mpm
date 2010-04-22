      subroutine mpm_filehandles(restoreautosave,bignx,bignz,nx,nz,
     1buffer,geotype,xyskip,traceskip,tskip,geou,geow,verbose,
     2usnapflag,wsnapflag,prsnapflag,divsnapflag,rotsnapflag,
     3snapsize, beginsnap, dsnap,ixgeo,izgeo,nrec)
c
c*******************************************************
c       MPM_FILEHANDLES :
c       UPDATE HCS 05/02/01
c*******************************************************

      implicit none

      include 'mpm.inc'

c---------------------------------------------------------------
c     GLOBAL VARIABLES FROM MAIN PROGRAM
c---------------------------------------------------------------
c     MODEL
      INTEGER bignx, bignz,nx,nz,buffer
c     IO
      INTEGER usnapflag, wsnapflag, divsnapflag, rotsnapflag
      INTEGER snapsize, prsnapflag
      INTEGER beginsnap, dsnap
      INTEGER xyskip
      INTEGER traceskip
      INTEGER tskip
      INTEGER geotype
      INTEGER nrec
      REAL geou(nreceivers),geow(nreceivers)
      REAL ixgeo(nreceivers), izgeo(nreceivers)
c     AUTOSAVE
      INTEGER restoreautosave
      INTEGER verbose
      
c---------------------------------------------------------------
c     LOCAL VARIABLES
c---------------------------------------------------------------
c     COUNTER
      INTEGER it1
      INTEGER ix,it
      INTEGER xmax
c     INTEGER zmax
      INTEGER tmax
      INTEGER n
c---------------------------------------------------------------
c OPEN FILE HANDLES
c---------------------------------------------------------------
      if (restoreautosave.eq.1) then
c     GET TIME OF LAST SAVED STATE
         open(36,file='time.autosave')
         rewind(36)
         read(36,*) it1
         close(36)
         xmax=(bignx/xyskip)
         n=(nrec/traceskip)
         tmax=(it1-tskip)/(tskip)
         it1=it1-1
         
c     GEOPHONE DATA :
         if ((geotype.eq.1).OR.(geotype.eq.3)) then
            open(10,file='geou.f77',form='unformatted')
            open(11,file='geow.f77',form='unformatted')
            rewind(10)
            rewind(11)
            do it=1,tmax
               read(10) (geou(ix),ix=1,n)
               read(11) (geow(ix),ix=1,n)
            enddo
         end if
         if ((geotype.eq.2).OR.(geotype.eq.3)) then
            open(12,file='geodiv.f77',form='unformatted')
            open(13,file='georot.f77',form='unformatted')
            rewind(12)
            rewind(13)
            do it=1,tmax
               read(12) (geou(ix),ix=1,n)
               read(13) (geow(ix),ix=1,n)
            enddo
         end if
c     UPDATE SNAPSHOTS
c     NOT IMPLEMENTED YET
c     When running restore state ut,wt,div and rot snap files are deleted and
c     the new snapfiles start from the current timestep.
c     If the previous timesteps are need the files need to be renamed
c     before running restore state and can then be appended to the new 
c     snapfiles
      else
c     OPEN FILE HANDLES FOR WRITING
         
         if ((geotype.eq.1).OR.(geotype.eq.3)) then
            open(10,file='geou.f77')
            open(11,file='geow.f77')
            close(10,status='delete')
            close(11,status='delete')
            open(10,file='geou.f77',form='unformatted')
            open(11,file='geow.f77',form='unformatted')
         end if
         if ((geotype.eq.2).OR.(geotype.eq.3)) then
            open(12,file='geodiv.f77')
            open(13,file='georot.f77')
            close(12,status='delete')
            close(13,status='delete')
            open(12,file='geodiv.f77',form='unformatted')
            open(13,file='georot.f77',form='unformatted')
         end if
      end if
      
      if (usnapflag.eq.1) then
         open(20,file='ut.snap')
         close(20,status='delete')
         if (verbose.gt.10) print*,'buffer',buffer
         if (snapsize.eq.1) then
            open(20,file='ut.snap',
     1           access='direct',recl=ibyte*int(nz/xyskip))
         else if (snapsize.eq.2) then
            open(20,file='ut.snap',
     1           access='direct',recl=ibyte*int((nz+2*buffer)/xyskip))
         else if (snapsize.eq.3) then
            open(20,file='ut.snap',
     1           access='direct',recl=ibyte*int(bignz/xyskip))
         end if
      end if
      if (wsnapflag.eq.1) then
         open(21,file='wt.snap')
         close(21,status='delete')
         if (snapsize.eq.1) then
            open(21,file='wt.snap',
     1           access='direct',recl=ibyte*int(nz/xyskip))
         else if (snapsize.eq.2) then
            open(21,file='wt.snap',
     1           access='direct',recl=ibyte*int((nz+2*buffer)/xyskip))
         else if (snapsize.eq.3) then
            open(21,file='wt.snap',
     1           access='direct',recl=ibyte*int(bignz/xyskip))
         end if
      end if
      if (prsnapflag.eq.1) then
         open(24,file='prt.snap')
         close(24,status='delete')
         if (snapsize.eq.1) then
            open(24,file='prt.snap',
     1           access='direct',recl=ibyte*int(nz/xyskip))
         else if (snapsize.eq.2) then
            open(24,file='prt.snap',
     1           access='direct',recl=ibyte*int((nz+2*buffer)/xyskip))
         else if (snapsize.eq.3) then
            open(24,file='prt.snap',
     1           access='direct',recl=ibyte*int(bignz/xyskip))
         end if
      end if
      if (divsnapflag.eq.1) then
         open(22,file='div.snap')
         close(22,status='delete')
         if (snapsize.eq.1) then
            open(22,file='div.snap',
     1           access='direct',recl=ibyte*int(nz/xyskip))
         else if (snapsize.eq.2) then
            open(22,file='div.snap',
     1           access='direct',recl=ibyte*int((nz+2*buffer)/xyskip))
         else if (snapsize.eq.3) then
            open(22,file='div.snap',
     1           access='direct',recl=ibyte*int(bignz/xyskip))
         end if
      end if
      if (rotsnapflag.eq.1) then
         open(23,file='rot.snap')
         close(23,status='delete')
         if (snapsize.eq.1) then
            open(23,file='rot.snap',
     1           access='direct',recl=ibyte*int(nz/xyskip))
         else if (snapsize.eq.2) then
            open(23,file='rot.snap',
     1           access='direct',recl=ibyte*int((nz+2*buffer)/xyskip))
         else if (snapsize.eq.3) then
            open(23,file='rot.snap',
     1           access='direct',recl=ibyte*int(bignz/xyskip))
         end if
      end if
      
      open(5,file='progress')
      rewind(5)
      
      return
      end
