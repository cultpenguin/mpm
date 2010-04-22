	subroutine setmpmgrid(dt,dx,nx,nz,buffer,bx1,bz1,bbx1,bbz1,
	1    wavex,wavez,mu,l,l2mu,denu,denw,ut,wt,tauxx,tauzz,tauxz,
	2    it,it1,verbose,xs,zs,bignx,bignz,style,autopad)


c*******************************************************
c       SETMPM_GRID : 
c*******************************************************
c       
c       HANDLES THE SMALL AND MEDIUM GRID
c       
c       MAKE SURE THE RIGHT RIGHT 'STRIP' IS CLEARED
c       WHEN THE BOX I MOVING UP AND THE LEFT
c       
c       
c       ACTIVE GRID : The part of the loaded frid where finite 
c       finite difference calcalations are performed
c       
c       BOX GRID : The elastic-properties grid that 
c	is loaded into physical memory
c       
c       DISK GRID : The complete elastic model, residing on 
c	harddisk
c       
c       wavex(it),wavez(it) gives the start position of the 'active'
c       grid
c       wavex(it)=bbx1+bx1+1
c       wavex(it)=bbx1+bx1+1
c       
c       bbx1,bbz1 width of empty space ahead of the 'box' grid
c       bx1,bz1 : width of empty gridspace between
c	the 'box'-grid and the beginning of the 'active' grid
c       
c       
c       
c       THIS SUBROUTINE SHOULD AT SOME TIME BE SPLIT INTO
c       ONE MORE FUNCTION 'ERASE_ROW', AND 'ERASE_COL'
c       THAT COULD BE CALLED BOTH WHEN THE ACTIVE BOX 
c       IS MOVING AND WHEN THE BOX-GRID IS UPDATED
c       
c       
	implicit none	
	include 'mpm.inc'
	
c---------------------------------------------------------------
c       GLOBAL VARIABLES FROM MAIN PROGRAM
c---------------------------------------------------------------
c       MODEL
	REAL dx
	INTEGER bx1,bz1
	INTEGER bbx1,bbz1
	INTEGER bignx, bignz
	INTEGER autopad
	
c       MOVING BOX
	INTEGER nx,nz
	INTEGER buffer
	INTEGER wavex(ntmax),wavez(ntmax)
	REAL mu(nxmax,nzmax)
	REAL l(nxmax,nzmax), l2mu(nxmax,nzmax) 
	REAL denu(nxmax,nzmax), denw(nxmax,nzmax)
	REAL ut(nxmax,nzmax), wt(nxmax,nzmax)
	REAL tauxx(nxmax,nzmax), tauzz(nxmax,nzmax)
	REAL tauxz(nxmax,nzmax)

c       TIME SAMPLING
	REAL dt

c       SOURCE
	INTEGER xs,zs

c       AUTOSAVE
	INTEGER it1

c       IO
	INTEGER verbose
	INTEGER it,style

c---------------------------------------------------------------
c	LOCAL VARIABLES
c---------------------------------------------------------------
	INTEGER ix,iz,iz2

c---------------------------------------------------------------
c       SETUP MODEL AT TIMESTEP 1
c---------------------------------------------------------------
	if (it.eq.it1) then
	   
	   if (verbose.gt.1) then 
	      PRINT*, '------------------------------'
	      PRINT*, ' READING ELASTIC PARAMETERS'
	      PRINT*, ' READING AT FIRST TIMESTEP, it1=',it1
	   end if
	   
	   bbx1=int(wavex(it)/buffer)*buffer
	   bbz1=int(wavez(it)/buffer)*buffer
	   if (style.eq.1) then
	      call gethzmodel(bbx1+1,bbz1+1,nx,nz,bignx,bignz,
	1	   buffer,mu,l,l2mu,denu,denw,
	2	   ut,wt,tauxx,tauzz,tauxz,dx,dt,autopad,verbose)
	   else
	      call getmodel(bbx1+1,bbz1+1,nx,nz,bignx,bignz,
	1	   buffer,mu,l,l2mu,denu,denw,
	2	   ut,wt,tauxx,tauzz,tauxz,dx,dt,autopad,verbose)
	   end if
	   if (verbose.gt.1) then 
	      PRINT*, ' MODEL WAS READ'
	      PRINT*, '------------------------------'
	   end if
	   bx1=wavex(it)-(bbx1)-1
	   bz1=wavez(it)-(bbz1)-1

	end if

c---------------------------------------------------------------
c       LOAD ELASTIC PROPERTIES + SHIFT VEL-TAU FIELDS
c       IF BUFFER IS FILLED
c---------------------------------------------------------------

c---------------------------------------------------------------
c       MOVING TO THE RIGHT
	if ((wavex(it)-bbx1).gt.buffer) then
	   bbx1=bbx1+buffer
c       do iz=bz1+1,(bz1+nz)
	   do iz=1,(nz+buffer)
	      do ix=1,nx
c       PRINT*, ' iz=bz1,(bz1+nz-1),,NZ,BZ1=',bz1,bz1+nz-1,nz,bz1
		 ut(ix,iz)=ut(ix+buffer,iz)
		 wt(ix,iz)=wt(ix+buffer,iz)
		 tauxx(ix,iz)=tauxx(ix+buffer,iz)
		 tauzz(ix,iz)=tauzz(ix+buffer,iz)
		 tauxz(ix,iz)=tauxz(ix+buffer,iz)
	      enddo
	      do ix=(nx+1),(nx+buffer)
		 ut(ix,iz)=0
		 wt(ix,iz)=0
		 tauxx(ix,iz)=0
		 tauzz(ix,iz)=0
		 tauxz(ix,iz)=0
	      enddo
	   enddo

c       PRINT*,'THINK I READ from wavex,wavez=',wavex(it),wavez(it)
c       PRINT*,'NO NO FROM : =',bbx1+1,bbz1+1

	   if (style.eq.1) then
	      if (verbose.gt.2) print*,'-- gethzmodel move right'
	      call gethzmodel(bbx1+1,bbz1+1,nx,nz,bignx,bignz,
	1	   buffer,mu,l,l2mu,denu,denw,
	2	   ut,wt,tauxx,tauzz,tauxz,dx,dt,autopad,verbose)
	   else
	      if (verbose.gt.2) print*,'-- getmodel move right'
	      call getmodel(bbx1+1,bbz1+1,nx,nz,bignx,bignz,
	1	   buffer,mu,l,l2mu,denu,denw,
	2	   ut,wt,tauxx,tauzz,tauxz,dx,dt,autopad,verbose)
	   end if
	   bx1=wavex(it)-(bbx1)-1
	   bz1=wavez(it)-(bbz1)-1

	   if (it.gt.1) then
	      ix=wavex(it-1)-bbx1
	      if (ix.ne.0) then
c       PRINT*, ' REMOVING COLUMN AT ix(it)=',ix,it
		 do iz=(wavez(it-1)-bbz1),(wavez(it-1)+nz-1-bbz1)
		    ut(ix,iz)=0
		    wt(ix,iz)=0
		    tauxx(ix,iz)=0
		    tauxz(ix,iz)=0
		    tauzz(ix,iz)=0
		 end do
	      end if
	   end if
	   
	   if (verbose.gt.2) 
	1	PRINT*, it,' RIGHT BUFFER END. bx1,bbx1=',bx1,bbx1

	end if

c---------------------------------------------------------------
c       MOVING TO THE LEFT
	if ((wavex(it)-bbx1).le.0) then
	   if (verbose.gt.2) 
	1	PRINT*, it,' SMALL BOX REACHED  LEFT BUFFER ZONE'
	   bbx1=bbx1-buffer
c       do iz=(bz1+1),(bz1+nz)
	   do iz=(1),(nz+buffer)
	      do ix=nx,1,-1
		 ut(ix+buffer,iz)=ut(ix,iz)
		 wt(ix+buffer,iz)=wt(ix,iz)
		 tauxx(ix+buffer,iz)=tauxx(ix,iz)
		 tauzz(ix+buffer,iz)=tauzz(ix,iz)
		 tauxz(ix+buffer,iz)=tauxz(ix,iz)
	      enddo
	      do ix=1,buffer
		 ut(ix,iz)=0
		 wt(ix,iz)=0
		 tauxx(ix,iz)=0
		 tauzz(ix,iz)=0
		 tauxz(ix,iz)=0
	      enddo
	   enddo
	   if (style.eq.1) then
	      if (verbose.gt.2) print*,'-- gethzmodel move left'
	      call gethzmodel(bbx1+1,bbz1+1,nx,nz,bignx,bignz,
	1	   buffer,mu,l,l2mu,denu,denw,
	2	   ut,wt,tauxx,tauzz,tauxz,dx,dt,autopad,verbose)
	   else
	      if (verbose.gt.2) print*,'- getmodel move left'
	      call getmodel(bbx1+1,bbz1+1,nx,nz,bignx,bignz,
	1	   buffer,mu,l,l2mu,denu,denw,
	2	   ut,wt,tauxx,tauzz,tauxz,dx,dt,autopad,verbose)
	   end if
	   if (verbose.gt.2) 
	1	PRINT*, it,' LEFT BUFFER END. bx1,bbx1=',bx1,bbx1

	   bx1=wavex(it)-(bbx1)-1
	   bz1=wavez(it)-(bbz1)-1

c       CLEARING GRID
	   if (it.gt.1) then
	      ix=wavex(it-1)+nx-bbx1
	      if (ix.ne.0) then
c       PRINT*, ' REMOVING COLUMN AT ix(it)=',ix,it
		 do iz=(wavez(it-1)-bbz1),(wavez(it-1)+nz-1-bbz1)
		    ut(ix,iz)=0
		    wt(ix,iz)=0
		    tauxx(ix,iz)=0
		    tauxz(ix,iz)=0
		    tauzz(ix,iz)=0
		 end do
	      end if
	   end if		   
	   
	end if

c---------------------------------------------------------------
c       MOVING DOWN
	if ((wavez(it)-bbz1).gt.buffer) then
	   if (verbose.gt.2) 
	1	PRINT*, it,' SMALL BOX REACHED BOTTOM BUFFER ZONE'
	   bbz1=bbz1+buffer
c       do ix=(bx1+1),(bx1+nx)
	   do ix=(1),(nx+buffer)
	      do iz=1,nz
		 ut(ix,iz)=ut(ix,iz+buffer)
		 wt(ix,iz)=wt(ix,iz+buffer)
		 tauxx(ix,iz)=tauxx(ix,iz+buffer)
		 tauzz(ix,iz)=tauzz(ix,iz+buffer)
		 tauxz(ix,iz)=tauxz(ix,iz+buffer)
	      enddo
	      do iz=(nz+1),(nz+buffer)
		 ut(ix,iz)=0
		 wt(ix,iz)=0
		 tauxx(ix,iz)=0
		 tauzz(ix,iz)=0
		 tauxz(ix,iz)=0
	      enddo
	   enddo

	   if (style.eq.1) then
	      if (verbose.gt.2) print*,'-- gethzmodel move down'
	      call gethzmodel(bbx1+1,bbz1+1,nx,nz,bignx,bignz,
	1	   buffer,mu,l,l2mu,denu,denw,
	2	   ut,wt,tauxx,tauzz,tauxz,dx,dt,autopad,verbose)
	   else
	      if (verbose.gt.2) print*,'-- getmodel move down'
	      call getmodel(bbx1+1,bbz1+1,nx,nz,bignx,bignz,
	1	   buffer,mu,l,l2mu,denu,denw,
	2	   ut,wt,tauxx,tauzz,tauxz,dx,dt,autopad,verbose)
	   end if
	   bx1=wavex(it)-(bbx1)-1
	   bz1=wavez(it)-(bbz1)-1

c       CLEARING AND EXTRAPOLATE GRID	   
	   if(it.gt.1) then
	      iz=wavez(it-1)-bbz1
	      if (iz.ne.0) then
c       PRINT*, ' REMOVING COLUMN AT iz(it)=',iz,it
c       PRINT*, '     wavex(it-1),bbx1=',wavex(it-1),bbx1
		 do ix=(wavex(it-1)-bbx1),(wavex(it-1)+nx-1-bbx1)
c       CLEAR
		    ut(ix,iz)=0
		    wt(ix,iz)=0
		    tauxx(ix,iz)=0
		    tauxz(ix,iz)=0
		    tauzz(ix,iz)=0
		 end do
	      end if
	   end if
	   
	   if (verbose.gt.2) 
	1	PRINT*, it,' BOTTOM BUFFER END. bz1,bbz1=',bz1,bbz1

	end if

c---------------------------------------------------------------
c       MOVING UP
	if ((wavez(it)-bbz1).le.0) then
	   if (verbose.gt.2) 
	1	PRINT*, it,' SMALL BOX REACHED END OF LEFT BUFFER ZONE'
	   bbz1=bbz1-buffer
c       do ix=(bx1+1),(bx1+nx)
	   do ix=(1),(nx+buffer)
	      do iz=nz,1,-1
		 ut(ix,iz+buffer)=ut(ix,iz)
		 wt(ix,iz+buffer)=wt(ix,iz)
		 tauxx(ix,iz+buffer)=tauxx(ix,iz)
		 tauzz(ix,iz+buffer)=tauzz(ix,iz)
		 tauxz(ix,iz+buffer)=tauxz(ix,iz)
	      enddo
	      do iz=1,buffer
		 ut(ix,iz)=0
		 wt(ix,iz)=0
		 tauxx(ix,iz)=0
		 tauzz(ix,iz)=0
		 tauxz(ix,iz)=0
	      enddo
	   enddo

	   if (style.eq.1) then
	      if (verbose.gt.2) print*,'-- gethzmodel move up'
	      call gethzmodel(bbx1+1,bbz1+1,nx,nz,bignx,bignz,
	1	   buffer,mu,l,l2mu,denu,denw,
	2	   ut,wt,tauxx,tauzz,tauxz,dx,dt,autopad,verbose)
	   else
	      if (verbose.gt.2) print*,'-- Getmodelx move up'
	      call getmodel(bbx1+1,bbz1+1,nx,nz,bignx,bignz,
	1	   buffer,mu,l,l2mu,denu,denw,
	2	   ut,wt,tauxx,tauzz,tauxz,dx,dt,autopad,verbose)
	   end if
	   bx1=wavex(it)-(bbx1)-1
	   bz1=wavez(it)-(bbz1)-1

c       CLEARING GRID	   
	   if(it.gt.1) then
	      iz=wavez(it-1)+nz-bbz1
	      if (iz.ne.0) then
c       PRINT*, ' REMOVING COLUMN AT iz(it)=',iz,it
c       PRINT*, '     wavex(it-1),bbx1=',wavex(it-1),bbx1
		 do ix=(wavex(it-1)-bbx1),(wavex(it-1)+nx-1-bbx1)
		    ut(ix,iz)=0
		    wt(ix,iz)=0
		    tauxx(ix,iz)=0
		    tauxz(ix,iz)=0
		    tauzz(ix,iz)=0
		 end do
	      end if
	   end if

	   if (verbose.gt.2) 
	1	PRINT*, it,' TOP BUFFER END. bz1,bbz1=',bz1,bbz1


	end if

c---------------------------------------------------------------
c	
c---------------------------------------------------------------

c	clear grid moving out of the grid in X direction
	if (it.gt.1) then
	   if (wavex(it).ne.wavex(it-1)) then
c       print*,'CLEARING GRID'
	      if (wavex(it).gt.wavex(it-1)) ix=wavex(it-1)-bbx1
	      if (wavex(it).lt.wavex(it-1)) ix=wavex(it-1)+nx-bbx1-1	
	      if (verbose.gt.2) print*, '  MOVING HORISONTALLY',
	1	   it,ix,wavex(it),wavez(it-1),(wavez(it-1)+nz-1),nz
	      if (ix.ne.0) then
		 do iz=(wavez(it-1)-bbz1),(wavez(it-1)+nz-1-bbz1)
		    ut(ix,iz)=0
		    wt(ix,iz)=0
		    tauxx(ix,iz)=0
		    tauxz(ix,iz)=0
		    tauzz(ix,iz)=0
		 end do
	      end if
	   end if

c	clear grid moving out of the grid in Z direction
	   if (wavez(it).ne.wavez(it-1)) then
c       print*,'CLEARING GRID'
	      if (wavez(it).gt.wavez(it-1)) then 
		 iz=wavez(it-1)-bbz1
		 iz2=wavez(it)-bbz1+nz-1
	      end if
	      if (wavez(it).lt.wavez(it-1)) then 
		 iz=wavez(it-1)+nz-bbz1-1
		 iz2=wavez(it)
	      end if
	      if (verbose.gt.2) print*, '  MOVING VERTICALLY',
	1	   it,iz,wavex(it),wavez(it-1),(wavex(it-1)+nx-1),nx
	      if (iz.ne.0) then
		 if (wavex(it-1).ne.bbx1) then
		    do ix=(wavex(it-1)-bbx1),(wavex(it-1)+nx-1-bbx1)
		       ut(ix,iz)=0
		       wt(ix,iz)=0
		       tauxx(ix,iz)=0
		       tauxz(ix,iz)=0
		       tauzz(ix,iz)=0
		       if (wavez(it).gt.wavez(it-1)) then
	1		    
c       EXTRAPOLATE
c       ut(ix,iz2)=ut(ix,iz2-1)+
c       1	              .1*(ut(ix,iz2-1)-ut(ix,iz2-2))
c       wt(ix,iz2-1)=wt(ix,iz2-2)+
c       1  	      .1*(wt(ix,iz2-2)-wt(ix,iz2-3))
c       tauxx(ix,iz2)=tauxx(ix,iz2-1)+
c       1  	      .1*(tauxx(ix,iz2-1)-tauxx(ix,iz2-2))
c       tauzz(ix,iz2)=tauzz(ix,iz2-1)+
c       1	              .1*(tauzz(ix,iz2-1)-tauzz(ix,iz2-2))
c       tauxz(ix,iz2-1)=tauxz(ix,iz2-2)+
c       1   	      .1*(tauxz(ix,iz2-2)-tauxz(ix,iz2-3))

c       EXTRAPOLATE ZEROS
			  ut(ix,iz2)=0
			  wt(ix,iz2-1)=0
			  tauxx(ix,iz2)=0
			  tauzz(ix,iz2)=0
			  tauxz(ix,iz2-1)=0

c       EXTRAPOLATE, u(zlast)=u(zlast-1)
c       ut(ix,iz2)=ut(ix,iz2-1)
c       wt(ix,iz2-1)=wt(ix,iz2-2)
c       tauxx(ix,iz2)=tauxx(ix,iz2-1)
c       tauzz(ix,iz2)=tauzz(ix,iz2-1)
c       tauxz(ix,iz2-1)=tauxz(ix,iz2-2)

		       end if
		    end do
		 end if
	      end if
	   end if


	end if




c---------------------------------------------------------------
c	Set new startpos in small grid
c	Update bx1,bz1 (even though it might have been done above
c---------------------------------------------------------------
	
	bx1=wavex(it)-(bbx1)-1
	bz1=wavez(it)-(bbz1)-1

	return 
	end


