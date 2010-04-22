      subroutine mpm_io(bbx1,bbz1,bx1,bz1,dx,bignx,bignz,nx,nz,
     1buffer,ut,wt,wavex,wavez,snapsize, 
     2usnapflag,wsnapflag,prsnapflag,divsnapflag, 
     3rotsnapflag, beginsnap,dsnap,xyskip,traceskip,
     4geotype,geodepth, tskip,verbose,geou,geow,ixgeo,izgeo,
     5nrec,it,dampingwidth, tauxx,tauzz,l2mu,denu,isnap,
     6padleft,padtop)
        
c 17.05.02 implementing the pressure file prt.snap (2mu,denu,tauxx,tauzz,
c prsnapflag). 
c 17.05.02 implementintg moving window in big model
c TODO remember to check the pressure prt.snap and consider if it is
c the same as the divergence
c TODO What effect has the piping of matrices on the memory usage? (bigmodel) 
c       
c*******************************************************
c       MPM_IO : 
c*******************************************************
      implicit none   
      include 'mpm.inc'
c---------------------------------------------------------------
c     GLOBAL VARIABLES FROM MAIN PROGRAM
c---------------------------------------------------------------
c     MODEL
      REAL dx
      INTEGER bx1,bz1
      INTEGER bbx1,bbz1
      INTEGER bignx, bignz
      INTEGER padleft,padtop

c     MOVING BOX
      INTEGER nx,nz,buffer    
      INTEGER wavex(ntmax),wavez(ntmax)
      REAL ut(nxmax,nzmax), wt(nxmax,nzmax)
     1         ,tauxx(nxmax,nzmax), tauzz(nxmax,nzmax),
     2         l2mu(nxmax,nzmax), denu(nxmax,nzmax)
           
c     BOUNDARIES
      INTEGER dampingwidth

c     IO
      INTEGER usnapflag, wsnapflag, divsnapflag, rotsnapflag
      INTEGER snapsize, prsnapflag
      INTEGER beginsnap, dsnap
      INTEGER xyskip,traceskip
      INTEGER geotype
      INTEGER geodepth
      INTEGER tskip
      INTEGER verbose
      REAL geou(nreceivers),geow(nreceivers)
      REAL ixgeo(nreceivers),izgeo(nreceivers)
      INTEGER nrec,isnap
      INTEGER it
      REAL rotation, divergence
c---------------------------------------------------------------
c     LOCAL VARIABLES
c---------------------------------------------------------------
      INTEGER izfree
      INTEGER ix,iz
      INTEGER igeo
      INTEGER post
      REAL rit,a,b
      real pressure
      rit=real(it)

      izfree=0

c      PRINT*, 'bx1,bz1,bbx1,bbz1',bx1,bz1,bbx1,bbz1

c---------------------------------------------------------------
c       WRITE OUT (ut,wt) GEOPHONES
c---------------------------------------------------------------       
      if (geotype.ne.2) then
         if ((rit/tskip).eq.(abs(it/tskip))) then
c       INITIALIZE
            do igeo=1,nrec
               geou(igeo)=0
               geow(igeo)=0
            enddo
c       ASSIGN VALUES
            do igeo=1,nrec
               ix=ixgeo(igeo)-bbx1
               iz=izgeo(igeo)-bbz1+izfree
               if (( (ix.gt.0).AND.(ix.lt.(nx+buffer)) ).
     1              AND.( (iz.gt.0).AND.(iz.lt.(nz+buffer)) )) then  
                  geou(igeo)=ut(ix,iz+1)
                  geow(igeo)=wt(ix,iz)
               end if
            enddo
c     PRINT TO FILE
            write(10) (geou(igeo),igeo=traceskip,nrec,traceskip)
            write(11) (geow(igeo),igeo=traceskip,nrec,traceskip)
         end if
      end if
c---------------------------------------------------------------
c       WRITE OUT (div,rot) GEOPHONES
c---------------------------------------------------------------  
      if (geotype.ne.1) then
         if ((rit/tskip).eq.(abs(it/tskip))) then
c     INITIALIZE
            do igeo=1,nrec
               geou(igeo)=0
               geow(igeo)=0
            enddo
c     ASSIGN VALUES
c     DIV
            do igeo=1,nrec
               ix=ixgeo(igeo)-bbx1
               iz=izgeo(igeo)-bbz1+izfree
               if (( (ix.gt.0).AND.(ix.lt.(nx+buffer)) ).
     1              AND.( (iz.gt.0).AND.(iz.lt.(nz+buffer)) )) then  
                  a=ut(ix+1,iz+1)-ut(ix,iz+1)
                  b=wt(ix,iz+1)-wt(ix,iz)
                  geou(igeo)=(a+b)/dx
               end if
            enddo
c     ROT
            do igeo=1,nrec
               ix=ixgeo(igeo)-bbx1
               iz=izgeo(igeo)-bbz1+izfree
               if (( (ix.gt.0).AND.(ix.lt.(nx+buffer)) ).
     1              AND.( (iz.gt.0).AND.(iz.lt.(nz+buffer)) )) then  
                  a=ut(ix+1,iz+1)-ut(ix+1,iz)
                  b=wt(ix+1,iz)-wt(ix,iz)
                  geow(igeo)=(a-b)/dx
               end if
            enddo
c     PRINT TO FILE
            write(12) (geou(igeo),igeo=traceskip,nrec,traceskip)
            write(13) (geow(igeo),igeo=traceskip,nrec,traceskip)
         end if
      end if
c---------------------------------------------------------------
c       SNAPSHOTS
c---------------------------------------------------------------
      if (((rit/dsnap).eq.(abs(it/dsnap))).AND.
     1     (it.ge.beginsnap)) then
         if (verbose.gt.-1) PRINT*, ' Writing Snapshots, it=',it
c------------------------ ut ----------------------------------
         if ((usnapflag.eq.1).AND.(snapsize.eq.1)) then
            if (verbose.gt.3) PRINT*, ' Ut active-grid SNAPSHOT'
            do ix=bx1+xyskip,bx1+nx,xyskip
               post=((ix-bx1)+int(nx/xyskip)*xyskip*isnap)/xyskip
               write(20,rec=post) 
     1             (ut(ix,iz),iz=bz1+xyskip,bz1+nz,xyskip)
            enddo
         end if
         if ((usnapflag.eq.1).AND.(snapsize.eq.2)) then
            if (verbose.gt.3) PRINT*, ' Ut box-grid SNAPSHOT'
            do ix=(bx1-buffer)+xyskip,(bx1+buffer)+nx,xyskip
               post=((ix-(bx1-buffer))+int((nx+2*buffer)/
     1               xyskip)*xyskip*isnap)/xyskip
               write(20,rec=post) 
     1             (ut(ix,iz),iz=(bz1-buffer)+xyskip,
     2             (bz1+buffer)+nz,xyskip)
c            do iz = 1,nz+buffer,xyskip
c               write(20)(ut(ix,iz),ix=1,nx+buffer,xyskip)
c               print *,'two, not changed yet'
            enddo
         end if
         if ((usnapflag.eq.1).AND.(snapsize.eq.3)) then
            if (verbose.gt.3) PRINT*, ' Ut disk-grid SNAPSHOT'
            call bigmodel(20,bignx,bignz,nx,nz,dx,xyskip,isnap,it,
     1          ut,wt,tauxx,tauzz,l2mu,denu,wavex,wavez,1,bbx1,bbz1,
     2bx1,bz1,buffer)
         end if
c--------------------------wt ---------------------------------
         if ((wsnapflag.eq.1).AND.(snapsize.eq.1)) then
            if (verbose.gt.3) PRINT*, ' Wt active-grid SNAPSHOT'
            do ix=bx1+xyskip,bx1+nx,xyskip
               post=((ix-bx1)+int(nx/xyskip)*xyskip*isnap)/xyskip
               write(21,rec=post) 
     1             (wt(ix,iz),iz=bz1+xyskip,bz1+nz,xyskip)
            enddo
         end if
         if ((wsnapflag.eq.1).AND.(snapsize.eq.2)) then
            if (verbose.gt.3) PRINT*, ' Wt box-grid SNAPSHOT'
            do ix=(bx1-buffer)+xyskip,(bx1+buffer)+nx,xyskip
               post=((ix-(bx1-buffer))+int((nx+2*buffer)/
     1               xyskip)*xyskip*isnap)/xyskip
               write(21,rec=post) 
     1             (wt(ix,iz),iz=(bz1-buffer)+xyskip,
     2             (bz1+buffer)+nz,xyskip)
c            do iz = 1,nz+buffer,xyskip
c               write(21)(wt(ix,iz),ix=1,nx+buffer,xyskip)
c               print *,'two, not changed yet'
            enddo
         end if
         if ((wsnapflag.eq.1).AND.(snapsize.eq.3)) then
            if (verbose.gt.3) PRINT*, ' Wt disk-grid SNAPSHOT'
            call bigmodel(21,bignx,bignz,nx,nz,dx,xyskip,isnap,it,
     1          ut,wt,tauxx,tauzz,l2mu,denu,wavex,wavez,2,bbx1,bbz1,
     2bx1,bz1,buffer)
         end if
c------------------------ prt ----------------------------------
         if ((prsnapflag.eq.1).AND.(snapsize.eq.1)) then
            if (verbose.gt.3) PRINT*, ' prt active-grid SNAPSHOT'
            do ix=bx1+xyskip,bx1+nx,xyskip
               post=((ix-bx1)+int(nx/xyskip)*xyskip*isnap)/xyskip
               write(24,rec=post) 
     1             (pressure(ix,iz,tauxx,tauzz,l2mu,denu),
     2             iz=bz1+xyskip,bz1+nz,xyskip)
            enddo
         end if
         if ((prsnapflag.eq.1).AND.(snapsize.eq.2)) then
            if (verbose.gt.3) PRINT*, ' prt box-grid SNAPSHOT'
            do ix=(bx1-buffer)+xyskip,(bx1+buffer)+nx,xyskip
               post=((ix-(bx1-buffer))+int((nx+2*buffer)/
     1               xyskip)*xyskip*isnap)/xyskip
               write(24,rec=post)
     1             (pressure(ix,iz,tauxx,tauzz,l2mu,denu),
     2             iz=(bz1-buffer)+xyskip,(bz1+buffer)+nz,xyskip)
c            do iz = 1,nz+buffer,xyskip
c               write(24) ((((tauxx(ix,iz)+tauzz(ix,iz))*denu(ix,iz))/
c     1             (l2mu(ix,iz))),ix=1,nx+buffer,xyskip)
c               print *,'two, not changed yet'
            enddo
         end if
         if ((prsnapflag.eq.1).AND.(snapsize.eq.3)) then
            if (verbose.gt.3) PRINT*, ' prt disk-grid SNAPSHOT'
            call bigmodel(24,bignx, bignz,nx,nz,dx,xyskip,isnap,it,
     1          ut,wt,tauxx,tauzz,l2mu,denu,wavex,wavez,3,bbx1,bbz1,
     2bx1,bz1,buffer)
         end if
c     ----------------------- DIV ----------------------------------
         if (divsnapflag.eq.1) then
            if (verbose.gt.3) PRINT*, ' Divergence SNAPSHOT'
            if (snapsize.eq.1) then
               if (verbose.gt.3) PRINT*, ' DIV active-grid SNAPSHOT'
               do ix=bx1+xyskip,bx1+nx,xyskip
                  post=((ix-bx1)+int(nx/xyskip)*xyskip*isnap)/xyskip
                  write(22,rec=post) 
     1              (divergence(dx,ix,iz,ut,wt),
     2              iz=bz1+xyskip,bz1+nz,xyskip)
               enddo
            end if 
            if (snapsize.eq.2) then
               if (verbose.gt.3) PRINT*, ' DIV box-grid SNAPSHOT'
               do ix=(bx1-buffer)+xyskip,(bx1+buffer)+nx,xyskip
                  post=((ix-(bx1-buffer))+int((nx+2*buffer)/
     1                 xyskip)*xyskip*isnap)/xyskip
                  write(22,rec=post) 
     1                 (divergence(dx,ix,iz,ut,wt),
     2                 iz=(bz1-buffer)+xyskip,
     3                 (bz1+buffer)+nz,xyskip)
               enddo
            end if
            if (snapsize.eq.3) then
               if (verbose.gt.3) PRINT*, '  DIV disk-grid SNAPSHOT'
               call bigmodel(22,bignx, bignz,nx,nz,dx,xyskip,isnap,it,
     1             ut,wt,tauxx,tauzz,l2mu,denu,wavex,wavez,5,bbx1,bbz1,
     2bx1,bz1,buffer)
            end if
         end if

c     ----------------------- ROT ----------------------------------
         if (divsnapflag.eq.1) then
            if (verbose.gt.3) PRINT*, ' Rotation SNAPSHOT'
            if (snapsize.eq.1) then
               if (verbose.gt.3) PRINT*, ' ROT active-grid SNAPSHOT'
               do ix=bx1+xyskip,bx1+nx,xyskip
                  post=((ix-bx1)+int(nx/xyskip)*xyskip*isnap)/xyskip
                  write(23,rec=post) 
     1              (rotation(dx,ix,iz,ut,wt),
     2              iz=bz1+xyskip,bz1+nz,xyskip)
               enddo
            end if 
            if (snapsize.eq.2) then
               if (verbose.gt.3) PRINT*, ' ROT box-grid SNAPSHOT'
               do ix=(bx1-buffer)+xyskip,(bx1+buffer)+nx,xyskip
                  post=((ix-(bx1-buffer))+int((nx+2*buffer)/
     1                 xyskip)*xyskip*isnap)/xyskip
                  write(23,rec=post) 
     1                 (rotation(dx,ix,iz,ut,wt),
     2                 iz=(bz1-buffer)+xyskip,
     3                 (bz1+buffer)+nz,xyskip)
               enddo
            end if
            if (snapsize.eq.3) then
               if (verbose.gt.3) PRINT*, '  DIV disk-grid SNAPSHOT'
               call bigmodel(23,bignx, bignz,nx,nz,dx,xyskip,isnap,it,
     1             ut,wt,tauxx,tauzz,l2mu,denu,wavex,wavez,4,bbx1,bbz1,
     2bx1,bz1,buffer)
            end if
         end if


c----------------------------------------------------------------
         isnap=isnap+1
      end if
      return 
      end

C=========================================================================
      subroutine bigmodel2(file,bignx,bignz,nx,nz,dx,xyskip,isnap,it,
     1    ut,wt,tauxx,tauzz,l2mu,denu,wavex,wavez,type,bbx1,bbz1,
     2bx1,bz1,buffer)
      implicit none
      include 'mpm.inc'
c     ----- GLOBAL VARIABLES FROM MAIN PROGRAM 
      INTEGER wavex(ntmax),wavez(ntmax)
      REAL ut(nxmax,nzmax), wt(nxmax,nzmax),
     1    tauxx(nxmax,nzmax), tauzz(nxmax,nzmax),
     2    l2mu(nxmax,nzmax), denu(nxmax,nzmax)
      INTEGER bignx,bignz,nx,nz,xyskip,isnap,it,file,post
      INTEGER bx1,bz1,bbx1,bbz1
      INTEGER buffer
      real dx
c     ----  LOCAL VARIABLES 
      REAL t_tmp(bignz+10)
      INTEGER nx1,nz1,nx2,nz2,ix,iz
      INTEGER type
      REAL pressure,divergence,rotation

      nz1=(wavez(it))
      nx1=(wavex(it))
      nz2=(wavez(it)+nz)
      nx2=(wavex(it)+nx)

      PRINT*, 'bignx,bignz,nx1,nz1,nx2,nz2=',bignx,bignz,nx1,nz1,nx2,nz2

      do ix = xyskip, bignx,xyskip
         post=(ix+int(bignx/xyskip)*xyskip*isnap)/xyskip

c     WRITE OUT ZEROS AS LONG AS WE ARE LEFT OF THE MOVING BOX
         if ((ix.gt.0).and.(ix.le.(nx1))) then
            do iz= 1,bignz
               t_tmp(iz)=0.0
            enddo
            write (file,rec=post)
     1          (t_tmp(iz),iz=xyskip,bignz,xyskip)
         endif
c     WE ARE AT THE BUFFER GRID

         if ((ix.gt.nx1).and.(ix.le.(nx1+nx))) then
            do iz=1,bignz
c     PUT ZEROS ABOVE THE BUFFER GRID
               if ((iz.gt.0).and.(iz.le.(nz1))) then
                  t_tmp(iz)=0.0
               endif
c     WRITE OUT THE BUFFER
               if ((iz.gt.nz1).and.(iz.le.(nz1+nz))) then
                  if (type.eq.1) then
                     t_tmp(iz)=ut(ix-nx1,iz-nz1)
                  else if (type.eq.2) then
                     t_tmp(iz)=wt(ix-nx1,iz-nz1)
                  else if (type.eq.3) then
                     t_tmp(iz)=pressure(ix-nx1,iz-nz1,
     1                         tauxx,tauzz,l2mu,denu)
                  else if (type.eq.4) then
                     t_tmp(iz)=divergence(dx,ix-nx1,iz-nz1,ut,wt)
                  else if (type.eq.5) then
                     t_tmp(iz)=rotation(dx,ix-nx1,iz-nz1,ut,wt)
                  endif                      
               endif
c     PUT ZEROS BELOW THE BUFFER GRID
               if ((iz.gt.(nz1+nz)).and.(ix.le.bignz)) then
                  t_tmp(iz)=0.0
               endif
            enddo
            write(file,rec=post) 
     1          (t_tmp(iz),iz=xyskip,bignz,xyskip)
         endif
         if ((ix.gt.(nx1+nx)).and.(ix.le.bignx)) then
            do iz = 1,bignz
               t_tmp(iz)=0.0
            enddo
            write(file,rec=post) 
     1          (t_tmp(iz),iz=xyskip,bignz,xyskip)
         endif
      enddo
      close(14)
      return
      end

C===========================================================================
      real function pressure(im,in,tauxx,tauzz,l2mu,denu)
      implicit none
      include 'mpm.inc'
c     GLOBAL VARIABLES FROM MAIN PROGRAM
      real    tauxx(nxmax,nzmax), tauzz(nxmax,nzmax),
     1    l2mu(nxmax,nzmax), denu(nxmax,nzmax)
c       LOCAL VARIABLES
      integer im,in
      pressure=((tauxx(im,in)+tauzz(im,in))*denu(im,in))/(l2mu(im,in))
      return
      end

C===========================================================================
      real function divergence(dx,im,in,ut,wt)
      implicit none
      include 'mpm.inc'
c     GLOBAL VARIABLES FROM MAIN PROGRAM
      real    ut(nxmax,nzmax), wt(nxmax,nzmax)
      real dx
c     LOCAL VARIABLES
      integer im,in
      divergence=(ut(im+1,in+1)-ut(im,in+1)+(wt(im,in+1)-wt(im,in)))/dx
      return
      end

C===========================================================================
      real function rotation(dx,im,in,ut,wt)
      implicit none
      include 'mpm.inc'
c     GLOBAL VARIABLES FROM MAIN PROGRAM
      real    ut(nxmax,nzmax), wt(nxmax,nzmax)
      real dx
c     LOCAL VARIABLES
      integer im,in
      rotation=(ut(im+1,in+1)-ut(im+1,in)-(wt(im+1,in)-wt(im,in)))/dx
      return
      end
C===========================================================================





C=========================================================================
      subroutine bigmodel(file,bignx,bignz,nx,nz,dx,xyskip,isnap,it,
     1    ut,wt,tauxx,tauzz,l2mu,denu,wavex,wavez,type,bbx1,bbz1,
     2bx1,bz1,buffer)
      implicit none
      include 'mpm.inc'
c     ----- GLOBAL VARIABLES FROM MAIN PROGRAM 
      INTEGER wavex(ntmax),wavez(ntmax)
      INTEGER buffer
      REAL ut(nxmax,nzmax), wt(nxmax,nzmax),
     1    tauxx(nxmax,nzmax), tauzz(nxmax,nzmax),
     2    l2mu(nxmax,nzmax), denu(nxmax,nzmax)
      INTEGER bignx,bignz,nx,nz,xyskip,isnap,it,file,post
      INTEGER bx1,bz1,bbx1,bbz1
      real dx
c     ----  LOCAL VARIABLES 
      REAL t_tmp(bignz+10)
      INTEGER nx1,nz1,nx2,nz2,ix,iz
      INTEGER type
      INTEGER x_start,x_end,z_start,z_end
      INTEGER xbuf_start,xbuf_end,zbuf_start,zbuf_end
      INTEGER innerx1,innerz1
      INTEGER wborder
      REAL pressure,divergence,rotation

c     WIDTH OF BORDER OF MOVING BOX FOR SNAPSIZE=3
      wborder=5

      x_start=bbx1+bx1+1
      x_end=bbx1+bx1+nx
      z_start=bbz1+bz1+1
      z_end=bbz1+bz1+nz

      xbuf_start=bbx1+1
      xbuf_end=bbx1+nx+buffer
      zbuf_start=bbz1+1
      zbuf_end=bbz1+nz+buffer


      nz1=(wavez(it))
      nx1=(wavex(it))
      nz2=(wavez(it)+nz)
      nx2=(wavex(it)+nx)


      do ix = xyskip, bignx,xyskip
         post=(ix+int(bignx/xyskip)*xyskip*isnap)/xyskip

c     FIRST RESET THE COLUMN
         do iz= 1,bignz
            t_tmp(iz)=0.0
         enddo
         
c     WE ARE AT THE SMALL MOVING BOX
         
         if ((ix.ge.x_start).and.(ix.le.x_end)) then
            innerx1=ix-bbx1
            do iz=z_start,z_end
               innerz1=iz-bbz1
               if (type.eq.1) then
                  t_tmp(iz)=ut(innerx1,innerz1)
               else if (type.eq.2) then
                  t_tmp(iz)=wt(innerx1,innerz1)
               else if (type.eq.3) then
                  t_tmp(iz)=pressure(innerx1,innerz1,
     1                 tauxx,tauzz,l2mu,denu)
               else if (type.eq.4) then
                  t_tmp(iz)=divergence(dx,innerx1,innerz1,ut,wt)
               else if (type.eq.5) then
                  t_tmp(iz)=rotation(dx,innerx1,innerz1,ut,wt)
               endif           
            enddo
            
c     BORDERS AT TOP AND BOTTOM
            
            
            
c     APPLY BORDER AT SMALL MOVING GRID, TOP
            do iz=(z_start-1-wborder),(z_start-1)
               if (iz.gt.0) t_tmp(iz)=1.0
            enddo
c     APPLY BORDER AT SMALL MOVING GRID, BOT
            do iz=(z_end+1),(z_end+wborder)
               if (iz.le.bignz) t_tmp(iz)=1.0
            enddo
            
            
            
            
         end if
         
         if ((ix.ge.xbuf_start).AND.(ix.le.xbuf_end)) then
            
c     APPLY BORDER AT BUFFER GRID, TOP
            do iz=(zbuf_start-1-wborder),(zbuf_start-1)
               if (iz.gt.0) t_tmp(iz)=1.0
            enddo
c     APPLY BORDER AT BUFFER GRID, BOT
            do iz=(zbuf_end+1),(zbuf_end+wborder)
               if (iz.le.bignz) t_tmp(iz)=1.0
            enddo
         end if
         
         
c     BORDERS LEFT AND RIGHT

c     APPLY BORDER AT SMALL MOVING BOX, LEFT
         if (((x_start-ix).gt.0).AND.((x_start-ix).le.wborder)) then
            do iz=z_start,z_end
               t_tmp(iz)=1.0
            enddo
         end if

c     APPLY BORDER AT SMALL MOVING BOX, RIGHT
         if (((ix-x_end).gt.0).AND.((ix-x_end).le.wborder)) then
            do iz=z_start,z_end
               t_tmp(iz)=1.0
            enddo
         end if

c     APPLY BORDER AT BUFFER GRID, LEFT
         if (((xbuf_start-ix).gt.0).AND.((xbuf_start-ix).le.wborder)) 
     1then
            do iz=zbuf_start,zbuf_end
               t_tmp(iz)=1.0
            enddo
         end if
c     APPLY BORDER AT BUFFER GRID, RIGHT
         if (((ix-xbuf_end).gt.0).AND.((ix-xbuf_end).le.wborder)) then
            do iz=zbuf_start,zbuf_end
               t_tmp(iz)=1.0
            enddo
         end if
         

         write(file,rec=post) 
     1        (t_tmp(iz),iz=xyskip,bignz,xyskip)
      enddo
      close(14)
      return
      end


