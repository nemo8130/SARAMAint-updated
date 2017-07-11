c        PROGRAM TO GENERATE TOPOLOGY CONNECTIONS AND ASSIGN VAN DER WAAL'S
c        RADII 
c        READ DOT POINTS FROM A LIBRARY
c        GENERATE THE SURFACE FOR THE MOLECULE.


          dimension   ires(20000), iatom(20000),irem(1000)
          character*3 resrem(1000)
          character*3 res(20000),atomrem(1000),chain(20000)
          character*3  atom
          common/ato/atom(20000)
          dimension   iresco(1000),iresrem(1000)
          dimension   xrem(1000),yrem(1000),zrem(1000)
          common/surf/xdotco(15,3000),ydotco(15,3000),zdotco(15,3000)
          common/norm/xnor(15,3000),ynor(15,3000),znor(15,3000)
          common/spec/radco(15),notco(15)

          common/coord/x(20000),y(20000),z(20000),ass(20000)
          common/connect/iconn(20000,50)
          common/atom/dotx(3000),doty(3000),dotz(3000)
          common/atnor/dotnx(3000),dotny(3000),dotnz(3000)
          common/istat/istatus(3000,3),istatrem(1000)


          open(unit=1,file='inp.pdb',status='old')
          open(unit=2,file='icon.out',status='new')
          open(unit=3,file='surf_dot',status='new')
          open(unit=4,file='sphere.dot',status='old')
          open(unit=5,file='alter.inp', status = 'new')
          open(unit=6,file='remove.out',status = 'new')
          open(unit=7,file='check',status='new')
          open(unit=8,file='sg.out',status='new')
          open(unit=9,file='sg.con',status='new')
          open(unit=101,file='surf.pdb',status='new')



          iatno=0 
          iresmin=999
          iresmax =0
          irestot =0
          iremto  =0
          iremco = 0
          inatom = 0
          isg=0


          do   663   i = 1,1000
          iresco(i) = 0  
663       continue


c----------------------------------------------------
c           READING IN THE DATA
c----------------------------------------------------

          do    10    i = 1,20000 
         read(1,20,end=25)atom(i),res(i),chain(i),ires(i)
     *,x(i),y(i),z(i)
20       format(13x,a3,1x,a3,1x,a1,1x,i3,4x,3f8.3)
         write(88,20)atom(i),res(i),chain(i),ires(i)
     *,x(i),y(i),z(i)
         iatno = iatno + 1
 
         iatom(i)=iatno
         if(ires(i).gt.iresmax)then
         iresmax = ires(i)
         endif
         if(ires(i).lt.iresmin)then
         iresmin = ires(i)
         endif
         iresco(ires(i))=ires(i) 
10       continue

25       continue

         do  450 j = 1,1000
         if(iresco(j).eq.0)goto 450
         irestot = irestot + 1
450      continue       
c----------------------------------------------------
c  ASSIGNING THE VAN DER WAAL'S RADII
c----------------------------------------------------
          do     46      i = 1 , iatno
          call  assv(atom(i),res(i),ass(i))
46        continue
c----------------------------------------------------
c           GENERATING THE CONNECTIVITIES
c----------------------------------------------------
         do    35    i = 1,iatno

         if(ass(i).eq.0)goto 35

                ico = 1

              do   45   j = 1,iatno

              if(ass(i).eq.0)goto 45

                  if(i.eq.j)go to 45
         if( (atom(i).eq.'SG ').and.(atom(j).eq.'SG ') )then
                       goto 61
                        endif
                  if(ires(j).gt.ires(i)+1)goto 45
                  if(ires(j).lt.ires(i)-1)goto 45

                  if(ires(j).eq.ires(i)+1)then
                  if( (atom(j).ne.'N  ').and.(atom(j).ne.'H  ')
     *.and.(atom(j).ne.'CA ') )then
                  goto 45
                  endif
                  endif

                  if(ires(j).eq.ires(i)-1)then
                  if( (atom(j).ne.'C  ').and.(atom(j).ne.'O  ')
     *.and.(atom(j).ne.'CA ') )then
                  goto 45
                  endif
                  endif



61         call caldist(x(i),y(i),z(i),x(j),y(j),z(j),dist)


          if( (atom(i).eq.'SG ').and.(atom(j).eq.'SG ') )then
          goto  621
          endif 
 

         if(dist.lt.4.00)then
         iconn(i,ico)=j
         ico=ico+1
         endif

621       if( (atom(i).eq.'SG ').and.(atom(j).eq.'SG ') )then
          if(dist.lt.2.25)then
          iconn(i,ico)=j
          ico=ico+1
          write(8,967)atom(i),res(i),ires(i),atom(j),res(j),ires(j)
967       format(a3,2x,a3,2x,i3,5x,a3,2x,a3,2x,i3)
          isg=isg+1
          endif
          endif

45       continue

35       continue

         write(9,987)isg
987      format(i6)
c-------------------------------------------------------------
c   READING IN THE LIBRARY OF DOT SURFACE POINTS
c-------------------------------------------------------------
        
          do   91   i = 1, 15

          read(4,53,end=91)radco(i),notco(i)
53        format(5x,f5.2,5x,i6)
          if(radco(i).eq.0)then
          goto 91
          else
          do     79    j = 1, notco(i)
          read(4,57,end=91)xdotco(i,j),ydotco(i,j),zdotco(i,j),
     *xnor(i,j),ynor(i,j),znor(i,j)   
57        format(6f10.4)
79        continue
          endif
         
91        continue
c------------------------------------------------------------
c   CALCULATING THE SURFACE OF THE MOLECULE
c------------------------------------------------------------
         do   47    j = 1, iatno

         if(ass(j).eq.0.0)then
         write(7,911)j,iatom(j),atom(j),res(j),ires(j)
911      format(i6,i6,a3,2x,a3,2x,i6)
         goto 47
         endif

         inatom = inatom +1
         call dotcal(j,x(j),y(j),z(j),ass(j),numo,nam,nas)
c--------------------------------------------------------
c          ASSIGNING THE STATUS OF THE MOLECULE
c--------------------------------------------------------
       
         do     376    l = 1,numo

       if((istatus(l,2).ne.0).and.(istatus(l,3).eq.0))then 

         if( (atom(istatus(l,2)).eq.'HA ').or.
     *       (atom(istatus(l,2)).eq.'N  ').or.
     *       (atom(istatus(l,2)).eq.'CA ').or. 
     *       (atom(istatus(l,2)).eq.'C  ').or. 
     *       (atom(istatus(l,2)).eq.'O  ').or.
     *       (atom(istatus(l,2)).eq.'OXT').or.
     *       (atom(istatus(l,2)).eq.'H  ') ) then
         istatus(l,1) = 1
         else
         istatus(l,1) = 2
         endif

         endif
         
        if( (istatus(l,2).ne.0).and.(istatus(l,3).ne.0) )then

        if(  (atom(istatus(l,2)).eq.'HA ').or.
     *       (atom(istatus(l,2)).eq.'N  ').or.
     *       (atom(istatus(l,2)).eq.'CA ').or.
     *       (atom(istatus(l,2)).eq.'C  ').or.
     *       (atom(istatus(l,2)).eq.'O  ').or.
     *       (atom(istatus(l,2)).eq.'H  ') ) then
              ifirst = 1
              else
              ifirst = 2
              endif


        if(  (atom(istatus(l,3)).eq.'HA ').or.
     *       (atom(istatus(l,3)).eq.'N  ').or.
     *       (atom(istatus(l,3)).eq.'CA ').or.
     *       (atom(istatus(l,3)).eq.'C  ').or.
     *       (atom(istatus(l,3)).eq.'O  ').or.
     *       (atom(istatus(l,3)).eq.'H  ') ) then
              isec= 1
              else
              isec = 2
              endif


              if(ifirst.eq.isec)then
              istatus(l,1)=ifirst
              endif

              if(ifirst.ne.isec)then
              istatus(l,1)=3
              endif

              
              iremto = iremto + 1
              irem(iremto) = j
              istatrem(iremto) = 1
              if(iremto.gt.1000)goto 109
              atomrem(iremto)  = atom(j)
              iresrem(iremto)  = ires(j)
              resrem(iremto)   = res(j)            
              xrem(iremto) = dotx(l)
              yrem(iremto) = doty(l)
              zrem(iremto) = dotz(l) 
 
              endif

376           continue
c--------------------------------------------------------
c--------------------------------------------------------
         write(3,50)j,atom(j),ires(j),res(j),nam,chain(j)
50       format(i5,1x,a3,i3,a3,2x,i6,2x,a1)

         icheck = 0

         do  51    k = 1,numo
         if(istatus(k,1).eq.0)then
         goto 51
         endif
         write(3,55)dotx(k),doty(k),dotz(k),dotnx(k),
     *dotny(k),dotnz(k),(istatus(k,l),l=1,3)
        write(101,591)'ATOM',j,atom(j),res(j),chain(j),ires(j),
     &dotx(k),doty(k),dotz(k),istatus(k,1)
591     format(a4,2x,i5,1x,a4,1x,a3,1x,a1,1x,i3,4x,3f8.3,2x,i1)
         icheck = icheck +1
55       format(6f8.3,2x,i1,i5,i5)
51       continue

         if(nam.ne.icheck)then
         goto 109
         endif


47       continue

         if((iremto.eq.0).or.(iremto.eq.1))goto 97
 
         do   511    i = 1 , iremto
         if(istatrem(i).eq.0)goto 511
         
         do   521    l = 1 , 25
         if(iconn(irem(i),l).eq.0)goto 521
         do   512    j = 1 , iremto
         if(irem(j).eq.iconn(irem(i),l))then
         call caldist(xrem(i),yrem(i),zrem(i),xrem(j),
     *yrem(j),zrem(j),distrem)
         if(distrem.le.0.001)then
         istatrem(j)=0
         iremco = iremco + 1
         endif
         endif
512      continue
521      continue
511      continue                  


97          write(6,529)iremco
529       format(i6)
          if(iremco.eq.0)goto 93
          if(iremco.eq.1)then
          write(6,537)irem(1),atomrem(1),iresrem(1),resrem(1),
     *xrem(1),yrem(1),zrem(1)
          goto 93
          endif   
         do   520    k = 1 , iremto
         if(istatrem(k).eq.0)then
         write(6,537)irem(k),atomrem(k),iresrem(k),resrem(k),
     *xrem(k),yrem(k),zrem(k)
537      format(2x,i6,1x,a3,2x,i5,2x,a3,2x,3f8.3)
         endif
520      continue




93       continue
         do  59  k = 1, iatno
         write (2,41)k, (iconn(k,j),j=1,25),ass(k)
41       format( 1x, i6, 1x, 25i6,f5.2 )  
59       continue
     
         goto 110

109      write(5,113)numo,nam,icheck,iremto
113      format(2x,'THERE IS SOME PROBLEM',i6,5x,i6,5x,i6)


110      continue 
         write(5,114)inatom,iresmin,iresmax,irestot
114      format(2x,i6,2x,i6,2x,i6,2x,i6)
c-------------------------------------------------------------
c-------------------------------------------------------------
c-------------------------------------------------------------


       stop
       end
c-------------------------------------------------------------
c-------------------------------------------------------------
c-------------------------------------------------------------
            subroutine caldist (x1,y1,z1,x2,y2,z2,dist)

            xsq = (x1-x2)*(x1-x2)

            ysq = (y1-y2)*(y1-y2)

            zsq = (z1-z2)*(z1-z2)

            dist = sqrt(xsq+ysq+zsq)

33          continue

            return 
            end

c----------------------------------------------------
c----------------------------------------------------
            subroutine assv(atom, res, radd)
            character*3 res,atom



          if(atom.eq.'CA ')then
          radd = 1.91
          endif

          if(atom.eq.'C  ')then
          radd = 1.91
          endif

          if(atom.eq.'O  ')then
          radd = 1.66
          endif

          if(atom.eq.'OXT')then
          radd = 1.66
          endif

          if(atom.eq.'N  ')then
          radd = 1.82
          endif 

          if(atom.eq.'H  ')then
          radd = 0.60
          endif

          if(atom.eq.'HA ')then
          radd = 1.39
          endif


          if(atom.eq.'CB ')then
          radd = 1.91
          endif


          if(res.eq.'ALA')then
          if(atom.eq.'HB ')then
          radd = 1.49
          endif
          endif



          if(res.eq.'ILE')then
      
          if(atom.eq.'HB ')then
          radd = 1.49
          endif

          if(atom.eq.'CG1')then
          radd = 1.91
          endif

          if(atom.eq.'HG1')then
          radd = 1.49
          endif

          if(atom.eq.'CG2')then
          radd = 1.91
          endif

          if(atom.eq.'HG2')then
          radd = 1.49
          endif

          if(atom.eq.'CD1')then
          radd = 1.91
          endif

          if(atom.eq.'HD1')then
          radd = 1.49
          endif

          endif




          if(res.eq.'LEU')then

          if(atom.eq.'HB ')then 
          radd = 1.49
          endif

          if(atom.eq.'CG ')then
          radd = 1.91
          endif

          if(atom.eq.'HG ')then
          radd = 1.49
          endif

          if(atom.eq.'CD1')then
          radd = 1.91
          endif

          if(atom.eq.'CD2')then
          radd = 1.91
          endif

          if(atom.eq.'HD1')then
          radd = 1.49
          endif

          if(atom.eq.'HD2')then
          radd = 1.49
          endif

          endif
          


          if(res.eq.'VAL')then

          if(atom.eq.'HB ')then
          radd = 1.49
          endif

          if(atom.eq.'CG1')then
          radd = 1.91
          endif

          if(atom.eq.'HG1')then
          radd = 1.49
          endif

          if(atom.eq.'CG2')then
          radd = 1.91
          endif

          if(atom.eq.'HG2')then
          radd = 1.49
          endif

          endif



          if(res.eq.'SER')then

          if(atom.eq.'HB ')then
          radd = 1.39
          endif

          if(atom.eq.'OG ')then
          radd = 1.72
          endif
 
          if(atom.eq.'HG ')then
          radd = 0.000
          endif

          endif



         if(res.eq.'CYS')then

         if(atom.eq.'HB ')then
         radd = 1.39
         endif

         if(atom.eq.'SG ')then
         radd = 2.000
         endif

         if(atom.eq.'HG ')then
         radd = 0.6000
         endif

         endif



         if(res.eq.'THR')then
         
         if(atom.eq.'HB ')then
         radd = 1.39
         endif

         if(atom.eq.'OG1')then
         radd = 1.72
         endif

         if(atom.eq.'HG1')then
         radd = 0.000
         endif

         if(atom.eq.'CG2')then
         radd = 1.91
         endif

         if(atom.eq.'HG2')then
         radd = 1.49
         endif

         endif
         


         if(res.eq.'MET')then
         
         if(atom.eq.'HB ')then
         radd = 1.49
         endif

         if(atom.eq.'CG ')then
         radd = 1.91
         endif

         if(atom.eq.'HG ')then
         radd = 1.39
         endif

         if(atom.eq.'SD ')then
         radd = 2.000
         endif

         if(atom.eq.'CE ')then
         radd = 1.91
         endif

         if(atom.eq.'HE ')then
         radd = 1.39
         endif

         endif



         if(res.eq.'PRO')then
         
         if(atom.eq.'HB ')then
         radd = 1.49
         endif

         if(atom.eq.'CG ')then
         radd = 1.91
         endif

         if(atom.eq.'HG ')then
         radd = 1.49
         endif

         if(atom.eq.'CD ')then
         radd = 1.91
         endif
 
         if(atom.eq.'HD ')then
         radd = 1.39
         endif

         endif



         if(res.eq.'ASP')then
  
         if(atom.eq.'HB ')then
         radd = 1.49
         endif

         if(atom.eq.'CG ')then
         radd = 1.91
         endif

         if(atom.eq.'OD1')then
         radd = 1.66
         endif

         if(atom.eq.'OD2')then
         radd = 1.66
         endif

         endif
  

       
         if(res.eq.'GLU')then
    
         if(atom.eq.'HB ')then
         radd = 1.49
         endif

         if(atom.eq.'CG ')then
         radd = 1.91
         endif

         if(atom.eq.'HG ')then
         radd = 1.49
         endif

        if(atom.eq.'CD ')then
        radd = 1.91
        endif

        if(atom.eq.'OE1')then
        radd = 1.66
        endif

       if(atom.eq.'OE2')then
       radd = 1.66
       endif

       endif



       if(res.eq.'GLN')then

       if(atom.eq.'HB ')then
       radd = 1.49
       endif

       if(atom.eq.'CG ')then
       radd = 1.91
       endif

       if(atom.eq.'HG ')then
       radd = 1.49
       endif

       if(atom.eq.'CD ')then
       radd = 1.91
       endif

       if(atom.eq.'OE1')then
       radd = 1.66
       endif

       if(atom.eq.'NE2')then
       radd = 1.82
       endif

       if(atom.eq.'HE2')then
       radd = 0.6000
       endif

       endif



       if(res.eq.'ASN')then

       if(atom.eq.'HB ')then
       radd = 1.49
       endif

       if(atom.eq.'CG ')then
       radd = 1.91
       endif

       if(atom.eq.'OD1')then
       radd = 1.66
       endif

       if(atom.eq.'ND2')then
       radd = 1.82
       endif

       if(atom.eq.'HD2')then
       radd = 0.60
       endif

       endif


       if(res.eq.'ARG')then

       if(atom.eq.'HB ')then
       radd = 1.49
       endif

       if(atom.eq.'CG ')then
       radd = 1.91
       endif

       if(atom.eq.'HG ')then
       radd = 1.49
       endif

       if(atom.eq.'CD ')then
       radd = 1.91
       endif

       if(atom.eq.'HD ')then
       radd = 1.39
       endif

       if(atom.eq.'NE ')then
       radd = 1.82
       endif

       if(atom.eq.'HE ')then
       radd = 0.60
       endif

       if(atom.eq.'CZ ')then
       radd = 1.91
       endif

       if(atom.eq.'NH1')then
       radd = 1.82
       endif

       if(atom.eq.'HH1')then
       radd = 0.60
       endif

       if(atom.eq.'NH2')then
       radd = 1.82
       endif

       if(atom.eq.'HH2')then
       radd = 0.60
       endif

       endif
      

       if(res.eq.'LYS')then

       if(atom.eq.'HB ')then
       radd = 1.49
       endif

       if(atom.eq.'CG')then
       radd = 1.91
       endif

       if(atom.eq.'HG ')then
       radd = 1.49
       endif

       if(atom.eq.'CD ')then
       radd = 1.91
       endif

       if(atom.eq.'HD ')then
       radd = 1.49
       endif

       if(atom.eq.'CE ')then
       radd = 1.91
       endif

       if(atom.eq.'HE ')then
       radd = 1.10
       endif

       if(atom.eq.'NZ ')then
       radd = 1.88
       endif

       if(atom.eq.'HZ ')then
       radd = 0.60
       endif

       endif



       if(res.eq.'PHE')then

       if(atom.eq.'HB ')then
       radd = 1.49
       endif

       if(atom.eq.'CG ')then
       radd = 1.91
       endif

       if(atom.eq.'CD1')then
       radd = 1.91
       endif

       if(atom.eq.'CD2')THEN
       radd = 1.91
       endif

       if(atom.eq.'HD1')then
       radd = 1.46
       endif

       if(atom.eq.'HD2')then
       radd = 1.46
       endif

       if(atom.eq.'CE1')then
       radd = 1.91
       endif

       if(atom.eq.'CE2')then
       radd = 1.91
       endif

       if(atom.eq.'HE1')then
       radd = 1.46
       endif

       if(atom.eq.'HE2')then
       radd = 1.46
       endif

       if(atom.eq.'CZ ')then
       radd = 1.91
       endif

       if(atom.eq.'HZ ')then
       radd = 1.46
       endif

       endif



       if(res.eq.'TYR')then

       if(atom.eq.'HB ')then
       radd = 1.49
       endif

       if(atom.eq.'CG ')then
       radd = 1.91
       endif

       if(atom.eq.'CD1')then
       radd = 1.91
       endif

       if(atom.eq.'CD2')then
       radd = 1.91
       endif

       if(atom.eq.'HD1')then
       radd = 1.46
       endif

       if(atom.eq.'HD2')then
       radd = 1.46
       endif

       if(atom.eq.'CE1')then
       radd = 1.91
       endif

       if(atom.eq.'CE2')then
       radd = 1.91
       endif

       if(atom.eq.'HE1')then
       radd = 1.46
       endif

       if(atom.eq.'HE2')then
       radd = 1.46
       endif

       if(atom.eq.'CZ ')then
       radd = 1.91
       endif

       if(atom.eq.'OH ')THEN
       radd = 1.72
       endif

       if(atom.eq.'HH ')then
       radd = 0.000
       endif

       endif


       if(res.eq.'TRP')then

       if(atom.eq.'HB ')then
       radd = 1.49
       endif

       if(atom.eq.'CG ')then
       radd = 1.91
       endif

       if(atom.eq.'CD1')then
       radd = 1.91
       endif

       if(atom.eq.'CD2')then
       radd = 1.91
       endif

       if(atom.eq.'HD1')then
       radd = 1.41
       endif

       if(atom.eq.'NE1')then
       radd = 1.82
       endif

       if(atom.eq.'CE2')then
       radd = 1.91
       endif

       if(atom.eq.'CE3')then
       radd = 1.91
       endif

       if(atom.eq.'HE1')then
       radd = 0.60
       endif

       if(atom.eq.'HE3')then
       radd = 1.46
       endif

       if(atom.eq.'CZ2')then
       radd = 1.91
       endif

      if(atom.eq.'CZ3')then
      radd = 1.91
      endif

      if(atom.eq.'HZ2')then
      radd = 1.46
      endif

      if(atom.eq.'HZ3')then
      radd = 1.46
      endif

      if(atom.eq.'CH2')then
      radd = 1.91
      endif

      if(atom.eq.'HH2')then
      radd = 1.46
      endif

      endif


      if(res.eq.'HIS')then

      if(atom.eq.'HB ')then
      radd = 1.49
      endif

      if(atom.eq.'CG ')then
      radd = 1.91
      endif

      if(atom.eq.'ND1')then
      radd = 1.82
      endif

      if(atom.eq.'CD2')then
      radd = 1.91
      endif

      if(atom.eq.'HD1')then
      radd = 0.60
      endif

      if(atom.eq.'HD2')then
      radd = 1.41
      endif

      if(atom.eq.'CE1')then
      radd = 1.91
      endif

      if(atom.eq.'NE2')then
      radd = 1.82
      endif
 
      if(atom.eq.'HE1')then
      radd = 1.36
      endif

      if(atom.eq.'HE2')then
      radd = 0.60
      endif

      endif

        return 
        end
c----------------------------------------------------------
c----------------------------------------------------------
c----------------------------------------------------------
        subroutine  dotcal(iat,xcen,ycen,zcen,radii,nto,noda,n2)

          dimension xcon(25),ycon(25),zcon(25),rada(25),icon(25)

          common/surf/xdotco(15,3000),ydotco(15,3000),zdotco(15,3000)
          common/norm/xnor(15,3000),ynor(15,3000),znor(15,3000)
          common/spec/radco(15), notco(15)
          character*3  atom
          common/ato/atom(20000)
          common/coord/x(20000),y(20000),z(20000),ass(20000)
          common/connect/iconn(20000,50)
          common/atom/dotx(3000),doty(3000),dotz(3000)
          common/atnor/dotnx(3000),dotny(3000),dotnz(3000)
          common/istat/istatus(3000,3),istatrem(1000)


          do   79   j = 1,3000
          dotx(j) = 0.0
          doty(j) = 0.0
          dotz(j) = 0.0
          dotnx(j) = 0.0
          dotny(j) = 0.0
          dotnz(j) = 0.0
          istatus(j,1) = 0
          istatus(j,2) = 0
          istatus(j,3) = 0
79        continue



          ict = 0

          do   15  i = 1, 25

          if(ass(iconn(iat,i)).eq.0)goto 15

          if(iconn(iat,i).ne.0)then
          ict = ict + 1

          xcon(ict) = x( iconn(iat,i) )
          ycon(ict) = y( iconn(iat,i) )
          zcon(ict) = z( iconn(iat,i) )
          rada(ict) = ass( iconn(iat,i) )
          icon(ict) = iconn(iat,i)
          endif
15        continue


          do   17   j = 1,15
         
          if(radco(j).eq.0)goto 17
 
          if( radii.eq.radco(j) )then

          nto = notco(j)

          
          do   20   k = 1, notco(j)

          dotx(k) =  xdotco(j,k) + xcen
          doty(k) =  ydotco(j,k) + ycen
          dotz(k) =  zdotco(j,k) + zcen        


          dotnx(k) =  xnor(j,k)
          dotny(k) =  ynor(j,k)
          dotnz(k) =  znor(j,k)
               
20        continue

          endif

17        continue

      
             do   25    k = 1, nto

                 itemper = 0                
 
                 do   29    j = 1,ict

          call  caldist(xcon(j),ycon(j),zcon(j),
     *dotx(k),doty(k),dotz(k),distt)

          if(distt.lt.rada(j))then
          istatus(k,1) = 0
          istatus(k,2) = 0
          istatus(k,3) = 0
          goto 25
          endif
       
          if((distt.eq.rada(j)).and.(itemper.eq.0))then
          istatus(k,2) = iat
          istatus(k,3) = icon(j)

          if( (atom(iat).eq.'HA ').or. 
     *        (atom(iat).eq.'N  ').or.
     *        (atom(iat).eq.'CA ').or.
     *        (atom(iat).eq.'C  ').or.
     *        (atom(iat).eq.'O  ').or.
     *        (atom(iat).eq.'H  ') ) then
               ista = 1
               else
               ista = 2
               endif

           if( (atom(icon(j)).eq.'HA ').or.
     *         (atom(icon(j)).eq.'N  ').or.
     *         (atom(icon(j)).eq.'CA ').or.
     *         (atom(icon(j)).eq.'C  ').or.
     *         (atom(icon(j)).eq.'O  ').or.
     *         (atom(icon(j)).eq.'H  ') )then
               bista = 1
               else
               bista = 2
               endif

               if(ista.ne.bista)then
               itemper = 1
               endif 


          endif

          if((distt.gt.rada(j)).and.(istatus(k,3).eq.0))then
          istatus(k,2) = iat
          istatus(k,3) = 0
          endif

29        continue
  

25        continue

          noda = 0    
 
          do  37    j = 1,nto
          if( (istatus(j,2).ne.0) )then
          noda = noda +1
          endif
          if(istatus(j,3).ne.0)then
          n2 = n2 +1
          endif
37        continue 


          return
          end
c---------------------------------------------------------
c---------------------------------------------------------
c---------------------------------------------------------
