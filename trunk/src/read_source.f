      
      subroutine read_source(source,nt)
      implicit none
      include 'mpm.inc'


c---------------------------------------------------------------
c     HCS 17/01/01
c---------------------------------------------------------------
c     Global variables from Main program
c---------------------------------------------------------------

c     SOURCE
      INTEGER nt
      REAL source(ntmax)


c---------------------------------------------------------------
c     Local variables
c---------------------------------------------------------------
      INTEGER int
      REAL dum
c---------------------------------------------------------------
c     READ source.asc
c---------------------------------------------------------------
c

c     OPEN FILE
      open(1,file='source.asc')
         rewind(1)
         do int=1,nt
            read(1,*) dum         
            source(int) = dum
         enddo
      close(1)

      return
      end





