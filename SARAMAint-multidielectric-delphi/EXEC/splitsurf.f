      program splitsurf

!     Split vdW surface into individual residue patches 
!     Also create the complementary surface patches (rest of the entire protein)

      character(80)::surffile,resfile,sfile,scfile
      integer::irest(995)
      character(3)::rest(995),res,r3
      character(1)::rt1(995),chn(995),chain,ch
      character(3)::aa3(19)
      character(1)::aa1(19)
      character(3)::ci
      character(60)::fline

      call getarg (1,surffile)   ! in pdb format (****_surf.pdb)
      call getarg (2,resfile)    ! *.res file 

      open (unit=1,file=surffile,status='old')
      open (unit=2,file=resfile,status='old')

      aa3 = (/'ALA','VAL','LEU','ILE','PHE','TYR','TRP','SER',
     &'THR','CYS','MET','ASP','GLU','ASN','GLN','LYS','ARG','PRO',
     &'HIS'/)
      aa1 = (/'A','V','L','I','F','Y','W','S','T','C','M','D','E',
     &'N','Q','K','R','P','H'/)

      ic = 0

9     read(2,34,end=30)ir3,r3,chain
            if (r3.ne.'GLY')then
            ic = ic + 1
            rest(ic) = r3
            irest(ic) = ir3
            chn(ic) = chain
            goto 20 
            endif
20    continue
            do i = 1,19
                 if (rest(ic).eq.aa3(i))then
                 rt1(ic) = aa1(i)
                 endif
            enddo
!      write(*,67)irest(ic),rest(ic),ic,rt1(ic)
      goto 9
30    continue
 
!      print*, ic

34    format(i3,1x,a3,1x,a1)

67    format(i3,2x,a3,2x,i3,2x,a1)

      do i = 1,ic
      write(ci,12)irest(i)
      iflagR = 0
           if (rest(i).eq.'GLY')then
           goto 40
           endif
              do ir = 1,19
                 if (rest(i).eq.aa3(ir))then
                 iflagR = 1
                 endif
              enddo
           if (iflagR==0)then
           goto 40
           endif
12    format(i3)
      ci = adjustl(ci)
      sfile = rt1(i)//trim(ci)//chn(i)//'s.pdb'
!      write(*,68)sfile
      open (unit=3,file=sfile,status='new')

10       read(1,43,end=40)fline
         read(fline,44)res,ch,ires             
             if (ires == irest(i).and.res.eq.rest(i)
     &.and.chn(i).eq.ch)then 
             write(3,43)fline
             else
             endif
         goto 10
40       continue
      rewind(1)     
      close(3)
      enddo

68    format(a20)
43    format(a60)
44    format(17x,a3,1x,a1,1x,i3)


      endprogram splitsurf
   
