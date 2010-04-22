      subroutine gethzmodel(x1,z1,nx,nz,bignx,bignz,buffer,
     1     mu,l,l2mu,denu,denw,ut,wt,tauxx,tauzz,tauxz,dx,dt,
     2     autopad,verbose)

c*******************************************************
c     GETHZMODEL :
c     READS IN A SPECIFIC PART OF THE MODEL ON DISK
c     ... (difference between getmod and gethzmodel) ...
c*******************************************************

      implicit none	
      include 'mpm.inc'
c---------------------------------------------------------------
c     GLOBAL VARIABLES FROM MAIN PROGRAM
c---------------------------------------------------------------
c     MODEL
      REAL dx
      INTEGER bignx, bignz
      INTEGER autopad
c     MOVING BOX
      INTEGER nx,nz
      INTEGER buffer
      REAL mu(nxmax,nzmax)
      REAL l(nxmax,nzmax), l2mu(nxmax,nzmax) 
      REAL denu(nxmax,nzmax), denw(nxmax,nzmax)
      REAL ut(nxmax,nzmax), wt(nxmax,nzmax)
      REAL tauxx(nxmax,nzmax), tauzz(nxmax,nzmax)
      REAL tauxz(nxmax,nzmax)
c     TIME
      REAL dt
c     IO
      INTEGER verbose
c---------------------------------------------------------------
c     LOCAL VARIABLES 
c---------------------------------------------------------------
      INTEGER x1,z1
      INTEGER ix,iz,recix
      CHARACTER fl*40, fl2mu*40, fmu*40
      CHARACTER fdenu*40, fdenw*40
      REAL arrayz(maxbignz) 

      INTEGER SaveBoxModel
      SaveBoxModel=0
      
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
      
c     if (verbose.gt.5) then 
      
      if (verbose.gt.2) then 
         PRINT*, ''
         PRINT*, '------------------------------------'
         PRINT*, ' READING BUFFER FROM DISK'
         PRINT*, '  FROM (x1,z1)=',x1,z1
         PRINT*, '  buffer=',buffer
         PRINT*, ''
      end if
      
c     SET UP FILE HANDLES
      open(31,file=fl,    access='direct',recl=ibyte*bignz)
      open(32,file=fmu,   access='direct',recl=ibyte*bignz)
      open(33,file=fl2mu, access='direct',recl=ibyte*bignz)
      open(34,file=fdenu, access='direct',recl=ibyte*bignz)
      open(35,file=fdenw, access='direct',recl=ibyte*bignz)
      
c     READ DATA from x1:(x1+nx+buffer-1) 
      do ix=1,(nx+buffer)
         recix=ix+x1-1
         read(31,rec=recix) (arrayz(iz) , iz=1 ,bignz)
         do iz=1,(nz+buffer)
            l(ix,iz)=arrayz(iz+z1-1)
         enddo
         read(32,rec=recix) (arrayz(iz) , iz=1 ,bignz)
         do iz=1,(nz+buffer)
            mu(ix,iz)=arrayz(iz+z1-1)
         enddo
         read(33,rec=recix) (arrayz(iz) , iz=1 , bignz)
         do iz=1,(nz+buffer)
            l2mu(ix,iz)=arrayz(iz+z1-1)
         enddo
         read(34,rec=recix) (arrayz(iz) , iz=1 , bignz)
         do iz=1,(nz+buffer)
            denu(ix,iz)=arrayz(iz+z1-1)
         enddo
         read(35,rec=recix) (arrayz(iz) , iz=1 , bignz)
         do iz=1,(nz+buffer)
            denw(ix,iz)=arrayz(iz+z1-1)
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
      
c     CLOSE FILE HANDLES
      close(31)
      close(32)
      close(33)
      close(34)
      close(35)
      

      if (SaveBoxModel.eq.1) then 
         print*, '  CHECKING IF THE LOADED MODEL IS RIGHT'
         print*, '  BY SAVING THE GRID TO DISK *_box.mod'
         print*, '  nx+buffer,nz+buffer',(nx+buffer),(nz+buffer)
         open(31,file='l_box.mod', access='direct',recl=ibyte*(nz
     $        +buffer))
         open(32,file='mu_box.mod', access='direct',recl=ibyte*(nz
     $        +buffer))
         open(33,file='l2mu_box.mod', access='direct',recl=ibyte*(nz
     $        +buffer))
         open(34,file='denu_box.mod', access='direct',recl=ibyte*(nz
     $        +buffer))
         open(35,file='denw_box.mod', access='direct',recl=ibyte*(nz
     $        +buffer))
         do ix = 1,nx+buffer
            write(31,rec=ix)(l(ix,iz),iz=1,nz+buffer)
            write(32,rec=ix)(mu(ix,iz),iz=1,nz+buffer)
            write(33,rec=ix)(l2mu(ix,iz),iz=1,nz+buffer)
            write(34,rec=ix)(denu(ix,iz),iz=1,nz+buffer)
            write(35,rec=ix)(denw(ix,iz),iz=1,nz+buffer)
         enddo
         close(31)
         close(32)
         close(33)
         close(34)
         close(35)

      end if



      
      if (verbose.gt.2) then 
         PRINT*, ''
         PRINT*, ' END OF READING DISK FILES'
         PRINT*, '------------------------------------'
         PRINT*, ''
      end if
      return 
      end
