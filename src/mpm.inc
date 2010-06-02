c
c REMEBER TO LEAVE SPACE FOR THE TOP BOUNDARY (+WIDTH OF ABS BOUNDARY) 
c IN THE Z-DIRECTION 
c
       integer nxmax,nzmax,ntmax
       integer nsources, nreceivers     
       integer maxbignz 
       integer maxbignx
       integer ibyte    
       parameter(nxmax=5000,nzmax=5000,ntmax=60001)
       parameter(nsources=10,nreceivers=9000) 
       parameter(maxbignz=9500)
       parameter(maxbignx=9500)
       parameter(ibyte=4)
