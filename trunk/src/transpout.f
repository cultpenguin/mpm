      subroutine transpout(nx,nz,bignx,bignz,snapsize,tskip,xyskip)
      
      
      
      open(5,file='progress')      
      open(10,file='geou.f77',form='unformatted')      
      open(11,file='geow.f77',form='unformatted')      
      open(12,file='geodiv.f77',form='unformatted')      
      open(13,file='georot.f77',form='unformatted')      
      open(20,file='ut.snap',form='unformatted')      
      open(21,file='wt.snap',form='unformatted')      
      open(22,file='div.snap',form='unformatted')      
      open(23,file='rot.snap',form='unformatted')      
      rewind(5)
      rewind(10)
      rewind(11)
      rewind(12)
      rewind(13)
      rewind(20)
      rewind(21) 
      rewind(22)
      rewind(23)
      
      return
      end
