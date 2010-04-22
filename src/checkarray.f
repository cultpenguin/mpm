      subroutine checkarray(bignx,bignz,dx,dt,nx,nz,nt,buffer,
     1l,l2mu,mu,denu,denw,geodepth,freeupper,nzfreeupper,
     2dampingwidth,xs,zs,autopad,padleft,padright,padtop,padbot,
     3verbose)

      implicit none
      include 'mpm.inc'       

c     MODEL     
      REAL dx
      INTEGER bignx, bignz
      INTEGER autopad
      INTEGER padleft,padright,padbot,padtop

c     MOVING BOX
      INTEGER nx,nz
      INTEGER buffer
      REAL mu(nxmax,nzmax)
      REAL l(nxmax,nzmax), l2mu(nxmax,nzmax) 
      REAL denu(nxmax,nzmax), denw(nxmax,nzmax)
c     TIME SAMPLING
      INTEGER nt
      REAL dt
c     IO
      INTEGER geodepth
c     BOUNDARIES
      INTEGER nzfreeupper
      INTEGER freeupper,dampingwidth
c     SOURCE
      INTEGER xs,zs
      REAL maxf
      INTEGER pulsedelay
      INTEGER verbose

      if (verbose.gt.0) PRINT*, '-- CHECK ARRAY START'
c --------------------------------------------------------
c     CHECK MOVING GRID SIZE
c 
      if ((nx+buffer).gt.(bignx)) then
         PRINT*, ''
         PRINT*, '-- WARNING -------------------------------'
         PRINT*, ' nx+buffer must be less than the bignx'
         PRINT*, ' nx+buffer=',(nx+buffer),', bignx=',bignx
         PRINT*, ''
         nx=bignx-buffer
         PRINT*, ' Setting nx=bignx-buffer=',nx
         PRINT*, '------------------------------------------'
         PRINT*, ''
c         WRITE(5,*) ' NX CHANGED TO :',nx
      end if
      if ((nz+buffer).gt.(bignz)) then
         PRINT*, ''
         PRINT*, '-- WARNING -------------------------------'
         PRINT*, ' nz+buffer must be less than the bignz'
         PRINT*, ' nz+buffer=',(nz+buffer),', bignz=',bignz
         PRINT*, ''
         nz=bignz-buffer
         PRINT*, ' Setting nz=bignz-buffer=',nz
         PRINT*, '------------------------------------------'
         PRINT*, ''
c         WRITE(5,*) ' NZ CHANGED TO :',nz
      end if
c --------------------------------------------------------


c --------------------------------------------------------
c     CHECK MOVING GRID SIZE TO BE LESS THAN IN MPM.INC
c 
      if ((nx+buffer).gt.(nxmax)) then
         PRINT*, ''
         PRINT*, '-- FATAL ERROR----------------------------'
         PRINT*, ' nx+buffer must be larger than nxmax'
         PRINT*, ' please update MPM.INC and RECOMPILE'
         PRINT*, '-- FATAL ERROR----------------------------'         
         PRINT*, ''
         STOP
      end if
      if ((nz+buffer).gt.(nzmax)) then
         PRINT*, ''
         PRINT*, '-- FATAL ERROR----------------------------'
         PRINT*, ' nx+buffer must be larger than nxmax'
         PRINT*, ' please update MPM.INC and RECOMPILE'
         PRINT*, '-- FATAL ERROR----------------------------'
         PRINT*, ''
         STOP
      end if
c --------------------------------------------------------





c --------------------------------------------------------
c     CHECK GEOPHONE DEPTH
c 
      if ((geodepth.le.(nzfreeupper)).AND.(freeupper.eq.1)) then
         PRINT*, ''
         PRINT*, '-- WARNING -------------------------------'
         PRINT*, ' Geophones has been placed within '
         PRINT*, ' the zone of the free surface'
         PRINT*, ''
c         geodepth=nzfreeupper+1
c         PRINT*, ' Geophones MUST be placed below the free'
c         PRINT*, ' surface. Geodepth is changed to ',geodepth
c         PRINT*, '------------------------------------------'
c         PRINT*, ''
c         WRITE(5,*) ' GEODEPTH CHANGED TO :',geodepth
      end if
c --------------------------------------------------------

c --------------------------------------------------------
c     CHECK SOURCE POSITION
c 
c     TMH : I
      if ((zs.lt.padtop).AND.(freeupper.eq.1)) then
         PRINT*, ''
         PRINT*, '-- WARNING -------------------------------'
         PRINT*, ' THE SOURCE has been placed within '
         PRINT*, ' the zone of the free surface'
         PRINT*, ''
c         PRINT*, ' It MUST be placed below the free'
c         PRINT*, ' surface. ZS should be changed to ',zs
         PRINT*, '------------------------------------------'
         PRINT*, ''
c         zs=4
c         WRITE(5,*) ' SOURCE DEPTH CHANGED TO :',geodepth
      end if
c --------------------------------------------------------

      if (verbose.gt.0) PRINT*, '-- CHECK ARRAY END'

      return 
      end

