       subroutine abs_fresnel_wide(bx1,bz1,it,verbose,dx,nx,nz,ut,wt,
     1    tauxx,tauzz,tauxz,vdamp,maxfdamp,expbase,edgefactorf,dampf)
c******************************************************************
c
c Fresnel zone based damping
c
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
	REAL dampf(nzmax)
c     IO
        INTEGER verbose
c     COUNTER
        INTEGER it

c---------------------------------------------------------------
c       LOCAL VARIABLES
c---------------------------------------------------------------
	INTEGER iiz,iz,ix
        REAL bvalue        
	REAL kappa

        if (it.eq.1) then
c---------------------------------------------------------------
c       SETUP ABS BORDER
c---------------------------------------------------------------
c     SETUP DAMPING ZONE
           print*, 'SETTING UP FRESNEL TYPE DAMPING'
           kappa=(.606*dx*vdamp)/(2*maxfdamp)
           do iz=1,nz
              dampf(iz)=expbase**(kappa/((iz*dx)**2))
           enddo
c     MAKE LINEAR GRADIENT TO EDGEFACTORFTOR, IF DEFINED
           if (edgefactorf.ne.0) then
              bvalue=-9999
              iz=0
              do while (bvalue.lt.edgefactorf) 
                 iz=iz+1
                 bvalue=(dampf(iz)-dampf(iz+1))*(iz-1)+dampf(iz)
                 if (bvalue.gt.edgefactorf) then
                    iz=iz-1
                    do iiz=1,iz
                       dampf(iiz)=(dampf(iz)-
     1                      dampf(iz+1))*(iz-iiz)+dampf(iz)
                    enddo
                 end if
              enddo
              
              if (verbose.gt.2) then 
                 PRINT*, ' FRESNEL WIDE ANGLE DAMPING'
                 PRINT*, '  vdamp=',vdamp
                 PRINT*, '  maxfdamp=',maxfdamp
                 PRINT*, '  expbase=',expbase
                 PRINT*, '  efac=',edgefactorf
                 PRINT*, ' -Writing Damping profile to damping_z.out'
              end if
              open(1,file='damping_z.asc')    
              do iz=1,nz
                 write(1,*) dampf(iz)
              enddo
              close(1)
           end if
        end if

c---------------------------------------------------------------
c       APPLY DAMPING ONLY EVERYWHERE IN THE GRID
c---------------------------------------------------------------
        do iz=(1+bz1),(nz+bz1)
           do ix=(1+bx1),(nx+bx1)
              ut(ix,nz+1-iz)= ut(ix,nz+1-iz)*dampf(iz)
              wt(ix,nz+1-iz)= wt(ix,nz+1-iz)*dampf(iz) 
              tauxx(ix,nz+1-iz)=tauxx(ix,nz+1-iz)*dampf(iz) 
              tauzz(ix,nz+1-iz)=tauzz(ix,nz+1-iz)*dampf(iz) 
              tauxz(ix,nz+1-iz)=tauxz(ix,nz+1-iz)*dampf(iz) 
           enddo
        enddo
          
	return
	end
      
