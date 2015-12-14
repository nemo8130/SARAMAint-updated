c        PROGRAM TO CHANGE THE STATUS OF THE OUTPUT SURFACE FILE FROM CONN4.F

      character*3 res,atom

      dimension dotx(995,5000),doty(995,5000),
     *dotz(995,5000)
      dimension dotnx(995,5000),dotny(995,5000),
     *dotnz(995,5000)
      character*3 ato(995,5000)
      dimension istatus(995,5000,3),irestot(995)
      dimension irem(1000),iresrem(1000),iresw(995)
      dimension xrem(1000),yrem(1000),zrem(1000)
      character*3  atomrem(1000),resrem(1000),resw(995) 
      character(70)::fline
      character(1)::chain,chn(995)

      open(unit=1,file ='alter.inp',status='old')
      open(unit=2,file ='surf_dot' ,status='old')
      open(unit=3,file ='surf_out' ,status='new')
      open(unit=4,file ='remove.out',status = 'old') 
      open(unit=5,file ='msph.dot',status = 'old') 

      do  1  i = 1,995
      irestot(i) = 0
1     continue
      iti =0

      read(1,2)inatom,iresmin,iresmax,irest
2     format(2x,i6,2x,i6,2x,i6,2x,i6)

      read(4,59)iremt
59    format(i6)

      if (iremt.eq.0)goto 10
      if(iremt.eq.1)then
      read(4,7)irem(1),atomrem(1),iresrem(1),resrem(1),
     *xrem(1),yrem(1),zrem(1)
      goto 10
7     format(2x,i6,1x,a3,2x,i5,2x,a3,2x,3f8.3)
      endif
       
      do  8  i = 1,iremt
      read(4,7)irem(i),atomrem(i),iresrem(i),resrem(i),
     *xrem(i),yrem(i),zrem(i)
8     continue

10    continue

      if(iremt.eq.0)goto 99
      if(iremt.eq.1)goto 100
      if(iremt.gt.1)goto 101 
c-------------------------------------

99    do  23  j = 1, inatom 
       
      read(2,5)iat,atom,ires,res,nam,chain
5     format(i5,1x,a3,i3,a3,2x,i6,2x,a1)
      if(nam.eq.0)then
      goto 23
      endif
      resw(ires)=res
      iresw(ires)=ires
      chn(ires)=chain

      do  26  k = 1, nam 
         
      read(2,17)x,y,z,tnx,tny,tnz,ist1,ist2,ist3
      irestot(ires)=irestot(ires) + 1
      dotx(ires,irestot(ires))=x
      doty(ires,irestot(ires))=y
      dotz(ires,irestot(ires))=z
      dotnx(ires,irestot(ires))=tnx
      dotny(ires,irestot(ires))=tny
      dotnz(ires,irestot(ires))=tnz
      istatus(ires,irestot(ires),1)=ist1
      istatus(ires,irestot(ires),2)=ist2
      istatus(ires,irestot(ires),3)=ist3
      ato(ires,irestot(ires))=atom
26    continue 
         

23    continue       

      goto 50


c---------------------------------------------
100   do  33  j = 1, inatom 
       
      read(2,5)iat,atom,ires,res,nam,chain
      if(nam.eq.0)then
      goto 33
      endif
      resw(ires)=res
      iresw(ires)=ires
      chn(ires)=chain

      do  36 k = 1, nam 
         
      read(2,17)x,y,z,tnx,tny,tnz,ist1,ist2,ist3
17    format(6f8.3,2x,i1,i5,i5)

      if( iat.eq.irem(1) )then
      if( (xrem(1).eq.x).and.(yrem(1).eq.y).and.
     *(zrem(1).eq.z) )then
      goto 36
      endif
      endif

      irestot(ires)=irestot(ires) + 1
      dotx(ires,irestot(ires))=x
      doty(ires,irestot(ires))=y
      dotz(ires,irestot(ires))=z
      dotnx(ires,irestot(ires))=tnx
      dotny(ires,irestot(ires))=tny
      dotnz(ires,irestot(ires))=tnz
      istatus(ires,irestot(ires),1)=ist1
      istatus(ires,irestot(ires),2)=ist2
      istatus(ires,irestot(ires),3)=ist3
      ato(ires,irestot(ires))=atom

36    continue 
         

33    continue 

      goto 50      
c-------------------------------------------

101   do 43 j = 1, inatom
       
      read(2,5)iat,atom,ires,res,nam,chain
      if(nam.eq.0)then
      goto 43
      endif
      resw(ires)=res
      iresw(ires)=ires
      chn(ires)=chain

      do  46  k = 1, nam

 
      read(2,17)x,y,z,tnx,tny,tnz,ist1,ist2,ist3

      do  49  i = 1, iremt
       if( iat.eq.irem(i) )then
         if( (xrem(i).eq.x).and.(yrem(i).eq.y).and.
     *(zrem(i).eq.z) )then
         goto 46
         endif
       endif
49    continue

      irestot(ires)=irestot(ires) + 1
      dotx(ires,irestot(ires))=x
      doty(ires,irestot(ires))=y
      dotz(ires,irestot(ires))=z
      dotnx(ires,irestot(ires))=tnx
      dotny(ires,irestot(ires))=tny
      dotnz(ires,irestot(ires))=tnz
      istatus(ires,irestot(ires),1)=ist1
      istatus(ires,irestot(ires),2)=ist2
      istatus(ires,irestot(ires),3)=ist3
      ato(ires,irestot(ires))=atom


46    continue

43    continue

      goto 50
c------------------------------------------------
c WRITING OUT THE SURFACE POINTS IN RESIDUE FORMAT
c-------------------------------------------------
         
50    continue

      do 51 i = 1,995
           if(iresw(i).eq.0)goto 51
           write(3,52)resw(i),iresw(i),irestot(i),chn(i)
           iti = iti + 1
52         format(5x,a3,2x,i6,2x,i6,2x,a1)
           do 53 j = 1,irestot(i)
           write(3,87)dotx(i,j),doty(i,j),dotz(i,j),
     *dotnx(i,j),dotny(i,j),dotnz(i,j),istatus(i,j,1),
     *ato(i,j)
87         format(2x,3f8.3,2x,3f8.3,1x,i3,2x,a3)
53         continue
51    continue
c---------------------------------------------------    
      if(iti.ne.irest)then
      write(4,77)
77    format('THERE IS SOME PROBLEM')
      endif
     

421   read(5,894,end=453)fline
      write(3,894)fline
      goto 421
453   continue
894   format(a70)

      stop
      end
c---------------------------------------------------
