      program tlod

!======================================
!     computes CS_l
!======================================

      open(unit=1,file='lod.inp',status='old')

671   format(i3)

!===================== Penalties ===============
      pen1 = 25.0     ! CP1
      pen2 = 20.0     ! CP2
      pen3 = 15.0     ! CP3
!===============================================

34    format(f10.5,2x,i3,2x,i3)
79    format(f12.5)

      Nt1 = 0
      Nt2 = 0
      Nt3 = 0

      w1 = 0.0
      w2 = 0.0
      w3 = 0.0

      b1lod2 = 0.0
      b2lod2 = 0.0
      b3lod2 = 0.0

      frac1 = 0.0
      frac2 = 0.0
      frac3 = 0.0

      read(1,34,end=30)c1,Nz1,Nt1
      frac1 = float(Nz1)/float(Nt1)
      b1lod2 = c1-(pen1*frac1)

      read(1,34,end=30)c2,Nz2,Nt2
      frac2 = float(Nz2)/float(Nt2)      
      b2lod2 = c2-(pen2*frac2)

      read(1,34,end=30)c3,Nz3,Nt3
      frac3 = float(Nz3)/float(Nt3)
      b3lod2 = c3-(pen3*frac3)

30    continue

      Ntot = Nt1 + Nt2 + Nt3

!==============burail weight============================
      w1 = float(Nt1)/float(Ntot)   ! CP1
      w2 = float(Nt2)/float(Ntot)   ! CP2
      w3 = float(Nt3)/float(Ntot)   ! CP3
!=======================================================

      Flod2 = (w1*b1lod2) + (w2*b2lod2) + (w3*b3lod2)

!===========================
! Empirical baseline, K=5.0 
!===========================

      Flod2 = Flod2 + 5.0   
      write(*,189)Flod2

179   format(3f12.5)
189   format(f12.5)


      endprogram tlod
