       subroutine abs_fresnel_narrow(bx1,bz1,it,verbose,dx,nx,nz,ut,wt,
     1    tauxx,tauzz,tauxz,vdamp,maxfdamp,expbase,edgefactorf,dampf)
c******************************************************************
c
c Fresnel zone based damping
c - In a narrow model, i.e. left and right boundary are damped
c
c Thomas Mejer Hansen 05/2000
c
c******************************************************************
	implicit none
	include 'mpm.inc'

c---------------------------------------------------------------
c       GLOBAL VARIABLES
c---------------------------------------------------------------
c     MODEL
        REAL dx
        INTEGER bx1,bz1
c     MOVING BOX
        INTEGER nx,nz
        REAL ut(nxmax,nzmax), wt(nxmax,nzmax)
        REAL tauxx(nxmax,nzmax), tauzz(nxmax,nzmax)
        REAL tauxz(nxmax,nzmax)
c     BOUNDARIES
        REAL edgefactorf, vdamp, maxfdamp, expbase
	REAL dampf(nxmax)
c     IO
        INTEGER verbose
c     COUNTER
        INTEGER it

c---------------------------------------------------------------
c       LOCAL VARIABLES
c---------------------------------------------------------------
	INTEGER iix,iz,ix
        REAL bvalue        
	REAL kappa
        INTEGER nxhalf

        if (it.eq.1) then
c---------------------------------------------------------------
c       SETUP ABS BORDER
c---------------------------------------------------------------
c     SETUP DAMPING ZONE
           kappa=(.606*dx*vdamp)/(2*maxfdamp)
           do ix=1,nx
              dampf(ix)=expbase**(kappa/((ix*dx)**2))
           enddo
c     MAKE LINEAR GRADIENT TO EDGEFACTORFTOR, IF DEFINED
           if (edgefactorf.ne.0) then
              bvalue=-9999
              ix=0
              do while (bvalue.lt.edgefactorf) 
                 ix=ix+1
                 bvalue=(dampf(ix)-dampf(ix+1))*(ix-1)+dampf(ix)
                 if (bvalue.gt.edgefactorf) then
                    ix=ix-1
                    do iix=1,ix
                       dampf(iix)=(dampf(ix)-
     1                      dampf(ix+1))*(ix-iix)+dampf(ix)
                    enddo
                 end if
              enddo

              nxhalf=int(nx/2)
              do ix=1,nxhalf
                 dampf(nx-ix+1)=dampf(ix)
              enddo

              if (verbose.gt.2) then 
                 PRINT*, ' FRESNEL WIDE ANGLE DAMPING'
                 PRINT*, ' -Writing Damping profile to damping_x.out'
              end if
              open(1,file='damping_x.asc')    
              do ix=1,nx
                 write(1,*) dampf(ix)
              enddo
              close(1)
           end if
        end if
        
c---------------------------------------------------------------
c       APPLY DAMPING ONLY EVERYWHERE IN THE GRID
c---------------------------------------------------------------

c
c ATT: ACTUALLY ONE SHOULD ONLY LOOP OVER THE REGION WHERE THE 
c     THE GRID IS DEFINED (nx-1,nz-1) for Wt for example
c

        do iz=(1+bz1),(nz+bz1)
           do ix=(1+bx1),(nx+bx1)
c              ut(ix,iz)=ut(ix,iz)*dampf(ix)
c              wt(ix,iz)=wt(ix,iz)*dampf(ix)
c              tauxx(ix,iz)=tauxx(ix,iz)*dampf(ix)
c              tauzz(ix,iz)=tauzz(ix,iz)*dampf(ix)
c              tauxz(ix,iz)=tauxz(ix,iz)*dampf(ix)
              ut(ix,iz)=ut(ix,iz)*dampf(ix-bx1)
              wt(ix,iz)=wt(ix,iz)*dampf(ix-bx1)
              tauxx(ix,iz)=tauxx(ix,iz)*dampf(ix-bx1)
              tauzz(ix,iz)=tauzz(ix,iz)*dampf(ix-bx1)
              tauxz(ix,iz)=tauxz(ix,iz)*dampf(ix-bx1)
           enddo
        enddo
	return
	end
      

