      subroutine mpm_pad_model(autopad,verbose,
     1     bignx,bignz,bignx_disk,bignz_disk,
     2     padleft,padright,padbot,padtop,
     3     dampingwidth,freeupper,nzfreeupper)

c*******************************************************
c     MPM_PAD_MODELFILEHANDLES :
c     TMH 29/07/01
c*******************************************************

      implicit none

      include 'mpm.inc'

c---------------------------------------------------------------
c     GLOBAL VARIABLES FROM MAIN PROGRAM
c---------------------------------------------------------------
c     MODEL
      INTEGER autopad
      INTEGER bignx_disk, bignz_disk
      INTEGER bignx, bignz
      INTEGER padleft,padright,padbot,padtop
c     BOUNDARIES
      INTEGER freeupper
      INTEGER dampingwidth
      INTEGER nzfreeupper
c     VERBOSE
      INTEGER verbose
c---------------------------------------------------------------
c     LOCAL VARIABLES
c---------------------------------------------------------------
      CHARACTER fl*40, fl2mu*40, fmu*40
      CHARACTER fdenu*40, fdenw*40
      CHARACTER fl_pad*40, fl2mu_pad*40, fmu_pad*40
      CHARACTER fdenu_pad*40, fdenw_pad*40
      INTEGER i,j,iz,ix,ix_pad,iz_pad
      REAL arrayz1(maxbignz),arrayz_pad1(maxbignz)
      REAL arrayz2(maxbignz),arrayz_pad2(maxbignz)
      REAL arrayz3(maxbignz),arrayz_pad3(maxbignz)
      REAL arrayz4(maxbignz),arrayz_pad4(maxbignz)
      REAL arrayz5(maxbignz),arrayz_pad5(maxbignz)
c---------------------------------------------------------------
c     OPEN FILE HANDLES
c---------------------------------------------------------------
      if (verbose.gt.0) PRINT*, '-- MPM_PAD_MODEL START'
      
c     ORIGINAL MODELS
      fl='l.mod'
      fmu='mu.mod'
      fl2mu='l2mu.mod'
      fdenu='denu.mod'
      fdenw='denw.mod'


c     PADDED MODELS
      fl_pad='l_pad.mod'
      fmu_pad='mu_pad.mod'
      fl2mu_pad='l2mu_pad.mod'
      fdenu_pad='denu_pad.mod'
      fdenw_pad='denw_pad.mod'

c---------------------------------------------------------------
c     FIND OUT HOW MUCH TO PAD 
c---------------------------------------------------------------

      padleft=dampingwidth
      padright=dampingwidth
      padbot=dampingwidth

      if (freeupper.eq.1) then
c        if you do not want to pad the free 
         padtop=dampingwidth+nzfreeupper
      else
         padtop=dampingwidth
      end if
      bignx=bignx_disk+padleft+padright
      bignz=bignz_disk+padbot+padtop

      if (verbose.gt.0) PRINT*, '--- padleft =',padleft
      if (verbose.gt.0) PRINT*, '--- padright=',padright
      if (verbose.gt.0) PRINT*, '--- padtop  =',padtop
      if (verbose.gt.0) PRINT*, '--- padbot  =',padbot

      if (verbose.gt.0) PRINT*, '--- bignx_disk,bignz_disk=',
     1     bignx_disk,bignz_disk
      if (verbose.gt.0) PRINT*, '--- bignx,bignz=',bignx,bignz      

c     MOVE 

c---------------------------------------------------------------
c     OPEN THE FILES
c---------------------------------------------------------------
      open(31,file=fl,    access='direct',recl=ibyte*bignz_disk)
      open(32,file=fmu,   access='direct',recl=ibyte*bignz_disk)
      open(33,file=fl2mu, access='direct',recl=ibyte*bignz_disk)
      open(34,file=fdenu, access='direct',recl=ibyte*bignz_disk)
      open(35,file=fdenw, access='direct',recl=ibyte*bignz_disk)
      open(41,file=fl_pad,    access='direct',recl=ibyte*bignz)
      open(42,file=fmu_pad,   access='direct',recl=ibyte*bignz)
      open(43,file=fl2mu_pad, access='direct',recl=ibyte*bignz)
      open(44,file=fdenu_pad, access='direct',recl=ibyte*bignz)
      open(45,file=fdenw_pad, access='direct',recl=ibyte*bignz)

c---------------------------------------------------------------
c     DO THE PADDING
c---------------------------------------------------------------


      
c     READ THE FIRST COLUMN TO THE LEFT
      read(31,rec=1) (arrayz1(iz) , iz=1 ,bignz_disk)
      read(32,rec=1) (arrayz2(iz) , iz=1 ,bignz_disk)
      read(33,rec=1) (arrayz3(iz) , iz=1 ,bignz_disk)
      read(34,rec=1) (arrayz4(iz) , iz=1 ,bignz_disk)
      read(35,rec=1) (arrayz5(iz) , iz=1 ,bignz_disk)

      call pad_array(arrayz1,arrayz_pad1,padtop,padbot,bignz,bignz_disk)
      call pad_array(arrayz2,arrayz_pad2,padtop,padbot,bignz,bignz_disk)
      call pad_array(arrayz3,arrayz_pad3,padtop,padbot,bignz,bignz_disk)
      call pad_array(arrayz4,arrayz_pad4,padtop,padbot,bignz,bignz_disk)
      call pad_array(arrayz5,arrayz_pad5,padtop,padbot,bignz,bignz_disk)
      do ix=1,padleft+1,1
         ix_pad=ix
         write(41,rec=ix_pad) (arrayz_pad1(iz), iz=1,bignz)
         write(42,rec=ix_pad) (arrayz_pad2(iz), iz=1,bignz)
         write(43,rec=ix_pad) (arrayz_pad3(iz), iz=1,bignz)
         write(44,rec=ix_pad) (arrayz_pad4(iz), iz=1,bignz)
         write(45,rec=ix_pad) (arrayz_pad5(iz), iz=1,bignz)
      enddo


c     READ THE REST OF THE MODEL ON DISK AND PAD TOP AND BOTTOM
      do ix=2,bignx_disk,1
         read(31,rec=ix) (arrayz1(iz) , iz=1 ,bignz_disk)
         read(32,rec=ix) (arrayz2(iz) , iz=1 ,bignz_disk)
         read(33,rec=ix) (arrayz3(iz) , iz=1 ,bignz_disk)
         read(34,rec=ix) (arrayz4(iz) , iz=1 ,bignz_disk)
         read(35,rec=ix) (arrayz5(iz) , iz=1 ,bignz_disk)
         call pad_array(arrayz1,arrayz_pad1,padtop,padbot,bignz
     $        ,bignz_disk)
         call pad_array(arrayz2,arrayz_pad2,padtop,padbot,bignz
     $        ,bignz_disk)
         call pad_array(arrayz3,arrayz_pad3,padtop,padbot,bignz
     $        ,bignz_disk)
         call pad_array(arrayz4,arrayz_pad4,padtop,padbot,bignz
     $        ,bignz_disk)
         call pad_array(arrayz5,arrayz_pad5,padtop,padbot,bignz
     $        ,bignz_disk)
         
         ix_pad=ix+padleft
         write(41,rec=ix_pad) (arrayz_pad1(iz), iz=1,bignz)
         write(42,rec=ix_pad) (arrayz_pad2(iz), iz=1,bignz)
         write(43,rec=ix_pad) (arrayz_pad3(iz), iz=1,bignz)
         write(44,rec=ix_pad) (arrayz_pad4(iz), iz=1,bignz)        
         write(45,rec=ix_pad) (arrayz_pad5(iz), iz=1,bignz)
      enddo

c     Padding to the right
      do ix=1,padright,1
         ix_pad=ix+padleft+bignx_disk
         write(41,rec=ix_pad) (arrayz_pad1(iz), iz=1,bignz)
         write(42,rec=ix_pad) (arrayz_pad2(iz), iz=1,bignz)
         write(43,rec=ix_pad) (arrayz_pad3(iz), iz=1,bignz)
         write(44,rec=ix_pad) (arrayz_pad4(iz), iz=1,bignz)
         write(45,rec=ix_pad) (arrayz_pad5(iz), iz=1,bignz)
      enddo

      close(31)
      close(32)
      close(33)
      close(34)
      close(35)
      close(41)
      close(42)
      close(43)
      close(44)
      close(45)
      
      if (verbose.gt.0) PRINT*, '-- MPM_PAD_MODEL END'

      
      return
      end


      subroutine pad_array(arrayz,arrayz_pad,padtop,padbot,
     1bignz,bignz_disk)
c*******************************************************
c       MPM_PAD_MODELFILEHANDLES :
c       TMH 29/07/01
c*******************************************************
      implicit none
      include 'mpm.inc'

      INTEGER bignz,bignz_disk
      INTEGER padbot,padtop
      REAL arrayz(maxbignz),arrayz_pad(maxbignz)

      INTEGER iz,iz_array

c     PAD TOP
      do iz=1,padtop,1
c         print*, 'PAD TOP iz,iz_array=',iz,iz
         arrayz_pad(iz)=arrayz(1)
      enddo

c     MOVE VALUES
      do iz=1,bignz,1
c         print*, 'MOVING iz=',iz,iz+padtop
         arrayz_pad(iz+padtop)=arrayz(iz)
      enddo

c     PAD BOTTOM
      do iz=1,padbot
c         print*, 'BOT iz=',iz,iz+padtop+bignz_disk
         arrayz_pad(iz+padtop+bignz_disk)=arrayz(bignz_disk)
      enddo


      return
      end


