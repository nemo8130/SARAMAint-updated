      program transform

!=====================================================
!     Give appropriate linear transformations to the (Sm, Em) values 
!     [Y = mX + C] in order to generate postscripts for CPs
!=====================================================

      character(80)::ifile
      call getarg(1,ifile)

      open(1,file=ifile,status='old')

9     read(1,23,end=30)ires,x,y
      xn = 300+(200*x)
      yn = 300+(200*y)
      write(9,45)ires,xn,yn
      goto 9

30    continue

23    format(i3,10x,2(2x,f6.3))
45    format(i3,2x,f8.3,2x,f8.3)


      endprogram transform
