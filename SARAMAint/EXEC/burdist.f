      program burdist

!=============================================
!  Distribute (Sm,Em) profile into burial bins
!=============================================

      character(80)::sfile,efile
      real::Small(995),Emall(995)
      real::Smsc(995),Emsc(995),S1(995),S2(995),S3(995)
      real::Smmc(995),Emmc(995),E1(995),E2(995),E3(995)
      real::bur(995),bur1(995),bur2(995)
      integer::ires(995),ires1(995),ires2(995)
      character(3)::res(995),res1(995),res2(995)
      character(1)::chain1(995),chain2(995),chain(995)

      call getarg(1,sfile)
      call getarg(2,efile)

78    format(a80)

      open (1,file=sfile,status='old')
      open (2,file=efile,status='old')

      ic = 0

      ic1 = 0
      ic2 = 0
      do i = 1,995
      read(1,41,end=30)ires1(i),res1(i),bur1(i),S1(i),S2(i),S3(i),
     &chain1(i)
      ic1 = ic1 + 1
      enddo
30    continue



      do i = 1,995
      read(2,42,end=40)ires2(i),res2(i),bur2(i),E1(i),E2(i),E3(i),
     &chain2(i)
      ic2 = ic2 + 1
      enddo

40    continue


      do i = 1,ic1
           do j = 1,ic2
            if (ires1(i)==ires2(j).and.res1(i).eq.res2(j).
     &and.chain1(i).eq.chain2(j).
     &and.res1(i).ne.'GLY')then
                if (bur1(i) == bur2(j) .and. bur1(i) <= 0.30)then
                ic = ic + 1
                ires(ic) = ires1(i)
                res(ic) = res1(i)
                chain(ic) = chain1(i)
                bur(ic) = bur1(i)
                Small(ic) = S1(i)
                Smsc(ic) = S2(i)
                Smmc(ic) = S3(i)
                Emall(ic) = E1(j)
                Emsc(ic) = E2(j)
                Emmc(ic) = E3(j)
                write(512,67)ires(ic),res(ic),bur(ic),Smsc(ic),Emsc(ic),
     &chain(ic)
                    if (bur(ic) <= 0.05)then
                    write(513,67)ires(ic),res(ic),bur(ic),Smsc(ic),
     &Emsc(ic),chain(ic)
                    elseif (bur(ic) > 0.05 .and. bur(ic) <= 0.15)then
                    write(514,67)ires(ic),res(ic),bur(ic),Smsc(ic),
     &Emsc(ic),chain(ic)
                    elseif (bur(ic) > 0.15 .and. bur(ic) <= 0.30)then
                    write(515,67)ires(ic),res(ic),bur(ic),Smsc(ic),
     &Emsc(ic),chain(ic)
                    endif
                endif
            endif
            enddo
      enddo


!      write(*,819)'Number of completely or partially buried residues:',
!     &ic

819   format(a50,2x,i3)

41    format(i3,1x,a3,2x,f4.2,3(1x,f8.3),2x,a1)
42    format(i3,1x,a3,5x,f4.2,5x,3f8.3,1x,a1)
67    format(i3,1x,a3,2x,f4.2,2f8.3,2x,a1)
     
      endprogram burdist
