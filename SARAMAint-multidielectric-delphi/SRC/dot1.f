c     PROGRAM TO CALCULATE POINTS ON THE SURFACE OF A  SPHERE

      common/surface/xdot(2500),ydot(2500),zdot(2500)
      common/normal/xnor(2500),ynor(2500),znor(2500)
      common/const/pi
      dimension  dtht(5),nobst(5),arcc(5)
      dimension  radin(15)
      open(unit=1, file='sphere.dot', status='new')
      open(unit=2, file='num.out', status = 'new' ) 
      open(unit=3, file='dot.inp',status = 'old')
c---------------------------------------------------
      pi= acos(-1.00)
      idensity = 10
c--------------------------------------------------

       do   93    i = 1, 15
       read(3,97,end=93) radin(i)
97     format(f5.2)
93     continue



      do  59    jj = 1,15

      if(radin(jj).eq.0)then
      num00 = 0
      goto 51 
      endif

      ncal = ifix(float(idensity)*4.0*pi*radin(jj)*radin(jj))

      do    71   i=1,5
      dtht(i)=0
      nobst(i)=0
71    continue    




      do  61    ii = 1, 50000

      dth =  1.00 + float(ii-1) * 0.020
      if(dth.gt.180.0) then
      goto 9
      endif

      Call angcheck(dth,radin(jj),nobs,arc)

      if(nobs.eq.ncal)then
      dtht(1)  = dth
      nobst(1) = nobs
      arcc(1)  = arc 
      endif

      if( (nobs.eq.ncal+1).or.(nobs.eq.ncal-1) )then
      dtht(2)  = dth
      nobst(2) = nobs
      arcc(2) =  arc       
      endif

      if( (nobs.eq.ncal+2).or.(nobs.eq.ncal-2) )then
      dtht(3)  = dth
      nobst(3) = nobs
      arcc(3)  = arc
      endif

      if( (nobs.eq.ncal+3).or.(nobs.eq.ncal-3) )then
      dtht(4)  = dth
      nobst(4) = nobs
      arcc(4)  = arc
      endif

      if( (nobs.eq.ncal+4).or.(nobs.eq.ncal-4) )then
      dtht(5)  = dth
      nobst(5) = nobs
      arcc(5)  = arc  
      endif
61    continue

9     continue   


        do  77  i = 1,5
        if(dtht(i).ne.0)then
        write(2,39)radin(jj),dtht(i),arcc(i),nobst(i),ncal
39      format(5x,f5.2,5x,f5.2,2x,f5.2,i6,2x,i6)
        call  dotcal(dtht(i),radin(jj),nf,arcf)
        if(nf.ne.nobst(i))then
        goto 100
        endif
        goto 107
        endif
77      continue


107    continue



51     if(radin(jj).eq.0)then
       xnumt = 0.0
       write(1,53)radin(jj),num00
       write(2,54)radin(jj),xnumt,xnumt,num00,num00
54     format(5x,f5.2,5x,f5.2,2x,f5.2,i6,2x,i6)
       goto 59
       endif 

       write(1,53)radin(jj),nf
53     format(5x,f5.2,5x,i6)
       do  55   j= 1, nf
       write(1,57)xdot(j),ydot(j),zdot(j),xnor(j),ynor(j),znor(j)
57     format(6f10.4)
55     continue


59     continue

       goto 102
100    continue
       write(2,101)
101    format('THERE IS SOME PROBLEM')
102    continue


       stop
       end
c---------------------------------------------
c---------------------------------------------
c---------------------------------------------
      Subroutine   angcheck(dtheta,radius,npoints,arc)

      common/const/pi
      npoints = 0 

      arc= (pi*dtheta*radius)/180.0

      do 10 i=1,50000

      if( (float((i-1))*dtheta).gt.180 )then
      goto 13
      endif


      theta =  ( (i-1)*dtheta*pi )/180.0

      if(theta.eq.0)then
      npoints = npoints + 1
      goto 10
      endif
     
      if(theta.eq.pi)then
      npoints = npoints + 1
      goto 10
      endif

      phi=arc/(radius*sin(theta))
      circum= 2.0*pi*radius*sin(theta)
      

      do  30  j=1,5000
      if( (circum.lt.arc).and.(j.eq.1) )then
      npoints = npoints + 1
      goto 10
      endif
      if(circum.lt.j*arc)then
      goto 10
      endif
      npoints = npoints + 1
30    continue

10    continue

13    continue

      return
      end
c----------------------------------------------------
c----------------------------------------------------
c----------------------------------------------------
       subroutine dotcal(dtheta,radius,nobser,arc)

       common/surface/xdot(2500),ydot(2500),zdot(2500)
       common/normal/xnor(2500),ynor(2500),znor(2500)
       common/const/pi


       do  103   i =1,2500
       xdot(i) = 0.0
       ydot(i) = 0.0
       zdot(i) = 0.0
       xnor(i) = 0.0
       ynor(i) = 0.0
       znor(i) = 0.0
      
103    continue




      arc= (pi*dtheta*radius)/180.0
      nobser =0

      do 10 i=1,50000

      if( (float((i-1))*dtheta).gt.180 )then
      goto 13
      endif


      theta =  ( (i-1)*dtheta*pi )/180.0

      if(theta.eq.0)then
      nobser = nobser +1
      xdot(nobser)=0.000
      ydot(nobser)=0.000
      zdot(nobser)=radius
      xnor(nobser)=0.000
      ynor(nobser)=0.000
      znor(nobser)=1.000
      goto 10
      endif
     
      if(theta.eq.pi)then
      nobser = nobser +1
      xdot(nobser)=0.00
      ydot(nobser)=0.00
      zdot(nobser)=-radius
      xnor(nobser)= 0.000
      ynor(nobser)= 0.000
      znor(nobser)=-1.000
      goto 10
      endif

      phi=arc/(radius*sin(theta))
      circum= 2.0*pi*radius*sin(theta)
      

      do  30  j=1,5000
      if( (circum.lt.arc).and.(j.eq.1) )then
      nobser = nobser +1
      xdot(nobser)= radius*sin(theta)
      ydot(nobser)= 0.000
      zdot(nobser)= radius*cos(theta)
      val = sqrt(xdot(nobser)*xdot(nobser)
     * + ydot(nobser)*ydot(nobser)
     * + zdot(nobser)*zdot(nobser) )
      xnor(nobser) = xdot(nobser)/val
      ynor(nobser) = ydot(nobser)/val
      znor(nobser) = zdot(nobser)/val
      goto 10
      endif

      if(circum.lt.j*arc)then
      goto 10
      endif

      nobser = nobser + 1
      xdot(nobser)= radius*sin(theta)*cos(j*phi)
      ydot(nobser)= radius*sin(theta)*sin(j*phi)
      zdot(nobser)= radius*cos(theta)
      xnor(nobser) = sin(theta)*cos(j*phi)
      ynor(nobser) = sin(theta)*sin(j*phi)
      znor(nobser) = cos(theta)
30    continue

10    continue

13    continue

       return
       end
c--------------------------------------------
c--------------------------------------------
c--------------------------------------------

