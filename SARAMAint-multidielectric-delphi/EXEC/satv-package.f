c       program to do actual surface complementarity calculations !!!
c       SIDE-CHAIN SURFACE POINTS VERSUS THE ENTIRE NEIGHBOURHOOD
C       WITH CUT-OFF AND ACCOUNTING OF POINTS FOR BOTH BURIED AND TARGET RESIDUE.

!=====================================================================
!   MODIFIED FOR PACKAGE
!   reads target.res and calculates for a single target residue at a time
!   RUNS UNDER A PERL SCRIPT
!   AND ONLY PRINTS OUT Sm (all,sc,mc)
!   AVOID PAIRWISE CALCULATIONS
!=====================================================================

        common/coords/x(995,5000),y(995,5000),z(995,5000)
        common/dir/dl(995,5000),dm(995,5000),dn(995,5000)
        common/itype1/itype(995,5000)
        character*3 ato
        common/ata/ato(995,5000) 
        character*3 res
        character*3 resb
        character*3 res1
        character*1 chain,chn1,chn
        common/identity/ires(995),res(995),ino(995),inc
     *,ing,inm,chn(995)
        common/bury/iresb(995),resb(995),frac(995)
        common/control/itot,irmin,iatmin,dmin
        common/trial/fun1(5000)
        common/results1/sc1(5000),sct(5000),scs(5000),
     *scm(5000)
        common/resultsf/sut,sus,sum1,smeda(995),
     *smeda1(995)
        common/map1/indxs(5000),irems(5000),iams(5000),das(995),
     *imap(995)
        common/map2/indxs1(5000),irems1(5000),iams1(5000),
     *das1(995),imap1(995)
        dimension rtem(995),atem(995),iuni(995),dfac(995),dasum(995)
        dimension rtem1(995),atem1(995),iuni1(995),dfac1(995),damum(995)
        dimension incs(995),incm(995),datot(995),intot(995)
        character*3 atoms1,targres
        character*3 ress1
        character*3 atoms2
        character*3 ress2
        common/cys/atoms1(50),ress1(50),iress1(50),atoms2(50),ress2(50)
     *,iress2(50)
        common/cys1/isno
        dimension damt(5000),dams(5000),damm(5000)  

 
        do  903   i=1,995
        ino(i)=0
        dasum(i)=0.0
        damum(i)=0.0
        datot(i)=0.0
        incs(i)=0
        incm(i)=0
        intot(i)=0
903     continue

        open(unit=1,file='bury.out',status='old')
        open(unit=2,file='bury.scrt',status='old')
        open(unit=13,file='target.res',status='old')
        open(unit=14,file='numM.res',status='old')

        read(14,111)irtot
111     format(i3)

10      read(2,20)irt,irb
20      format(1x,i6,i6)

!        print*,irt,irtot

        do 15  i=1,irb
        read(1,17)iresb(i),resb(i),frac(i)
17      format(5x,i5,5x,a3,5x,9x,5x,f9.2)
15      continue

        open(unit=3,file='surf_out',status='old')
        open(unit=4,file='sucal1.out',status='new')

        open(unit=5,file='sg.con',status='old')
        open(unit=6,file='sg.out',status='old')

        read(13,154)itargres,targres,chain

154     format(i3,1x,a3,1x,a1)

        read(5,923)isno
923     format(i6)
        
        if(isno.eq.0)then
        goto 927
        endif

        do  926   iss = 1,isno
        read(6,929)atoms1(iss),ress1(iss),iress1(iss),
     *atoms2(iss),ress2(iss),iress2(iss)
929     format(a3,2x,a3,2x,i3,5x,a3,2x,a3,2x,i3)
926     continue

927     continue

        itot=0

c       READING IN THE DATA !!!!!!!!!!!!!
c=====================================================
c=====================================================
c=====================================================

        do  25 i=1,irtot
        itot=itot+1
        read(3,40,end=25)res1,ires1,ino1,chn1
!        write(8,40)res1,ires1,ino1,chn1
40      format(5x,a3,2x,i6,2x,i6,2x,a1)

        res(itot)=res1
        ires(itot)=ires1
        ino(itot)=ino1
        chn(itot)=chn1

        do  37  j=1,ino(itot)
        read(3,45)x(itot,j),y(itot,j),z(itot,j),
     *dl(itot,j),dm(itot,j),dn(itot,j),itype(itot,j),ato(itot,j)
!        write(8,45)x(itot,j),y(itot,j),z(itot,j),
!     *dl(itot,j),dm(itot,j),dn(itot,j),itype(itot,j),ato(itot,j)
45      format(2x,3f8.3,2x,3f8.3,1x,i3,2x,a3)
37      continue

25      continue
c----------------------------------------------------------------
c----------------------------------------------------------------
c----------------------------------------------------------------
c---------------------------------------------------------------

          do  763  ij = 1,itot
                do  764  ik = 1,ino(ij)
          intot(ij)=intot(ij)+1
          if(itype(ij,ik).eq.2)then
          incs(ij)=incs(ij)+1
          endif
          if((itype(ij,ik).eq.1).or.(itype(ij,ik).eq.3))then
          incm(ij)=incm(ij)+1
          endif
764             continue
763       continue

c     THE CALCULATIONS START HERE !!!!!!!!!

          do   50    i=1,itot
          
          if(res(i).eq.'GLY')goto 50

c***************************************************************

          if((res(i).eq.targres).and.(ires(i)==itargres)) then
          goto 774
          endif

          goto 50

774       continue

c*************************************************************


          inc=0
          ing=0
          inm=0
          dami=0.0
          dasi=0.0
          dasm=0.0

         do 55 k=1,irt
         if(ires(i).eq.iresb(k))then
         irsk=k
         goto 57
         endif
55       continue

56       goto 50

57       continue


          do 70 j=1,ino(i)         
          if(itype(i,j).eq.3)goto 70
          if(itype(i,j).eq.1)goto 70

              inc=inc+1


          call  distmin(i,j)
          call  surface(i,j)
          sct(inc)=sc1(j)
          damt(inc)=dmin

!         CUT OFF ON NEAREST NEIGHBOR

          if(dmin.lt.3.50)then

          if(itype(irmin,iatmin).eq.2)then
          ing=ing+1
          indxs(ing)=j
          irems(ing) = irmin
          iams(ing) = iatmin
          scs(ing)=sc1(j)
          dams(ing)=dmin
          endif

          if((itype(irmin,iatmin).eq.1).or.
     *(itype(irmin,iatmin).eq.3))then
          inm=inm+1
          indxs1(inm)=j
          irems1(inm) = irmin
          iams1(inm) = iatmin
          scm(inm)=sc1(j)
          damm(inm)=dmin
          endif

          endif
    
70        continue

          d1=0.0
          if(inc.eq.0)then
          d1av=-1.00
          else
          do 5515 iw =1,inc 
          d1=d1+damt(iw)
5515      continue 
          d1av=d1/float(inc)
          endif

          d2=0.0
          if(ing.eq.0)then
          d2av=-1.00
          else
          do 5514 iw =1,ing 
          d2=d2+dams(iw)
5514      continue 
          d2av=d2/float(ing)
          endif

          d3=0.0
          if(inm.eq.0)then
          d3av=-1.00
          else
          do 5513 iw =1,inm 
          d3=d3+damm(iw)
5513      continue 
          d3av=d3/float(inm)
          endif

          call final(i,1)

          if(ing.eq.0)then
          sus=-9.0
          goto 72
          endif

          call final(i,2)

72        continue

         if(inm.eq.0)then
          sum1=-9.0
          goto 75
          endif

         call final(i,3)   

75        continue

c      WRITING   OUT THE RESULTS !!!!!!!!!!
c=============================================================
c=============================================================
c=============================================================
c=============================================================a

          ins1=0
          inm1=0
          
          do 239 is= 1,itot 
          if(imap(is).ne.0)then
          ins1=ins1+1
          endif  
          if(imap1(is).ne.0)then
          inm1=inm1+1
          endif
239       continue 

!===============================================================
!================ Readjust Extremities =========================
!================ For exposed residues =========================
!===============================================================

          if (sut <= -1.00)then
          sut = -1.00
          endif
          if (sus <= -1.00)then
          sus = -1.00
          endif
          if (sum1 <= -1.00)then
          sum1 = -1.00
          endif
          
          write(4,588)ires(i),res(i),frac(irsk),sut,sus,sum1,chn(i)


88        format(1x,i5,1x,a3,1x,f7.3,1x,i5,1x,i5,3(1x,f7.3))
588       format(i3,1x,a3,2x,f4.2,3(1x,f8.3),2x,a1)
188       format(1x,i5,1x,i5,1x,i5,1x,i5,1x,f7.3,1x,f7.3,1x,f7.3)
288       format(1x,f9.3,1x,f9.3,1x,f9.3,1x,f9.3,1x,f7.3,f7.3,f7.3)
388       format(3(1x,i6))
488       format(2x,3f10.5)

551       format(/)

108       format(1x,i4,1x,a3,1x,i5,1x,f7.3,1x,f7.3,1x,
     *3i5,i5)

660       continue

113        format(///)
c==============================================================
c==============================================================
c==============================================================
c==============================================================
50        continue
c==============================================================
c==============================================================
c==============================================================
c==============================================================

            stop
            end
c*************************************************************
c*************************************************************
c*************************************************************

        subroutine   distmin(ir,ia)
        common/coords/x(995,5000),y(995,5000),z(995,5000)
        character*3 res
        character*1 chn 
        common/control/itot,irmin,iatmin,dmin
        common/identity/ires(995),res(995),ino(995),inc
     *,ing,inm,chn(995)
        common/itype1/itype(995,5000) 
        character*3 ato
        common/ata/ato(995,5000)
        character*3 atoms1
        character*3 ress1
        character*3 atoms2
        character*3 ress2
        common/cys/atoms1(50),ress1(50),iress1(50),atoms2(50),ress2(50),
     *iress2(50)
        common/cys1/isno

c       INITIALISING !!!!!!!!!!

        dmin=999.0
        irmin=0
        iatmin=0


        do   101   i=1,itot
        if(ires(i).eq.ires(ir))goto 101


c*************************************************
c*************************************************
c   TAKING CARE OF DISULPHIDE BRIDGES
c*************************************************
c*************************************************

         if(isno.eq.0)then
         goto 487
         endif         

         do  489  isg=1,isno

         if( (ires(ir).eq.iress1(isg)).and.
     *(ires(i).eq.iress2(isg)) )then
         goto 101 
         endif

         if( (ires(ir).eq.iress2(isg)).and.
     *(ires(i).eq.iress1(isg)) )then
         goto 101
         endif

489      continue

487      continue
c************************************************
c************************************************
c************************************************

        do 102 j=1,ino(i)

        xt=x(ir,ia)-x(i,j)
        if(abs(xt).gt.dmin)goto 102

        yt=y(ir,ia)-y(i,j)
        if(abs(yt).gt.dmin)goto 102

        zt=z(ir,ia)-z(i,j)
        if(abs(zt).gt.dmin)goto 102

        dist=sqrt(xt*xt+yt*yt+zt*zt)

        if(dist.gt.dmin)goto 102

        irmin=i
        iatmin=j
        dmin=dist

102     continue
101     continue

        return
        end
c**********************************************************
c**********************************************************
c**********************************************************       

        subroutine   surface(ir,ia)

        common/coords/x(995,5000),y(995,5000),z(995,5000)
        common/dir/dl(995,5000),dm(995,5000),dn(995,5000)
        common/control/itot,irmin,iatmin,dmin
        common/results1/sc1(5000),sct(5000),scs(5000),scm(5000)

        x1n2 = -dl(ir,ia)*dl(irmin,iatmin)
     *-dm(ir,ia)*dm(irmin,iatmin)
     *-dn(ir,ia)*dn(irmin,iatmin)

        sc1(ia)=x1n2*exp(-0.5*dmin*dmin)

        return
        end
c***********************************************************
c***********************************************************
c***********************************************************
c***********************************************************

        subroutine   final(ir,ik)

        character*3  res
        common/identity/ires(995),res(995),ino(995),inc
     *,ing,inm
        common/trial/fun1(5000)
        common/results1/sc1(5000),sct(5000),scs(5000),
     *scm(5000)
        common/resultsf/sut,sus,sum1,
     *smeda(995),smeda1(995)  

        do  201   i=1,5000
        fun1(i)=0.0
201     continue

        if(ik.eq.1)then
        do  205  i = 1,inc
        fun1(i)=sct(i)
205     continue
        irun=inc
        if(irun.eq.1)then
        sut=sct(1)
        goto 410
        endif
        endif

        if(ik.eq.2)then
        do  206   i = 1,ing
        fun1(i)=scs(i)
206     continue
        irun=ing
        if(irun.eq.1)then
        sus=scs(1)
        goto 410
        endif
        endif

        if(ik.eq.3)then
        do  207  i = 1,inm
        fun1(i)=scm(i)
207     continue
        irun=inm
        if(irun.eq.1)then
        sum1=scm(1)
        goto 410
        endif
        endif

        call bubble(ir,ik)

        div=float(irun)/2.0
        idiv=ifix(irun/2.0)
        diva=float(idiv)

        if(div.eq.diva)then
        sini=( fun1(irun/2) + fun1((irun/2)+1) )/2.0
        endif


        if(div.gt.diva)then
        sini=fun1( (irun+1)/2 )
        endif


        if(ik.eq.1)then
        sut=sini
        endif

        if(ik.eq.2)then
        sus=sini
        endif

        if(ik.eq.3)then
        sum1=sini
        endif

410     continue

        return
        end
c**************************************************************
c**************************************************************
c**************************************************************
c**************************************************************

         subroutine   bubble(ir,ik)

        character*3  res
        common/identity/ires(995),res(995),ino(995),inc
     *,ing,inm
        common/trial/fun1(5000)


        if(ik.eq.1)then
        nn=inc
        endif

        if(ik.eq.2)then
        nn=ing
        endif

        if(ik.eq.3)then
        nn=inm
        endif


        do   301  j=1,nn
        net=nn-j
        if(net.eq.1)goto 356

        do 302  i=1,net

        if(fun1(i).gt.fun1(i+1))then
        tm11=fun1(i)
        tm12=fun1(i+1)
        fun1(i)=tm12
        fun1(i+1)=tm11
        endif

302     continue

301     continue

356     continue

        if(fun1(1).gt.fun1(2))then
        t11=fun1(1)
        t12=fun1(2)
        fun1(1)=t12
        fun1(2)=t11
        endif

        return
        end

