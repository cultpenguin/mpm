	subroutine transp(fil,nt,n,m)
c       
c*******************************************************
c       TRANSP : 
c*******************************************************
c Transforming orientation of the seismic data so that they can be directly
c used in SU by xwigb < geou.bin n1=nt
c m is the character length of the filename, max 8 charcters
c Tested for tracskip=1,2,3,4 nt=700 geotype=3 geodepth=0


	IMPLICIT NONE
	INCLUDE 'mpm.inc' 

c---------------------------------------------------------------	
c       GLOBAL VARIABLES FROM MAIN PROGRAM
c---------------------------------------------------------------	
c  
	INTEGER nt

c---------------------------------------------------------------	
c	LOCAL VARIABLES
c---------------------------------------------------------------

	INTEGER i,j,n,m
	REAL*4 sdata(nt,n)
	CHARACTER fil*8, text1*4,text*12

	text=''
	text1='.f77'
	text(1:m)=fil(1:m)
	text(1+m:4+m)=text1(1:4)
	OPEN(10,file=text,form='unformatted')
	DO i=1,nt
	  READ(10) (sdata(i,j) , j=1,n)
	ENDDO	
	CLOSE(10)
	text=''
	text1='.bin'
	text(1:m)=fil(1:m)
	text(1+m:4+m)=text1(1:4)
        OPEN(10,access='direct', file=text,
     &	       recl=ibyte*nt)
	DO i=1,n
           WRITE(10,rec=i) (sdata(j,i) , j=1,nt)
	ENDDO	
	CLOSE(10)

	RETURN
	END
