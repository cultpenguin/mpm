	subroutine abs_cerjan(bx1,bz1,dx,nx,nz,ut,wt,tauxx,tauxz,tauzz,
     1 freeupper,edgef,dwidth,dexp,dampingtype)
c******************************************************************
c       
c       ATTENUATE : CERJAN(1985) style damping around edges
c       
c       DAMPING IS PERFORMED ON ALL EDGE
c
c
c       THERE IS A SLIGHT BUG WHEN DAMPING THE STRESS FILEDS 
c       AT THE TOP. FRO SOME REASON THE REFLECTED ENERGY IS SLIGHTLY
c       LARGER FROM THE TOP THAN THE OTHER BORDERS ?
c
c
c******************************************************************
	implicit none
	include 'mpm.inc'

c       GLOBAL VARIABLES

c       MODEL
	REAL dx
	INTEGER bx1,bz1   

c       MOVING BOX
	INTEGER nx,nz
	REAL ut(nxmax,nzmax),wt(nxmax,nzmax)
	REAL tauxx(nxmax,nzmax), tauzz(nxmax,nzmax)
	REAL tauxz(nxmax,nzmax)

c       BOUNDARIES
	INTEGER freeupper
	REAL edgef
	INTEGER dwidth, dexp, dampingtype

c       LOCAL VARIABLES
	INTEGER dwidthp 
	REAL aa,dis
	INTEGER iz,ix
	INTEGER xx,zz

	xx=2*bx1
	zz=2*bz1

	dwidthp = dwidth+1
	
c
c
c Damp LHS and RHS boundaries
c
	do ix=(1+bx1),(dwidth+bx1)
	   aa=1-(1-edgef)*(ix-bx1)**dexp/(dwidth**dexp)
c	   PRINT*, 'ix=',ix,' fix=',(dwidthp-ix+xx),nx-dwidth+ix,aa
	   do iz=(dwidthp+bz1),(nz-dwidth+bz1)
c       RIGHT
	      ut(nx-dwidth+ix,iz)=ut(nx-dwidth+ix,iz)*aa
	      wt(nx-dwidthp+ix,iz)=wt(nx-dwidthp+ix,iz)*aa
	      if (dampingtype.eq.2) then 
		 tauxx(nx-dwidthp+ix,iz)=tauxx(nx-dwidthp+ix,iz)*aa
		 tauxz(nx-dwidth+ix,iz)=tauxz(nx-dwidth+ix,iz)*aa
		 tauzz(nx-dwidthp+ix,iz)=tauzz(nx-dwidthp+ix,iz)*aa
	      end if      
c       LEFT
	      ut(dwidthp-ix+xx,iz)=ut(dwidthp-ix+xx,iz)*aa
	      wt(dwidthp-ix+xx,iz)=wt(dwidthp-ix+xx,iz)*aa
	      if (dampingtype.eq.2) then 
		 tauxx(dwidthp-ix+xx,iz)=tauxx(dwidthp-ix+xx,iz)*aa
		 tauxz(dwidthp-ix+xx,iz)=tauxz(dwidthp-ix+xx,iz)*aa
		 tauzz(dwidthp-ix+xx,iz)=tauzz(dwidthp-ix+xx,iz)*aa
	      end if
	   enddo
	enddo

c
c THERE IS A BUG IN DAMPING THE STRESSES AT THE TOP BORDER
c 
c
	do iz=(1+bz1),(dwidth+bz1)
	   aa=1-(1-edgef)*(iz-bz1)**dexp/(dwidth**dexp)
c	   PRINT*, 'iz=',iz,' fiz=',(dwidthp-iz+zz),nz-dwidth+ix,aa
	   do ix=(dwidthp+bx1),(nx-dwidth+bx1)
c       TOP
	      ut(ix,dwidthp-iz+zz)=ut(ix,dwidthp-iz+zz)*aa         
	      wt(ix,dwidthp-iz+zz)=wt(ix,dwidthp-iz+zz)*aa
	      if (dampingtype.eq.2) then 
     	         tauxx(ix,dwidthp-iz+zz)=tauxx(ix,dwidthp-iz+zz)*aa
		 tauxz(ix,dwidthp-iz+zz)=tauxz(ix,dwidthp-iz+zz)*aa
		 tauzz(ix,dwidthp-iz+zz)=tauzz(ix,dwidthp-iz+zz)*aa
	      end if
c       BOTTOM
	      ut(ix,nz-dwidth+iz)=ut(ix,nz-dwidth+iz)*aa
	      wt(ix,nz-dwidthp+iz)=wt(ix,nz-dwidthp+iz)*aa
	      if (dampingtype.eq.2) then 
		 tauxx(ix,nz-dwidthp+iz)=tauxx(ix,nz-dwidthp+iz)*aa
		 tauxz(ix,nz-dwidth+iz)=tauxz(ix,nz-dwidth+iz)*aa
		 tauzz(ix,nz-dwidthp+iz)=tauzz(ix,nz-dwidthp+iz)*aa
	      end if
	   enddo
	enddo
c
c Damp four corners
c
	do iz=(1+bz1),(dwidth+bz1)
	do ix=(1+bx1),(dwidth+bx1)
	   dis=( (ix-bx1)**2 + (iz-bz1)**2 )**(.5)
	   aa=1-(1-edgef)*dis**dexp/(dwidth**dexp)
c       TOP LEFT
	   ut(dwidthp-ix+xx,dwidthp-iz+zz)=
     1        ut(dwidthp-ix+xx,dwidthp-iz+zz)*aa
	   wt(dwidthp-ix+xx,dwidthp-iz+zz)=
     1        wt(dwidthp-ix+xx,dwidthp-iz+zz)*aa
	   if (dampingtype.eq.2) then 
	      tauxx(dwidthp-ix+xx,dwidthp-iz+zz)=
     1              tauxx(dwidthp-ix+xx,dwidthp-iz+zz)*aa
	      tauxz(dwidthp-ix+xx,dwidthp-iz+zz)=
     1              tauxz(dwidthp-ix+xx,dwidthp-iz+zz)*aa
	      tauzz(dwidthp-ix+xx,dwidthp-iz+zz)=
     1              tauzz(dwidthp-ix+xx,dwidthp-iz+zz)*aa
	   end if
c       BOTTOM LEFT
	   ut(dwidthp-ix+xx,nz-dwidth+iz)=
     1        ut(dwidthp-ix+xx,nz-dwidth+iz)*aa
	   wt(dwidthp-ix+xx,nz-dwidthp+iz)=
     1        wt(dwidthp-ix+xx,nz-dwidthp+iz)*aa
	   if (dampingtype.eq.2) then 
              tauxx(dwidthp-ix+xx,nz-dwidth+iz)=
     1              tauxx(dwidthp-ix+xx,nz-dwidth+iz)*aa
	      tauxz(dwidthp-ix+xx,nz-dwidthp+iz)=
     1              tauxz(dwidthp-ix+xx,nz-dwidthp+iz)*aa
	      tauzz(dwidthp-ix+xx,nz-dwidth+iz)=
     1              tauzz(dwidthp-ix+xx,nz-dwidth+iz)*aa
	   end if
c	BOTTOM RIGHT
	   ut(nx-dwidth+ix,nz-dwidth+iz)=
     1	      ut(nx-dwidth+ix,nz-dwidth+iz)*aa
	   wt(nx-dwidthp+ix,nz-dwidthp+iz)=
     1        wt(nx-dwidthp+ix,nz-dwidthp+iz)*aa
	   if (dampingtype.eq.2) then 
	      tauxx(nx-dwidthp+ix,nz-dwidth+iz)=
     1              tauxx(nx-dwidthp+ix,nz-dwidth+iz)*aa
	      tauxz(nx-dwidth+ix,nz-dwidthp+iz)=
     1              tauxz(nx-dwidth+ix,nz-dwidthp+iz)*aa
	      tauzz(nx-dwidthp+ix,nz-dwidth+iz)=
     1              tauzz(nx-dwidthp+ix,nz-dwidth+iz)*aa
	   end if
c	TOP RIGHT
	   ut(nx-dwidth+ix,dwidthp-iz+zz)=
     1        ut(nx-dwidth+ix,dwidthp-iz+zz)*aa
	   wt(nx-dwidthp+ix,dwidthp-iz+zz)=
     1        wt(nx-dwidthp+ix,dwidthp-iz+zz)*aa
	   if (dampingtype.eq.2) then 
	      tauxx(nx-dwidthp+ix,dwidthp-iz+zz)=
     1              tauxx(nx-dwidthp+ix,dwidthp-iz+zz)*aa
	      tauxz(nx-dwidth+ix,dwidthp-iz+zz)=
     1              tauxz(nx-dwidth+ix,dwidthp-iz+zz)*aa
	      tauzz(nx-dwidthp+ix,dwidthp-iz+zz)=
     1              tauzz(nx-dwidthp+ix,dwidthp-iz+zz)*aa
	   end if
	enddo
	enddo
c
c
	return
	end
