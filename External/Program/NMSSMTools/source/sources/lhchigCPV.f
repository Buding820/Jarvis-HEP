      SUBROUTINE LHC_HIGGS_CPV(PROB)

***********************************************************************
*   Subroutine to check Higgs LHC constraints:
*      PROB(45) =/= 0: Bound on Br(t->bH+)*BR(H+->tau nu)
*      PROB(46) =/= 0:  No Higgs in the MHmin-MHmax GeV range
*      PROB(51) =/= 0: excluded by ggF/bb->H/A->tautau
*      PROB(52) =/= 0: Excluded H_125->AA->4mu
***********************************************************************

      IMPLICIT NONE

      INTEGER I,I1,J,J1,NHGG1,NHGG2,NHGG3
      INTEGER JBAR,JBARbb,K,K1,K2,K3,NX,NA13,NC13
      PARAMETER(NX=18,NA13=14,NC13=28)

      DOUBLE PRECISION PROB(*)
      DOUBLE PRECISION HMAS(NX),LCMS(NX),LCMSbb(NX)
      DOUBLE PRECISION LATLAS(NX),LATLASbb(NX)
      DOUBLE PRECISION HCMS13(NC13),LCMS13(NC13),LCMSbb13(NC13)
      DOUBLE PRECISION HATLAS13(NA13),LATLAS13(NA13),LATLASbb13(NA13)
      DOUBLE PRECISION MH(5),LCMSH(5),SIG1(5),LATLASH(5)
      DOUBLE PRECISION LCMSHbb(5),SIGbb(5),LATLASHbb(5)
      DOUBLE PRECISION DEL,SIGTOT,MBAR,LCMSMB,LATLASMB
      DOUBLE PRECISION SIGTOTbb,MBARbb,LCMSMBbb,LATLASMBbb
      DOUBLE PRECISION D1,MHcen,masstest,TBH
      DOUBLE PRECISION agg,bgg,cgg,mugcengg,muvcengg,SSIG(6)
      DOUBLE PRECISION abb,bbb,cbb,mugcenbb,muvcenbb
      DOUBLE PRECISION azz,bzz,czz,mugcenzz,muvcenzz
      DOUBLE PRECISION BRJJSM,BREESM,BRMMSM,BRLLSM,BRCCSM
      DOUBLE PRECISION BRBBSM,BRTTSM,BRWWSM,BRZZSM,BRGGSM,BRZGSM
      DOUBLE PRECISION HGG1(300,2),HGG2(300,2),HGG3(300,2)
      DOUBLE PRECISION MHC,XC(2,2),MH0(5),XH(5,5),MA2
      DOUBLE PRECISION CU(5),CUP(5),CD(5),CDP(5),CB(5),CBP(5),CJ(5),
     . CJP(5),CI(5),CG(5),CGP(5),CV(5),CZG(5),CZGP(5),CL(5),CLP(5)
      DOUBLE PRECISION BRJJ(5),BREE(5),BRMM(5),BRLL(5),
     . BRCC(5),BRBB(5),BRTT(5),BRWW(5),BRZZ(5),BRGG(5),BRZG(5)
      DOUBLE PRECISION BRHHH(5,10),BRHCHC(5),BRHAZ(5,4),BRHCW(5),
     . BRHIGGS(5)
      DOUBLE PRECISION BRNEU(5,5,5),BRCHA(5,3),BRHSQ(5,10),BRHSL(5,7),
     . BRSUSY(5)
      DOUBLE PRECISION brtopbw,brtopbh,brtopneutrstop(5,2)
      DOUBLE PRECISION HCBRM,HCBRL,HCBRSU,HCBRBU,HCBRSC,HCBRBC,HCBRBT
      DOUBLE PRECISION MHmin,MHmax
      DOUBLE PRECISION SIG(5,8),muH2,ggF8,ggF13,bbH8,bbH13,SHGG,LHGG
      DOUBLE PRECISION C(7),CMIN(7),CMAX(7)

      COMMON/HISPEC/MHC,XC,MH0,XH,MA2
      COMMON/HNSMCOUP/CU,CUP,CD,CDP,CB,CBP,CJ,CJP,CI,CG,CGP,CV,CZG,CZGP,
     . CL,CLP
      COMMON/HNSMBR/BRJJ,BREE,BRMM,BRLL,BRCC,BRBB,BRTT,BRWW,BRZZ,
     . BRGG,BRZG
      COMMON/HNHIBR/BRHHH,BRHCHC,BRHAZ,BRHCW,BRHIGGS
      COMMON/HNSUSYBR/BRNEU,BRCHA,BRHSQ,BRHSL,BRSUSY
      COMMON/BR_top2body/brtopbw,brtopbh,brtopneutrstop
      COMMON/HCSMBR/HCBRM,HCBRL,HCBRSU,HCBRBU,HCBRSC,HCBRBC,HCBRBT
      COMMON/HIGGSFIT/MHmin,MHmax
      COMMON/LHCSIGCPV/SIG
      COMMON/HIGGSMS/muH2
      COMMON/LHCHGG/HGG1,HGG2,HGG3,NHGG1,NHGG2,NHGG3

***********************************************************************
* 8 TeV limits
      DATA HMAS/90d0,100d0,120d0,140d0,160d0,180d0,200d0,250d0,300d0,
     . 350d0,400d0,450d0,500d0,600d0,700d0,800d0,900d0,1000d0/

* Upper limit on ggF->H->tautau (8 TeV) from CMS-PAS-HIG-13-021, Tab. 7
      DATA LCMS/50.2d0,31.3d0,7.38d0,2.27d0,.845d0,.549d0,.517d0,.315d0,
     . .15d0,.112d0,.103d0,.607d-1,.385d-1,.193d-1,.143d-1,.115d-1,
     . .923d-2,.865d-2/

* Upper limit on bbH->tautau (8 TeV) from CMS-PAS-HIG-13-021, Tab. 8
      DATA LCMSbb/6.03d0,4.14d0,1.76d0,1.25d0,.814d0,.659d0,.553d0,
     . .217d0,
     . .975d-1,.638d-1,.613d-1,.431d-1,.320d-1,.203d-1,.173d-1,.166d-1,
     . .146d-1,.133d-1/

* Upper limit on ggF->H->tautau (8 TeV) from ATLAS-CONF-2014-049, Fig. 7
      DATA LATLAS/29.1d0,24.0d0,5.25d0,2.02d0,1.39d0,1.00d0,.794d0,
     .  .281d0,.127d0,.112d0,.773d-1,.400d-1,.240d-1,.177d-1,.127d-1,
     .  .993d-2,.840d-2,.735d-2/

* Upper limit on bbH->tautau (8 TeV) from ATLAS-CONF-2014-049, Fig. 7
      DATA LATLASbb/6.32d0,6.32d0,2.73d0,1.27d0,.966d0,.606d0,.393d0,
     .  .305d0,.116d0,.101d0,.656d-1,.363d-1,.238d-1,.159d-1,.117d-1,
     .  .943d-2,.785d-2,.716d-2/

***********************************************************************
* 13 TeV limits
      DATA HATLAS13/2d2,2.5d2,3d2,3.5d2,4d2,5d2,6d2,7d2,8d2,
     . 1d3,1.2d3,1.5d3,2d3,2.25d3/
      DATA HCMS13/9d1,1d2,1.1d2,1.2d2,1.3d2,1.4d2,1.6d2,1.8d2,2d2,
     . 2.5d2,3.5d2,4d2,4.5d2,5d2,6d2,7d2,8d2,9d2,1d3,1.2d3,1.4d3,
     . 1.6d3,1.8d3,2d3,2.3d3,2.6d3,2.9d3,3.2d3/

* Upper limit on ggF->H->tautau (13 TeV) from ATLAS 2002.12223, Fig. 2(a)
      DATA LATLAS13/2.28d-1,1.68d-1,1.65d-1,1.14d-1,8.29d-2,4.95d-2,
     . 1.48d-2,5.07d-3,2.93d-3,1.79d-3,1.58d-3,1.54d-3,1.27d-3,1.16d-3/

* Upper limit on bbH->tautau (13 TeV) from ATLAS 2002.12223, Fig. 2(b)
      DATA LATLASbb13/2.03d-1,1.07d-1,1.18d-1,1.19d-1,7.72d-2,2.85d-2,
     . 7.34d-3,2.45d-3,1.64d-3,1.11d-3,9.58d-4,1.01d-3,1.03d-3,1.02d-3/

* Upper limit on ggF->H->tautau (13 TeV) from CMS 1803.06553, Fig. 7(a)
      DATA LCMS13/1.74d1,2.59d1,1.42d1,8.61d0,4.73d0,2.82d0,1.86d0,
     . 1.30d0,8.29d-1,5.56d-1,1.09d-1,7.43d-2,6.25d-2,5.91d-2,5.01d-2,
     . 3.51d-2,2.47d-2,1.73d-2,1.37d-2,8.93d-3,6.42d-3,4.99d-3,4.43d-3,
     . 4.00d-3,3.74d-3,3.64d-3,3.53d-3,3.40d-3/

* Upper limit on bbH->tautau (13 TeV) from CMS 1803.06553, Fig. 7(b)
      DATA LCMSbb13/1.39d1,7.13d0,7.13d0,5.45d0,3.15d0,2.71d0,1.45d0,
     . 1.05d0,7.86d-1,3.61d-1,5.82d-2,4.38d-2,3.59d-2,3.00d-2,1.44d-2,
     . 8.86d-3,6.03d-3,4.74d-3,3.70d-3,2.90d-3,2.84d-3,2.46d-3,2.41d-3,
     . 2.40d-3,2.16d-3,2.35d-3,2.45d-3,2.48e-3/

***********************************************************************

c       I- Constraints from ggF/bb->H/A->tautau

      PROB(51)=0d0

* Loop over 5 Higgses
      DO I=1,5
        MH(I)=dsqrt(MH0(I))

* 8 TeV limits
        J=1
        DOWHILE(HMAS(J).LE.MH(I) .AND. J.LT.NX)
          J=J+1
        ENDDO
        IF(J.GE.2 .AND. MH(I).LE.HMAS(NX)) THEN

* ggF Signal cross section*BR:
          SIG1(I)=(CJ(I)**2+CJP(I)**2)*BRLL(I)*ggF8(MH(I))

* CMS ggF limit:
          LCMSH(I)=LCMS(J-1)+(MH(I)-HMAS(J-1))/
     .      (HMAS(J)-HMAS(J-1))*(LCMS(J)-LCMS(J-1))
          PROB(51)=PROB(51)+DDIM(SIG1(I)/LCMSH(I),1d0)

* ATLAS ggF limit:
          LATLASH(I)=LATLAS(J-1)+(MH(I)-HMAS(J-1))/
     .      (HMAS(J)-HMAS(J-1))*(LATLAS(J)-LATLAS(J-1))
* Correct for jump in Fig.7 at MA=200 GeV: J=8, 
* modif. LATLAS(J-1)=LATLAS(7)=.96d0 and not .794d0:
          IF(J.EQ.8) THEN
            LATLASH(I)=.96d0+(MH(I)-HMAS(J-1))/
     .        (HMAS(J)-HMAS(J-1))*(LATLAS(J)-.96d0)
          ENDIF
          PROB(51)=PROB(51)+DDIM(SIG1(I)/LATLASH(I),1d0)

* bbH Signal cross section*BR:
          SIGbb(I)=(CB(I)**2+CBP(I)**2)*BRLL(I)*bbH8(MH(I))

* CMS Hbb limit:
          LCMSHbb(I)=LCMSbb(J-1)+(MH(I)-HMAS(J-1))/
     .      (HMAS(J)-HMAS(J-1))*(LCMSbb(J)-LCMSbb(J-1))
          PROB(51)=PROB(51)+DDIM(SIGbb(I)/LCMSHbb(I),1d0)

* ATLAS Hbb limit:
          LATLASHbb(I)=LATLASbb(J-1)+(MH(I)-HMAS(J-1))/
     .      (HMAS(J)-HMAS(J-1))*(LATLASbb(J)-LATLASbb(J-1))
* Correct for jump in Fig.7 at MA=200 GeV: J=8, 
* modif. LATLASbb(J-1)=LATLASbb(7)=.858d0 and not .393d0:
          IF(J.EQ.8) THEN
            LATLASHbb(I)=.858d0+(MH(I)-HMAS(J-1))/
     .        (HMAS(J)-HMAS(J-1))*(LATLASbb(J)-.858d0)
          ENDIF
          PROB(51)=PROB(51)+DDIM(SIGbb(I)/LATLASHbb(I),1d0)

* Combine signal rates of 2 Higgses
          DO I1=1,I-1
            J1=1
            DOWHILE(HMAS(J1).LE.MH(I1) .AND. J1.LT.NX)
              J1=J1+1
            ENDDO
            IF(MH(I1).GE.HMAS(1) .AND. MH(I1).LE.HMAS(NX)) THEN

* Average masses weighted by the signal rates (MBAR for ggF, MBARbb for bbH):
             MBAR=(SIG1(I)*MH(I)+SIG1(I1)*MH(I1))/(SIG1(I)+SIG1(I1))
             JBAR=1
             DOWHILE(HMAS(JBAR).LE.MBAR.AND.JBAR.LT.NX)
               JBAR=JBAR+1
             ENDDO
             MBARbb=(SIGbb(I)*MH(I)
     .         +SIGbb(I1)*MH(I1))/(SIGbb(I)+SIGbb(I1))
             JBARbb=1
             DOWHILE(HMAS(JBARbb).LE.MBARbb.AND.JBARbb.LT.NX)
               JBARbb=JBARbb+1
             ENDDO
* DEL=mass difference divided by a (small) resolution squared:
* [DEL < 1 only if |MH(I)-MH(I1)| < (MH(I)+MH(I1))/15d0;
*  otherwise the combined signal rate is small]
             DEL=((MH(I)-MH(I1))/(MH(I)+MH(I1))*15d0)**2

* Estimate of the combined ggF signal rates:
             SIGTOT=SIG1(I)+SIG1(I1)
     .         -SIG1(I)*SIG1(I1)*DEL/(SIG1(I)+SIG1(I1))
* Continue only if SIGTOT > 0 and 90<MBAR<1000
*      and |MH(I)-MH(I1)|/MBAR<0.20:
             IF(SIGTOT.GT.0d0.AND.MBAR.GE.HMAS(1).AND.
     .         MBAR.LE.HMAS(NX).AND.
     .         dabs(MH(I)-MH(I1))/MBAR.LE.0.20d0) THEN

* CMS ggF limit at MBAR:
               LCMSMB=LCMS(JBAR-1)+(MBAR-HMAS(JBAR-1))/
     .          (HMAS(JBAR)-HMAS(JBAR-1))*(LCMS(JBAR)-LCMS(JBAR-1))
               PROB(51)=PROB(51)+DDIM(SIGTOT/LCMSMB,1d0)

* ATLAS ggF limit at MBAR:
               LATLASMB=LATLAS(JBAR-1)+(MBAR-HMAS(JBAR-1))/
     .          (HMAS(JBAR)-HMAS(JBAR-1))*(LATLAS(JBAR)-LATLAS(JBAR-1))
* Correct for jump in Fig.7 at MA=200 GeV: JBAR=8, 
* modif. LATLAS(JBAR-1)=LATLAS(7)=.96d0 and not .794d0:
               IF(J.EQ.8) THEN
                 LATLASMB=.96d0+(MBAR-HMAS(JBAR-1))/
     .            (HMAS(JBAR)-HMAS(JBAR-1))*(LATLAS(JBAR)-.96d0)
               ENDIF
               PROB(51)=PROB(51)+DDIM(SIGTOT/LATLASMB,1d0)
             ENDIF

* Estimate of the combined bbH signal rates:
             SIGTOTbb=SIGbb(I)+SIGbb(I1)
     .         -SIGbb(I)*SIGbb(I1)*DEL/(SIGbb(I)+SIGbb(I1))
* Continue only if SIGTOTbb > 0 and 90<MBARbb<1000
*      and |MH(I)-MH(I1)|/MBARbb<0.20:
             IF(SIGTOTbb.GT.0d0.AND.MBARbb.GE.HMAS(1).AND.
     .         MBARbb.LE.HMAS(NX).AND.
     .         dabs(MH(I)-MH(I1))/MBARbb.LE.0.20d0) THEN

* CMS bbH limit at MBARbb:
               LCMSMBbb=LCMSbb(JBARbb-1)+(MBARbb-HMAS(JBARbb-1))/
     .           (HMAS(JBARbb)-HMAS(JBARbb-1))*
     .           (LCMSbb(JBARbb)-LCMSbb(JBARbb-1))
               PROB(51)=PROB(51)+DDIM(SIGTOTbb/LCMSMBbb,1d0)

* ATLAS bbH limit at MBARbb:
               LATLASMBbb=LATLASbb(JBARbb-1)+(MBARbb-HMAS(JBARbb-1))/
     .           (HMAS(JBARbb)-HMAS(JBARbb-1))*
     .           (LATLASbb(JBARbb)-LATLASbb(JBARbb-1))
* Correct for jump in Fig.7 at MA=200 GeV: JBARbb=8, 
* modif. LATLASbb(JBARbb-1)=LATLASbb(7)=.858d0 and not .393d0:
               IF(J.EQ.8) THEN
                 LATLASMBbb=.858d0+(MBARbb-HMAS(JBARbb-1))/
     .             (HMAS(JBARbb)-HMAS(JBARbb-1))*
     .             (LATLASbb(JBARbb)-.858d0)
               ENDIF
               PROB(51)=PROB(51)+DDIM(SIGTOTbb/LATLASMBbb,1d0)
             ENDIF
            ENDIF
          ENDDO
        ENDIF


* ATLAS 13 TeV limits
        J=1
        DOWHILE(HATLAS13(J).LE.MH(I) .AND. J.LT.NA13)
          J=J+1
        ENDDO
        IF(J.GE.2 .AND. MH(I).LE.HATLAS13(NA13)) THEN

* ggF Signal cross section*BR:
          SIG1(I)=(CJ(I)**2+CJP(I)**2)*BRLL(I)*ggF13(MH(I))

* ATLAS ggF limit:
          LATLASH(I)=LATLAS13(J-1)+(MH(I)-HATLAS13(J-1))/
     .      (HATLAS13(J)-HATLAS13(J-1))*(LATLAS13(J)-LATLAS13(J-1))
          PROB(51)=PROB(51)+DDIM(SIG1(I)/LATLASH(I),1d0)

* bbH Signal cross section*BR:
          SIGbb(I)=(CB(I)**2+CBP(I)**2)**2*BRLL(I)*bbH13(MH(I))

* ATLAS Hbb limit:
          LATLASHbb(I)=LATLASbb13(J-1)+(MH(I)-HATLAS13(J-1))/
     .      (HATLAS13(J)-HATLAS13(J-1))*(LATLASbb13(J)-LATLASbb13(J-1))
          PROB(51)=PROB(51)+DDIM(SIGbb(I)/LATLASHbb(I),1d0)

* Combine signal rates of 2 Higgses
          DO I1=1,I-1
            J1=1
            DOWHILE(HATLAS13(J1).LE.MH(I1) .AND. J1.LT.NA13)
              J1=J1+1
            ENDDO
            IF(MH(I1).GE.HATLAS13(1) .AND. MH(I1).LE.HATLAS13(NA13))THEN

* Average masses weighted by the signal rates (MBAR for ggF, MBARbb for bbH):
             MBAR=(SIG1(I)*MH(I)+SIG1(I1)*MH(I1))/(SIG1(I)+SIG1(I1))
             JBAR=1
             DOWHILE(HATLAS13(JBAR).LE.MBAR .AND. JBAR.LT.NA13)
               JBAR=JBAR+1
             ENDDO
             MBARbb=(SIGbb(I)*MH(I)
     .         +SIGbb(I1)*MH(I1))/(SIGbb(I)+SIGbb(I1))
             JBARbb=1
             DOWHILE(HATLAS13(JBARbb).LE.MBARbb .AND. JBARbb.LT.NA13)
               JBARbb=JBARbb+1
             ENDDO
* DEL=mass difference divided by a (small) resolution squared:
* [DEL < 1 only if |MH(I)-MH(I1)| < (MH(I)+MH(I1))/15d0;
*  otherwise the combined signal rate is small]
             DEL=((MH(I)-MH(I1))/(MH(I)+MH(I1))*15d0)**2

* Estimate of the combined ggF signal rates:
             SIGTOT=SIG1(I)+SIG1(I1)
     .         -SIG1(I)*SIG1(I1)*DEL/(SIG1(I)+SIG1(I1))
* Continue only if SIGTOT > 0 and 200<MBAR<2250
*      and |MH(I)-MH(I1)|/MBAR<0.20:
             IF(SIGTOT.GT.0d0.AND.MBAR.GE.HATLAS13(1).AND.
     .         MBAR.LE.HATLAS13(NA13).AND.
     .         dabs(MH(I)-MH(I1))/MBAR.LE.0.20d0) THEN

* ATLAS ggF limit at MBAR:
               LATLASMB=LATLAS13(JBAR-1)+(MBAR-HATLAS13(JBAR-1))/
     .          (HATLAS13(JBAR)-HATLAS13(JBAR-1))*
     .          (LATLAS13(JBAR)-LATLAS13(JBAR-1))
               PROB(51)=PROB(51)+DDIM(SIGTOT/LATLASMB,1d0)
             ENDIF

* Estimate of the combined bbH signal rates:
             SIGTOTbb=SIGbb(I)+SIGbb(I1)
     .         -SIGbb(I)*SIGbb(I1)*DEL/(SIGbb(I)+SIGbb(I1))
* Continue only if SIGTOTbb > 0 and 200<MBARbb<2250
*      and |MH(I)-MH(I1)|/MBARbb<0.20:
             IF(SIGTOTbb.GT.0d0.AND.MBARbb.GE.HATLAS13(1).AND.
     .         MBARbb.LE.HATLAS13(NA13).AND.
     .         dabs(MH(I)-MH(I1))/MBARbb.LE.0.20d0) THEN

* ATLAS bbH limit at MBARbb:
               LATLASMBbb=LATLASbb13(JBARbb-1)+
     .           (MBARbb-HATLAS13(JBARbb-1))/
     .           (HATLAS13(JBARbb)-HATLAS13(JBARbb-1))*
     .           (LATLASbb13(JBARbb)-LATLASbb13(JBARbb-1))
               PROB(51)=PROB(51)+DDIM(SIGTOTbb/LATLASMBbb,1d0)
             ENDIF
            ENDIF
          ENDDO
        ENDIF


* CMS 13 TeV limits
        J=1
        DOWHILE(HCMS13(J).LE.MH(I) .AND. J.LT.NC13)
          J=J+1
        ENDDO
        IF(J.GE.2 .AND. MH(I).LE.HCMS13(NC13)) THEN

* ggF Signal cross section*BR:
          SIG1(I)=(CJ(I)**2+CJP(I)**2)*BRLL(I)*ggF13(MH(I))

* CMS ggF limit:
          LCMSH(I)=LCMS13(J-1)+(MH(I)-HCMS13(J-1))/
     .      (HCMS13(J)-HCMS13(J-1))*(LCMS13(J)-LCMS13(J-1))
          PROB(51)=PROB(51)+DDIM(SIG1(I)/LCMSH(I),1d0)

* bbH Signal cross section*BR:
          SIGbb(I)=(CB(I)**2+CBP(I)**2)**2*BRLL(I)*bbH13(MH(I))

* CMS Hbb limit:
          LCMSHbb(I)=LCMSbb13(J-1)+(MH(I)-HCMS13(J-1))/
     .      (HCMS13(J)-HCMS13(J-1))*(LCMSbb13(J)-LCMSbb13(J-1))
          PROB(51)=PROB(51)+DDIM(SIGbb(I)/LCMSHbb(I),1d0)

* Combine signal rates of 2 Higgses
          DO I1=1,I-1
            J1=1
            DOWHILE(HCMS13(J1).LE.MH(I1) .AND. J1.LT.NC13)
              J1=J1+1
            ENDDO
            IF(MH(I1).GE.HCMS13(1) .AND. MH(I1).LE.HCMS13(NC13))THEN

* Average masses weighted by the signal rates (MBAR for ggF, MBARbb for bbH):
             MBAR=(SIG1(I)*MH(I)+SIG1(I1)*MH(I1))/(SIG1(I)+SIG1(I1))
             JBAR=1
             DOWHILE(HCMS13(JBAR).LE.MBAR .AND. JBAR.LT.NC13)
               JBAR=JBAR+1
             ENDDO
             MBARbb=(SIGbb(I)*MH(I)
     .         +SIGbb(I1)*MH(I1))/(SIGbb(I)+SIGbb(I1))
             JBARbb=1
             DOWHILE(HCMS13(JBARbb).LE.MBARbb .AND. JBARbb.LT.NC13)
               JBARbb=JBARbb+1
             ENDDO
* DEL=mass difference divided by a (small) resolution squared:
* [DEL < 1 only if |MH(I)-MH(I1)| < (MH(I)+MH(I1))/15d0;
*  otherwise the combined signal rate is small]
             DEL=((MH(I)-MH(I1))/(MH(I)+MH(I1))*15d0)**2

* Estimate of the combined ggF signal rates:
             SIGTOT=SIG1(I)+SIG1(I1)
     .         -SIG1(I)*SIG1(I1)*DEL/(SIG1(I)+SIG1(I1))
* Continue only if SIGTOT > 0 and 90<MBAR<3200
*      and |MH(I)-MH(I1)|/MBAR<0.20:
             IF(SIGTOT.GT.0d0.AND.MBAR.GE.HCMS13(1).AND.
     .         MBAR.LE.HCMS13(NC13).AND.
     .         dabs(MH(I)-MH(I1))/MBAR.LE.0.20d0) THEN

* CMS ggF limit at MBAR:
               LCMSMB=LCMS13(JBAR-1)+(MBAR-HCMS13(JBAR-1))/
     .          (HCMS13(JBAR)-HCMS13(JBAR-1))*
     .          (LCMS13(JBAR)-LCMS13(JBAR-1))
               PROB(51)=PROB(51)+DDIM(SIGTOT/LCMSMB,1d0)
             ENDIF

* Estimate of the combined bbH signal rates:
             SIGTOTbb=SIGbb(I)+SIGbb(I1)
     .         -SIGbb(I)*SIGbb(I1)*DEL/(SIGbb(I)+SIGbb(I1))
* Continue only if SIGTOTbb > 0 and 90<MBARbb<3200
*      and |MH(I)-MH(I1)|/MBARbb<0.20:
             IF(SIGTOTbb.GT.0d0.AND.MBARbb.GE.HCMS13(1).AND.
     .         MBARbb.LE.HCMS13(NC13).AND.
     .         dabs(MH(I)-MH(I1))/MBARbb.LE.0.20d0) THEN

* CMS bbH limit at MBARbb:
               LCMSMBbb=LCMSbb13(JBARbb-1)+
     .           (MBARbb-HCMS13(JBARbb-1))/
     .           (HCMS13(JBARbb)-HCMS13(JBARbb-1))*
     .           (LCMSbb13(JBARbb)-LCMSbb13(JBARbb-1))
               PROB(51)=PROB(51)+DDIM(SIGTOTbb/LCMSMBbb,1d0)
             ENDIF
            ENDIF
          ENDDO
        ENDIF

      ENDDO

c        II- Bound on Br(t->bH+)*BR(H+->tau nu)

      PROB(45)=DDIM(brtopbh*HCBRL/TBH(dsqrt(MHC)),1d0)

c        III- Constraints from ggF->H/A->gamgam

      PROB(53)=0d0

* Loop over 5 Higgses
      DO I=1,5
        MH(I)=DSQRT(MH0(I))

* CMS 8 TeV limit:
        J=1
        DOWHILE(HGG1(J,1).LE.MH(I) .AND. J.LT.NHGG1)
          J=J+1
        ENDDO
        IF(J.GT.1 .AND. MH(I).LE.HGG1(NHGG1,1)) THEN
          LHGG=HGG1(J-1,2)+(MH(I)-HGG1(J-1,1))/
     .     (HGG1(J,1)-HGG1(J-1,1))*(HGG1(J,2)-HGG1(J-1,2))
          SHGG=(CJ(I)**2+CJP(I)**2)*BRGG(I)*ggF8(MH(I))
          PROB(53)=PROB(53)+DDIM(SHGG/LHGG,1d0)
        ENDIF

* CMS 13 TeV limit:
        J=1
        DOWHILE(HGG2(J,1).LE.MH(I) .AND. J.LT.NHGG2)
          J=J+1
        ENDDO
        IF(J.GT.1 .AND. MH(I).LE.HGG2(NHGG2,1)) THEN
          LHGG=HGG2(J-1,2)+(MH(I)-HGG2(J-1,1))/
     .     (HGG2(J,1)-HGG2(J-1,1))*(HGG2(J,2)-HGG2(J-1,2))
          SHGG=(CJ(I)**2+CJP(I)**2)*BRGG(I)*ggF13(MH(I))
          PROB(53)=PROB(53)+DDIM(SHGG/LHGG,1d0)
        ENDIF

* ATLAS 13 TeV limit:
        J=1
        DOWHILE(HGG3(J,1).LE.MH(I) .AND. J.LT.NHGG3)
          J=J+1
        ENDDO
        IF(J.GT.1 .AND. MH(I).LE.HGG3(NHGG3,1)) THEN
          LHGG=HGG3(J-1,2)+(MH(I)-HGG3(J-1,1))/
     .     (HGG3(J,1)-HGG3(J-1,1))*(HGG3(J,2)-HGG3(J-1,2))
          SHGG=(CJ(I)**2+CJP(I)**2)*BRGG(I)*ggF13(MH(I))
          PROB(53)=PROB(53)+DDIM(SHGG/LHGG,1d0)
        ENDIF
      ENDDO

c       IV- Higgs test at ~125 GeV

c      1) Data

* From J. Bernon with run-II data (sep. 2016):

c Chi^2 from gammagamma:
      agg=17.47d0
      bgg=3.17d0
      cgg=6.26d0
      mugcengg=1.18d0
      muvcengg=1.07d0

c Chi^2 from bb/tautau:
      abb=4.81d0
      bbb=2.69d0
      cbb=21.57d0
      mugcenbb=1.27d0
      muvcenbb=0.86d0

c Chi^2 from ZZ/WW:
      azz=36.40d0
      bzz=4.56d0
      czz=8.16d0
      mugcenzz=1.11d0
      muvcenzz=1.37d0

c      2) Higgs signals / SM

      DO I=1,5

       DO J=1,8
        SIG(I,J)=0d0
       ENDDO

       CALL HDECAY(dsqrt(MH0(I)),BRJJSM,BREESM,BRMMSM,BRLLSM,
     .      BRCCSM,BRBBSM,BRTTSM,BRWWSM,BRZZSM,BRGGSM,BRZGSM)

*   H -> tautau
* VBF/VH
       IF(BRLLSM.NE.0d0)SIG(I,1)=CV(I)**2*BRLL(I)/BRLLSM
* ggF
       IF(BRLLSM.NE.0d0)SIG(I,2)=(CJ(I)**2+CJP(I)**2)*BRLL(I)/BRLLSM
       
*   H -> bb
* VBF/VH
       IF(BRBBSM.NE.0d0)SIG(I,3)=CV(I)**2*BRBB(I)/BRBBSM
* ttH
       IF(BRBBSM.NE.0d0)SIG(I,4)=(CU(I)**2+CUP(I)**2)*BRBB(I)/BRBBSM

*   H -> ZZ/WW
* VBF/VH
       IF(BRZZSM.NE.0d0)SIG(I,5)=CV(I)**2*BRZZ(I)/BRZZSM
* ggF
       IF(BRZZSM.NE.0d0)SIG(I,6)=(CJ(I)**2+CJP(I)**2)*BRZZ(I)/BRZZSM
       
*   H -> gammagamma
* VBF/VH
       IF(BRGGSM.NE.0d0)SIG(I,7)=CV(I)**2*BRGG(I)/BRGGSM
* ggF
       IF(BRGGSM.NE.0d0)SIG(I,8)=(CJ(I)**2+CJP(I)**2)*BRGG(I)/BRGGSM

      ENDDO

c      3) masstest

      MHcen=(MHmin+MHmax)/2d0
      D1=(MHmax-MHmin)/2d0
      masstest=dabs(dsqrt(MH0(1))-MHcen)/D1
      K=0
      K1=0
      K2=0
      K3=0
      J=1

      DO I=1,6
       SSIG(I)=0d0
      ENDDO

      DO I=1,5
      masstest=min(masstest,dabs(dsqrt(MH0(I))-MHcen)/D1)
       IF(dabs(dsqrt(MH0(I))-MHcen).le.D1)THEN
        if(K.eq.2)then
         K3=I
         K=3
        endif
        if(K.eq.1)then
         K2=I
         K=2
        endif
        if(K.eq.0)then
         K1=I
         K=1
        endif
       ELSE
        if(K.eq.0.and.I.gt.1)then
         if(dabs(dsqrt(MH0(I))-MHcen)
     .  .lt.dabs(dsqrt(MH0(I-1))-MHcen))J=I
        endif
       ENDIF
      ENDDO

      IF(masstest.gt.1d0)PROB(46)=masstest-1d0

c      4) kappas(H_SM) and BR(H_SM -> BSM)

      CMIN(1)=0.933d0 ! electroweak couplings
      CMAX(1)=1.000d0 
      CMIN(2)=0.841d0 ! top quark
      CMAX(2)=1.161d0
      CMIN(3)=0.655d0 ! b quark
      CMAX(3)=0.917d0
      CMIN(4)=0.810d0 ! gluons
      CMAX(4)=1.022d0
      CMIN(5)=0.896d0 ! photons
      CMAX(5)=1.055d0
      CMIN(6)=0.788d0 ! taus
      CMAX(6)=0.984d0
      CMIN(7)=0.000d0 ! BR_BSM
      CMAX(7)=0.157d0

      IF(K.EQ.0)THEN
       C(1)=CV(J)
       C(2)=DSQRT(CU(J)**2+CUP(J)**2)
       C(3)=DSQRT(CB(J)**2+CBP(J)**2)
       C(4)=DSQRT(CJ(J)**2+CJP(J)**2)
       C(5)=DSQRT(CG(J)**2+CGP(J)**2)
       C(6)=DSQRT(CL(J)**2+CLP(J)**2)
       C(7)=BRHIGGS(J)+BRSUSY(J)
      ELSE
       C(1)=CV(K1)
       C(2)=DSQRT(CU(K1)**2+CUP(K1)**2)
       C(3)=DSQRT(CB(K1)**2+CBP(K1)**2)
       C(4)=DSQRT(CJ(K1)**2+CJP(K1)**2)
       C(6)=DSQRT(CL(K1)**2+CLP(K1)**2)
       C(5)=DSQRT(CG(K1)**2+CGP(K1)**2)
       C(7)=BRHIGGS(K1)+BRSUSY(K1)
       IF(K.GE.2)THEN
        IF(CV(K2)**2.GT.C(1)**2)THEN
         C(1)=CV(K2)
         C(2)=DSQRT(CU(K2)**2+CUP(K2)**2)
         C(3)=DSQRT(CB(K2)**2+CBP(K2)**2)
         C(4)=DSQRT(CJ(K2)**2+CJP(K2)**2)
         C(5)=DSQRT(CG(K2)**2+CGP(K2)**2)
         C(6)=DSQRT(CL(K2)**2+CLP(K2)**2)
         C(7)=BRHIGGS(K2)+BRSUSY(K2)
        ENDIF
        IF(K.EQ.3 .AND. CV(K3)**2.GT.C(1)**2)THEN
         C(1)=CV(K3)
         C(2)=DSQRT(CU(K3)**2+CUP(K3)**2)
         C(3)=DSQRT(CB(K3)**2+CBP(K3)**2)
         C(4)=DSQRT(CJ(K3)**2+CJP(K3)**2)
         C(5)=DSQRT(CG(K3)**2+CGP(K3)**2)
         C(6)=DSQRT(CL(K3)**2+CLP(K3)**2)
         C(7)=BRHIGGS(K3)+BRSUSY(K3)
        ENDIF
       ENDIF
      ENDIF

      PROB(67)=-DDIM(1d0,C(1)/CMIN(1))
      DO I=2,6
       PROB(66+I)=DDIM(C(I)/CMAX(I),1d0)-DDIM(1d0,C(I)/CMIN(I))
      ENDDO
      PROB(73)=DDIM(C(7)/CMAX(7),1d0)

c        V- Constraints from HSM->HH->leptons

      CALL HSM_AA_LEPTONS_CPV(PROB)

c        VI- Constraints from HSM->HH->photons

      CALL HSM_AA_PHOTONS_CPV(PROB)

c        VII- Constraints from HSM->ZH

      CALL HSM_ZA_CPV(PROB)

c        VIII- Constraints from H->toptop

      CALL HEAVYH_TOPTOP_CPV(PROB)

c        IX- Constraints from H->ZHSM->bb

      CALL HEAVYH_ZHSM_bb_CPV(PROB)

c        X- Constraints from H->ZH

      CALL HEAVYH_ZH_CPV(PROB)

c        XI- Constraints from H->HH

      CALL HEAVYH_HSMH_CPV(PROB)

c        XII- Constraints from H->HSMHSM

      CALL HEAVYH_HSMHSM_CPV(PROB)

      END


      SUBROUTINE HEAVYH_TOPTOP_CPV(PROB)

* Constraints from H/A->toptop from 1908.01115 (CMS)
* PROB(75) =/= 0: excluded by H/A->toptop

      IMPLICIT NONE

      INTEGER I,J,N1,N2
      PARAMETER(N1=15,N2=18)

      DOUBLE PRECISION PROB(*)
      DOUBLE PRECISION MHC,XC(2,2),MH0(5),XH(5,5),MA2
      DOUBLE PRECISION BRJJ(5),BREE(5),BRMM(5),BRLL(5),
     . BRCC(5),BRBB(5),BRTT(5),BRWW(5),BRZZ(5),BRGG(5),BRZG(5)
      DOUBLE PRECISION BRHHH(5,10),BRHCHC(5),BRHAZ(5,4),BRHCW(5),
     . BRHIGGS(5)
      DOUBLE PRECISION WIDTH(5),HCWIDTH
      DOUBLE PRECISION CU(5),CUP(5),CD(5),CDP(5),CB(5),CBP(5),CJ(5),
     . CJP(5),CI(5),CG(5),CGP(5),CV(5),CZG(5),CZGP(5),CL(5),CLP(5)
      DOUBLE PRECISION HM1(N1),HM2(N2),LH,LA,L1,L2,MH,RW
      DOUBLE PRECISION LH1(N1),LH2(N1),LH3(N1),LH4(N1),LH5(N2),LH6(N2)
      DOUBLE PRECISION LA1(N1),LA2(N1),LA3(N1),LA4(N1),LA5(N2),LA6(N2)

      COMMON/HISPEC/MHC,XC,MH0,XH,MA2
      COMMON/HNSMBR/BRJJ,BREE,BRMM,BRLL,BRCC,BRBB,BRTT,BRWW,BRZZ,
     . BRGG,BRZG
      COMMON/HNHIBR/BRHHH,BRHCHC,BRHAZ,BRHCW,BRHIGGS
      COMMON/HIWIDTH/WIDTH,HCWIDTH
      COMMON/HNSMCOUP/CU,CUP,CD,CDP,CB,CBP,CJ,CJP,CI,CG,CGP,CV,CZG,CZGP,
     . CL,CLP

      DATA HM1/400d0,425d0,450d0,475d0,500d0,525d0,550d0,575d0,600d0,
     .625d0,650d0,675d0,700d0,725d0,750d0/
      DATA HM2/400d0,425d0,450d0,475d0,500d0,525d0,550d0,575d0,600d0,
     .625d0,650d0,675d0,700d0,725d0,735d0,740d0,745d0,750d0/
      DATA LH1/0.845d0,0.715d0,0.695d0,0.655d0,0.655d0,0.705d0,0.715d0,
     .0.705d0,0.635d0,0.615d0,0.625d0,0.705d0,0.785d0,0.875d0,0.935d0/
      DATA LH2/1.055d0,0.885d0,0.855d0,0.795d0,0.785d0,0.845d0,0.855d0,
     .0.865d0,0.765d0,0.735d0,0.735d0,0.825d0,0.935d0,1.045d0,1.115d0/
      DATA LH3/1.375d0,1.155d0,1.085d0,0.985d0,0.965d0,1.045d0,1.075d0,
     .1.125d0,0.965d0,0.905d0,0.865d0,0.955d0,1.095d0,1.305d0,1.425d0/
      DATA LH4/1.655d0,1.365d0,1.185d0,1.165d0,1.105d0,1.185d0,1.255d0,
     .1.275d0,1.285d0,1.225d0,1.135d0,1.135d0,1.345d0,1.625d0,1.755d0/
      DATA LH5/2.135d0,1.655d0,1.325d0,1.185d0,1.135d0,1.195d0,1.295d0,
     .1.335d0,1.285d0,1.225d0,1.115d0,1.115d0,1.045d0,1.055d0,0.995d0,
     .0.985d0,0.975d0,1.005d0/
      DATA LH6/2.585d0,2.085d0,1.665d0,1.655d0,1.545d0,1.595d0,1.655d0,
     .1.585d0,1.495d0,1.405d0,1.415d0,1.455d0,1.425d0,1.345d0,1.295d0,
     .1.285d0,1.245d0,1.265d0/
      DATA LA1/0.595d0,0.565d0,0.575d0,0.565d0,0.545d0,0.535d0,0.585d0,
     .0.585d0,0.585d0,0.555d0,0.575d0,0.605d0,0.685d0,0.775d0,0.825d0/
      DATA LA2/0.735d0,0.695d0,0.695d0,0.695d0,0.655d0,0.635d0,0.725d0,
     .0.715d0,0.725d0,0.675d0,0.705d0,0.725d0,0.815d0,0.935d0,1.015d0/
      DATA LA3/0.925d0,0.865d0,0.865d0,0.865d0,0.815d0,0.765d0,0.915d0,
     .0.935d0,0.955d0,0.885d0,0.885d0,0.875d0,0.995d0,1.205d0,1.325d0/
      DATA LA4/1.095d0,1.025d0,1.035d0,1.005d0,0.875d0,0.975d0,1.115d0,
     .1.175d0,1.215d0,1.085d0,1.055d0,1.045d0,1.245d0,1.545d0,1.615d0/
      DATA LA5/1.325d0,1.195d0,1.135d0,1.055d0,0.975d0,0.995d0,1.175d0,
     .1.325d0,1.385d0,1.325d0,1.355d0,1.515d0,1.055d0,0.985d0,0.995d0,
     .0.975d0,0.955d0,1.025d0/
      DATA LA6/1.825d0,1.785d0,1.625d0,1.675d0,1.525d0,1.495d0,1.605d0,
     .1.685d0,1.745d0,1.675d0,1.535d0,1.585d0,1.645d0,1.545d0,1.505d0,
     .1.435d0,1.475d0,1.335d0/

      PROB(75)=0d0

      DO J=1,5
       MH=dsqrt(MH0(I))
       RW=WIDTH(J)/MH

       IF(MH.GE.HM1(1).AND.MH.LT.HM1(N1))THEN

        IF(RW.LE.0.5d-2)THEN

         I=1
         DOWHILE(HM1(I).LE.MH)
          I=I+1
         ENDDO
         LH=LH1(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LH1(I)-LH1(I-1))
         LA=LA1(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LA1(I)-LA1(I-1))
         PROB(75)=PROB(75)+DDIM(DABS(CU(J))/LH,1d0)
     .                    +DDIM(DABS(CUP(J))/LA,1d0)

        ELSEIF(RW.LE.1d-2)THEN

         I=1
         DOWHILE(HM1(I).LE.MH)
          I=I+1
         ENDDO
         L1=LH1(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LH1(I)-LH1(I-1))
         L2=LH2(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LH2(I)-LH2(I-1))
         LH=L1+(RW-0.5d-2)/0.5d-2*(L2-L1)
         L1=LA1(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LA1(I)-LA1(I-1))
         L2=LA2(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LA2(I)-LA2(I-1))
         LA=L1+(RW-0.5d-2)/0.5d-2*(L2-L1)
         PROB(75)=PROB(75)+DDIM(DABS(CU(J))/LH,1d0)
     .                    +DDIM(DABS(CUP(J))/LA,1d0)


        ELSEIF(RW.LE.2.5d-2)THEN

         I=1
         DOWHILE(HM1(I).LE.MH)
          I=I+1
         ENDDO
         L1=LH2(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LH2(I)-LH2(I-1))
         L2=LH3(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LH3(I)-LH3(I-1))
         LH=L1+(RW-0.5d-2)/0.5d-2*(L2-L1)
         L1=LA2(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LA2(I)-LA2(I-1))
         L2=LA3(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LA3(I)-LA3(I-1))
         LA=L1+(RW-0.5d-2)/0.5d-2*(L2-L1)
         PROB(75)=PROB(75)+DDIM(DABS(CU(J))/LH,1d0)
     .                    +DDIM(DABS(CUP(J))/LA,1d0)

        ELSEIF(RW.LE.5d-2)THEN

         I=1
         DOWHILE(HM1(I).LE.MH)
          I=I+1
         ENDDO
         L1=LH3(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LH3(I)-LH3(I-1))
         L2=LH4(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LH4(I)-LH4(I-1))
         LH=L1+(RW-0.5d-2)/0.5d-2*(L2-L1)
         L1=LA3(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LA3(I)-LA3(I-1))
         L2=LA4(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LA4(I)-LA4(I-1))
         LA=L1+(RW-0.5d-2)/0.5d-2*(L2-L1)
         PROB(75)=PROB(75)+DDIM(DABS(CU(J))/LH,1d0)
     .                    +DDIM(DABS(CUP(J))/LA,1d0)

        ELSEIF(RW.LE.10d-2)THEN

         I=1
         DOWHILE(HM1(I).LE.MH)
          I=I+1
         ENDDO
         L1=LH4(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LH4(I)-LH4(I-1))
         I=1
         DOWHILE(HM2(I).LE.MH)
          I=I+1
         ENDDO
         L2=LH5(I-1)+(MH-HM2(I-1))/(HM2(I)-HM2(I-1))*(LH5(I)-LH5(I-1))
         LH=L1+(RW-0.5d-2)/0.5d-2*(L2-L1)
         I=1
         DOWHILE(HM1(I).LE.MH)
          I=I+1
         ENDDO
         L1=LA4(I-1)+(MH-HM1(I-1))/(HM1(I)-HM1(I-1))*(LA4(I)-LA4(I-1))
         I=1
         DOWHILE(HM2(I).LE.MH)
          I=I+1
         ENDDO
         L2=LA5(I-1)+(MH-HM2(I-1))/(HM2(I)-HM2(I-1))*(LA5(I)-LA5(I-1))
         LA=L1+(RW-0.5d-2)/0.5d-2*(L2-L1)
         PROB(75)=PROB(75)+DDIM(DABS(CU(J))/LH,1d0)
     .                    +DDIM(DABS(CUP(J))/LA,1d0)

        ELSEIF(RW.LE.25d-2)THEN

         I=1
         DOWHILE(HM2(I).LE.MH)
          I=I+1
         ENDDO
         L1=LH5(I-1)+(MH-HM2(I-1))/(HM2(I)-HM2(I-1))*(LH5(I)-LH5(I-1))
         L2=LH6(I-1)+(MH-HM2(I-1))/(HM2(I)-HM2(I-1))*(LH6(I)-LH6(I-1))
         LH=L1+(RW-0.5d-2)/0.5d-2*(L2-L1)
         L1=LA5(I-1)+(MH-HM2(I-1))/(HM2(I)-HM2(I-1))*(LA5(I)-LA5(I-1))
         L2=LA6(I-1)+(MH-HM2(I-1))/(HM2(I)-HM2(I-1))*(LA6(I)-LA6(I-1))
         LA=L1+(RW-0.5d-2)/0.5d-2*(L2-L1)
         PROB(75)=PROB(75)+DDIM(DABS(CU(J))/LH,1d0)
     .                    +DDIM(DABS(CUP(J))/LA,1d0)

        ELSE

         I=1
         DOWHILE(HM2(I).LE.MH)
          I=I+1
         ENDDO
         LH=LH6(I-1)+(MH-HM2(I-1))/(HM2(I)-HM2(I-1))*(LH6(I)-LH6(I-1))
         LA=LA6(I-1)+(MH-HM2(I-1))/(HM2(I)-HM2(I-1))*(LA6(I)-LA6(I-1))
         PROB(75)=PROB(75)+DDIM(DABS(CU(J))/LH,1d0)
     .                    +DDIM(DABS(CUP(J))/LA,1d0)

        ENDIF

       ENDIF
      ENDDO

      END


      SUBROUTINE HSM_AA_LEPTONS_CPV(PROB)

*     PROB(52) =/= 0: excluded 

      IMPLICIT NONE

      INTEGER NHAATAUS0,NHAATAUS1,NHAATAUS2,NHAATAUS3,NHAAMUS0
      INTEGER NHAAMUS1,NHAAMUS2,NHAAMUS3,NHAAMUS4,NHAAMUS5
      INTEGER NHAAMUTAU1,NHAAMUTAU2,NHAAMUB1,NHAAMUB2
      INTEGER NHAATAUB,NHAAGJ,NHAABS,NHAABS2,NHAAMUTAU3
      INTEGER NHAAMUB3,NHAAMUB4,NHAAMUS6
      INTEGER I,J,K

      DOUBLE PRECISION MHC,XC(2,2),MH0(5),XH(5,5),MA2
      DOUBLE PRECISION PROB(*)
      DOUBLE PRECISION D1(5),D2(5),C2BRHAA,MH,MA
      DOUBLE PRECISION LOWBOUND,HIGHBOUND,LIMIT,ggF8,ggF13
      DOUBLE PRECISION BRJJ(5),BREE(5),BRMM(5),BRLL(5),
     . BRCC(5),BRBB(5),BRTT(5),BRWW(5),BRZZ(5),BRGG(5),BRZG(5)
      DOUBLE PRECISION BRHHH(5,10),BRHCHC(5),BRHAZ(5,4),BRHCW(5),
     . BRHIGGS(5)
      DOUBLE PRECISION CU(5),CUP(5),CD(5),CDP(5),CB(5),CBP(5),CJ(5),
     . CJP(5),CI(5),CG(5),CGP(5),CV(5),CZG(5),CZGP(5),CL(5),CLP(5)
      DOUBLE PRECISION MHmin,MHmax
      DOUBLE PRECISION HAATAUS0(100,2),HAATAUS1(300,2),HAATAUS2(100,2)
      DOUBLE PRECISION HAATAUS3(100,2),HAAMUS0(100,2),HAAMUS1(100,2)
      DOUBLE PRECISION HAAMUS2(100,2),HAAMUS3(100,2),HAAMUS4(100,4)
      DOUBLE PRECISION HAAMUS5(100,4),HAAMUTAU1(100,2),HAAMUTAU2(100,2)
      DOUBLE PRECISION HAAMUB1(100,2),HAAMUB2(200,2),HAATAUB(100,2)
      DOUBLE PRECISION HAAGJ(100,2),HAABS(100,2),HAABS2(100,2)
      DOUBLE PRECISION HAAMUTAU3(200,2),HAAMUB3(100,2)
      DOUBLE PRECISION HAAMUB4(100,2),HAAMUS6(200,2)

      COMMON/HISPEC/MHC,XC,MH0,XH,MA2
      COMMON/HNSMBR/BRJJ,BREE,BRMM,BRLL,BRCC,BRBB,BRTT,BRWW,BRZZ,
     . BRGG,BRZG
      COMMON/HNHIBR/BRHHH,BRHCHC,BRHAZ,BRHCW,BRHIGGS
      COMMON/HNSMCOUP/CU,CUP,CD,CDP,CB,CBP,CJ,CJP,CI,CG,CGP,CV,CZG,CZGP,
     . CL,CLP
      COMMON/HIGGSFIT/MHmin,MHmax
      COMMON/LHCHAA/HAATAUS0,HAATAUS1,HAATAUS2,HAATAUS3,
     .      HAAMUS0,HAAMUS1,HAAMUS2,HAAMUS3,HAAMUS4,HAAMUS5,
     .      HAAMUTAU1,HAAMUTAU2,HAAMUB1,HAAMUB2,HAATAUB,HAAGJ,
     .      HAABS,HAABS2,HAAMUTAU3,HAAMUB3,HAAMUB4,HAAMUS6,
     .      NHAATAUS0,NHAATAUS1,NHAATAUS2,NHAATAUS3,NHAAMUS0,
     .      NHAAMUS1,NHAAMUS2,NHAAMUS3,NHAAMUS4,NHAAMUS5,
     .      NHAAMUTAU1,NHAAMUTAU2,NHAAMUB1,NHAAMUB2,
     .      NHAATAUB,NHAAGJ,NHAABS,NHAABS2,NHAAMUTAU3,
     .      NHAAMUB3,NHAAMUB4,NHAAMUS6

      PROB(52)=0d0

* HSM -> h1h1 or h2h2
* Determining the SM-like Higgs and its coupling*BR

      DO I=2,5
       D1(I)=DDIM(dsqrt(MH0(I))/MHMAX,1d0)-DDIM(1d0,dsqrt(MH0(I))/MHMIN)
      ENDDO

      DO K=1,2

      MH=0d0
      C2BRHAA=0d0
      MA=dsqrt(MH0(K))
      DO I=K+1,5
       IF(D1(I).EQ.0d0)THEN
        C2BRHAA=C2BRHAA+(CJ(I)**2+CJP(I)**2)*BRHHH(I,2*K-1)
        MH=MH+dsqrt(MH0(I))*(CJ(I)**2+CJP(I)**2)*BRHHH(I,2*K-1)
       ENDIF
      ENDDO

      IF(C2BRHAA.NE.0d0)THEN
      MH=MH/C2BRHAA

* ggF->HSM->AA->4mu from CMS-PAS-HIG-13-010, 0.25GeV < M_A < 3.55GeV
* normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAAMUS0(1,1) .AND. HAAMUS0(I,1).LE.MA
     .        .AND. I.LT.NHAAMUS0)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LE.HAAMUS0(NHAAMUS0,1))THEN
       LIMIT=HAAMUS0(I-1,2)+(MA-HAAMUS0(I-1,1))
     .         /(HAAMUS0(I,1)-HAAMUS0(I-1,1))
     .         *(HAAMUS0(I,2)-HAAMUS0(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRMM(K)**2/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->4mu from 2110.13673 (ATLAS), 1.5GeV < M_A < 60GeV
* normalized to SM XS

      IF((MA.GT.1.5d0).AND.(MA.LT.2d0).OR.
     .   (MA.GT.4.5d0).AND.(MA.LT.8.5d0).OR.
     .   (MA.GT.8.5d0).AND.(MA.LT.60d0))THEN
      I=1
      DOWHILE(MA.GE.HAAMUS6(1,1) .AND. HAAMUS6(I,1).LE.MA
     .        .AND. I.LT.NHAAMUS6)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LE.HAAMUS6(NHAAMUS6,1))THEN
       LIMIT=HAAMUS6(I-1,2)+(MA-HAAMUS6(I-1,1))
     .         /(HAAMUS6(I,1)-HAAMUS6(I-1,1))
     .         *(HAAMUS6(I,2)-HAAMUS6(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRMM(K)**2/LIMIT,1d0)
      ENDIF
      ENDIF

* ggF->HSM->AA->2mu2tau from CMS-HIG-PAS-15-011, 20GeV < M_A < 62.5GeV
* BR(A->2mu) converted in BR(A->2tau), normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAATAUS0(1,1) .AND. HAATAUS0(I,1).LE.MA
     .        .AND. I.LT.NHAATAUS0)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LE.HAATAUS0(NHAATAUS0,1))THEN
       LIMIT=HAATAUS0(I-1,2)+(MA-HAATAUS0(I-1,1))
     .         /(HAATAUS0(I,1)-HAATAUS0(I-1,1))
     .         *(HAATAUS0(I,2)-HAATAUS0(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRLL(K)**2/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->2mu2tau from 1701.02032 (CMS), 15GeV < M_A < 62.5GeV
* BR(A->2tau) converted in BR(A->2mu), normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAAMUS1(1,1) .AND. HAAMUS1(I,1).LE.MA
     .        .AND. I.LT.NHAAMUS1)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LT.HAAMUS1(NHAAMUS1,1))THEN
       LIMIT=HAAMUS1(I-1,2)+(MA-HAAMUS1(I-1,1))
     .         /(HAAMUS1(I,1)-HAAMUS1(I-1,1))
     .         *(HAAMUS1(I,2)-HAAMUS1(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRMM(K)**2/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->2mu2tau from 1701.02032 (CMS), 15GeV < M_A < 62.5GeV
* normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAAMUTAU1(1,1) .AND. HAAMUTAU1(I,1).LE.MA
     .        .AND. I.LT.NHAAMUTAU1)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LE.HAAMUTAU1(NHAAMUTAU1,1))THEN
       LIMIT=HAAMUTAU1(I-1,2)+(MA-HAAMUTAU1(I-1,1))
     .         /(HAAMUTAU1(I,1)-HAAMUTAU1(I-1,1))
     .         *(HAAMUTAU1(I,2)-HAAMUTAU1(I-1,2))
       PROB(52)=PROB(52)
     .          +DDIM(C2BRHAA*BRMM(K)*BRLL(K)/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->2mu2tau from 1805.04865 (CMS), 15GeV < M_A < 62.5GeV
* normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAAMUTAU2(1,1) .AND. HAAMUTAU2(I,1).LE.MA
     .        .AND. I.LT.NHAAMUTAU2)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LE.HAAMUTAU2(NHAAMUTAU2,1))THEN
       LIMIT=HAAMUTAU2(I-1,2)+(MA-HAAMUTAU2(I-1,1))
     .         /(HAAMUTAU2(I,1)-HAAMUTAU2(I-1,1))
     .         *(HAAMUTAU2(I,2)-HAAMUTAU2(I-1,2))
       PROB(52)=PROB(52)
     .          +DDIM(C2BRHAA*BRMM(K)*BRLL(K)/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->2mu2tau from 2005.08694 (CMS), 3.5GeV < M_A < 21GeV
* normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAAMUTAU3(1,1) .AND. HAAMUTAU3(I,1).LE.MA
     .        .AND. I.LT.NHAAMUTAU3)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LE.HAAMUTAU3(NHAAMUTAU3,1))THEN
       LIMIT=HAAMUTAU3(I-1,2)+(MA-HAAMUTAU3(I-1,1))
     .         /(HAAMUTAU3(I,1)-HAAMUTAU3(I-1,1))
     .         *(HAAMUTAU3(I,2)-HAAMUTAU3(I-1,2))
       PROB(52)=PROB(52)
     .          +DDIM(C2BRHAA*BRMM(K)*BRLL(K)/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->2mu2tau from 1505.01609 (ATLAS), 3.7GeV < M_A < 50GeV
* BR(A->2mu) converted in BR(A->2tau), normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAATAUS1(1,1) .AND. HAATAUS1(I,1).LE.MA
     .        .AND. I.LT.NHAATAUS1)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LE.HAATAUS1(NHAATAUS1,1))THEN
       LIMIT=HAATAUS1(I-1,2) +(MA-HAATAUS1(I-1,1))
     .         /(HAATAUS1(I,1)-HAATAUS1(I-1,1))
     .         *(HAATAUS1(I,2)-HAATAUS1(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRLL(K)**2/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->4tau from 1510.06534 (CMS), 4GeV < M_A < 8GeV

      I=1
      DOWHILE(MA.GE.HAATAUS2(1,1) .AND. HAATAUS2(I,1).LE.MA
     .        .AND. I.LT.NHAATAUS2)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LE.HAATAUS2(NHAATAUS2,1))THEN
       LIMIT=HAATAUS2(I-1,2)+(MA-HAATAUS2(I-1,1))
     .         /(HAATAUS2(I,1)-HAATAUS2(I-1,1))
     .         *(HAATAUS2(I,2)-HAATAUS2(I-1,2))
       PROB(52)=PROB(52)+DDIM(ggF8(MH)*C2BRHAA*BRLL(K)**2/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->4tau from 1510.06534 (CMS), 4GeV < M_A < 8GeV
* BR(A->2tau) converted in BR(A->2mu), Fig. 7 of 1701.02032
* normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAAMUS3(1,1) .AND. HAAMUS3(I,1).LE.MA
     .        .AND. I.LT.NHAAMUS3)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LT.HAAMUS3(NHAAMUS3,1))THEN
       LIMIT=HAAMUS3(I-1,2)+(MA-HAAMUS3(I-1,1))
     .         /(HAAMUS3(I,1)-HAAMUS3(I-1,1))
     .         *(HAAMUS3(I,2)-HAAMUS3(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRMM(K)**2/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->4tau from CMS-PAS-HIG-14-022, 5GeV < M_A < 15GeV
* normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAATAUS3(1,1) .AND. HAATAUS3(I,1).LE.MA
     .        .AND. I.LT.NHAATAUS3)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LT.HAATAUS3(NHAATAUS3,1))THEN
       LIMIT=HAATAUS3(I-1,2)+(MA-HAATAUS3(I-1,1))
     .         /(HAATAUS3(I,1)-HAATAUS3(I-1,1))
     .         *(HAATAUS3(I,2)-HAATAUS3(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRLL(K)**2/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->4tau from CMS-PAS-HIG-14-022, 5GeV < M_A < 15GeV
* BR(A->2tau) converted in BR(A->2mu), Fig. 7 of 1701.02032
* normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAAMUS2(1,1) .AND. HAAMUS2(I,1).LE.MA
     .        .AND. I.LT.NHAAMUS2)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LT.HAAMUS2(NHAAMUS2,1))THEN
       LIMIT=HAAMUS2(I-1,2)+(MA-HAAMUS2(I-1,1))
     .         /(HAAMUS2(I,1)-HAAMUS2(I-1,1))
     .         *(HAAMUS2(I,2)-HAAMUS2(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRMM(K)**2/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->2mu2b from CMS-PAS-HIG-14-041, 25GeV < M_A < 62.5GeV
* normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAAMUB1(1,1) .AND. HAAMUB1(I,1).LE.MA
     .        .AND. I.LT.NHAAMUB1)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LT.HAAMUB1(NHAAMUB1,1))THEN
       LIMIT=HAAMUB1(I-1,2)+(MA-HAAMUB1(I-1,1))
     .         /(HAAMUB1(I,1)-HAAMUB1(I-1,1))
     .         *(HAAMUB1(I,2)-HAAMUB1(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRMM(K)*BRBB(K)/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->2mu2b from 1807.00539 (ATLAS), 20GeV < M_A < 60GeV
* normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAAMUB2(1,1) .AND. HAAMUB2(I,1).LE.MA
     .        .AND. I.LT.NHAAMUB2)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LT.HAAMUB2(NHAAMUB2,1))THEN
       LIMIT=HAAMUB2(I-1,2)+(MA-HAAMUB2(I-1,1))
     .         /(HAAMUB2(I,1)-HAAMUB2(I-1,1))
     .         *(HAAMUB2(I,2)-HAAMUB2(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRMM(K)*BRBB(K)/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->2mu2b from 2110.0313 (ATLAS), 16GeV < M_A < 62GeV
* normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAAMUB3(1,1) .AND. HAAMUB3(I,1).LE.MA
     .        .AND. I.LT.NHAAMUB3)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LT.HAAMUB3(NHAAMUB3,1))THEN
       LIMIT=HAAMUB3(I-1,2)+(MA-HAAMUB3(I-1,1))
     .         /(HAAMUB3(I,1)-HAAMUB3(I-1,1))
     .         *(HAAMUB3(I,2)-HAAMUB3(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRMM(K)*BRBB(K)/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->2mu2b from 1812.06359 (CMS), 20GeV < M_A < 62.5GeV
* normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAAMUB4(1,1) .AND. HAAMUB4(I,1).LE.MA
     .        .AND. I.LT.NHAAMUB4)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LT.HAAMUB4(NHAAMUB4,1))THEN
       LIMIT=HAAMUB4(I-1,2)+(MA-HAAMUB4(I-1,1))
     .         /(HAAMUB4(I,1)-HAAMUB4(I-1,1))
     .         *(HAAMUB4(I,2)-HAAMUB4(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRMM(K)*BRBB(K)/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->2tau2b from 1805.10191 (CMS), 15GeV < M_A < 60GeV
* normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAATAUB(1,1) .AND. HAATAUB(I,1).LE.MA
     .        .AND. I.LT.NHAATAUB)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LT.HAATAUB(NHAATAUB,1))THEN
       LIMIT=HAATAUB(I-1,2)+(MA-HAATAUB(I-1,1))
     .         /(HAATAUB(I,1)-HAATAUB(I-1,1))
     .         *(HAATAUB(I,2)-HAATAUB(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRLL(K)*BRBB(K)/LIMIT,1d0)
      ENDIF

* ggF->HSM->AA->2gamma2jet from 1803.11145 (ATLAS), 20GeV < M_A < 60GeV
* normalized to SM XS

      I=1
      DOWHILE(MA.GE.HAAGJ(1,1) .AND. HAAGJ(I,1).LE.MA
     .        .AND. I.LT.NHAAGJ)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LT.HAAGJ(NHAAGJ,1))THEN
       LIMIT=HAAGJ(I-1,2)+(MA-HAAGJ(I-1,1))
     .         /(HAAGJ(I,1)-HAAGJ(I-1,1))
     .         *(HAAGJ(I,2)-HAAGJ(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRGG(K)*BRJJ(K)/LIMIT,1d0)
      ENDIF

      ENDIF
      ENDDO

* pp->VHSM->AA->4b from 1806.07355 (ATLAS), 20GeV < M_A < 60GeV
* normalized to SM XS

      DO K=1,2

      MH=0d0
      C2BRHAA=0d0
      MA=dsqrt(MH0(K))
      DO I=K+1,5
       IF(D1(I).EQ.0d0)THEN
        C2BRHAA=C2BRHAA+CV(I)**2*BRHHH(I,2*K-1)
        MH=MH+dsqrt(MH0(I))*CV(I)**2*BRHHH(I,2*K-1)
       ENDIF
      ENDDO

      IF(C2BRHAA.NE.0d0)THEN
      MH=MH/C2BRHAA

      I=1
      DOWHILE(MA.GE.HAABS(1,1) .AND. HAABS(I,1).LE.MA
     .        .AND. I.LT.NHAABS)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LT.HAABS(NHAABS,1))THEN
       LIMIT=HAABS(I-1,2)+(MA-HAABS(I-1,1))
     .         /(HAABS(I,1)-HAABS(I-1,1))
     .         *(HAABS(I,2)-HAABS(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRBB(K)**2/LIMIT,1d0)
      ENDIF

      ENDIF
      ENDDO

* pp->VHSM->AA->4b from 2005.12236 (ATLAS), 15GeV < M_A < 30GeV
* normalized to SM XS

      DO K=1,2

      MH=0d0
      C2BRHAA=0d0
      MA=dsqrt(MH0(K))
      DO I=K+1,5
       IF(D1(I).EQ.0d0)THEN
        C2BRHAA=C2BRHAA+CV(I)**2*BRHHH(I,2*K-1)
        MH=MH+dsqrt(MH0(I))*CV(I)**2*BRHHH(I,2*K-1)
       ENDIF
      ENDDO

      IF(C2BRHAA.NE.0d0)THEN
      MH=MH/C2BRHAA

      I=1
      DOWHILE(MA.GE.HAABS2(1,1) .AND. HAABS2(I,1).LE.MA
     .        .AND. I.LT.NHAABS2)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MA.LT.HAABS2(NHAABS2,1))THEN
       LIMIT=HAABS2(I-1,2)+(MA-HAABS2(I-1,1))
     .         /(HAABS2(I,1)-HAABS2(I-1,1))
     .         *(HAABS2(I,2)-HAABS2(I-1,2))
       PROB(52)=PROB(52)+DDIM(C2BRHAA*BRBB(K)**2/LIMIT,1d0)
      ENDIF

      ENDIF
      ENDDO

* ggF -> H -> a1a1 or h1h1 -> 4mu from 1506.00424 (CMS 8TeV)
* for 0.25GeV < M_A < 3.55GeV, 86GeV < M_H < 150GeV

      DO I=2,5
       D1(I)=DDIM(dsqrt(MH0(I))/HAAMUS4(NHAAMUS4,1),1d0)
     .      -DDIM(1d0,dsqrt(MH0(I))/HAAMUS4(1,1))
      ENDDO

        DO K=1,2

      MA=dsqrt(MH0(K))
      DO I=K+1,5
       IF(D1(I).EQ.0d0)THEN
        D2(I)=(CJ(I)**2+CJP(I)**2)*BRHHH(I,2*K-1)
       ELSE
        D2(I)=0d0
       ENDIF
      ENDDO

       DO J=K+1,5

      MH=0d0
      C2BRHAA=0d0
      DO I=K+1,5
       IF(DABS(dsqrt(MH0(I))-dsqrt(MH0(J))).LT.3d0)THEN
        C2BRHAA=C2BRHAA+D2(I)
        MH=MH+dsqrt(MH0(I))*D2(I)
       ENDIF
      ENDDO
      IF(C2BRHAA.NE.0d0)THEN
      MH=MH/C2BRHAA

      I=1
      DOWHILE(MH.GE.HAAMUS4(1,1)
     .        .AND. HAAMUS4(I,1).LE.MH .AND. I.LT.NHAAMUS4)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MH.LE.HAAMUS4(NHAAMUS4,1))THEN
       LOWBOUND=100d0
       HIGHBOUND=100d0
       IF(MA.GE.0.25d0 .and. MA.LT.2d0)THEN
        LOWBOUND=HAAMUS4(I-1,2)+(MA-0.25d0)/(2d0-0.25d0)
     .         *(HAAMUS4(I-1,3)-HAAMUS4(I-1,2))
        HIGHBOUND=HAAMUS4(I,2)+(MA-0.25d0)/(2d0-0.25d0)
     .         *(HAAMUS4(I,3)-HAAMUS4(I,2))
       ELSEIF(MA.GE.2d0 .and. MA.LE.3.55d0)THEN
        LOWBOUND=HAAMUS4(I-1,3)+(MA-2d0)/(3.55d0-2d0)
     .         *(HAAMUS4(I-1,4)-HAAMUS4(I-1,3))
        HIGHBOUND=HAAMUS4(I,3)+(MA-2d0)/(3.55d0-2d0)
     .         *(HAAMUS4(I,4)-HAAMUS4(I,3))
       ENDIF

       LIMIT=(LOWBOUND
     .    +(MH-HAAMUS4(I-1,1))/(HAAMUS4(I,1)-HAAMUS4(I-1,1))
     .         *(HIGHBOUND-LOWBOUND))/1d3 ! translated in pb
       PROB(52)=PROB(52)+DDIM(ggF8(MH)*C2BRHAA*BRMM(K)**2/LIMIT,1d0)
      ENDIF

      ENDIF
       ENDDO
        ENDDO

* ggF -> H -> a1a1 or h1h1 -> 4mu from CMS-PAS-HIG-18-003 (CMS 13TeV)
* for 0.25GeV < M_A < 3.55GeV, 90GeV < M_H < 150GeV

      DO I=2,5
       D1(I)=DDIM(dsqrt(MH0(I))/150d0,1d0)-DDIM(1d0,dsqrt(MH0(I))/90d0)
      ENDDO

        DO K=1,2

      MA=dsqrt(MH0(K))
      DO I=K+1,5
       IF(D1(I).EQ.0d0)THEN
        D2(I)=(CJ(I)**2+CJP(I)**2)*BRHHH(I,2*K-1)
       ELSE
        D2(I)=0d0
       ENDIF
      ENDDO

       DO J=K+1,5

      MH=0d0
      C2BRHAA=0d0
      DO I=K+1,5
       IF(DABS(dsqrt(MH0(I))-dsqrt(MH0(J))).LT.3d0)THEN
        C2BRHAA=C2BRHAA+D2(I)
        MH=MH+dsqrt(MH0(I))*D2(I)
       ENDIF
      ENDDO
      IF(C2BRHAA.NE.0d0)THEN
      MH=MH/C2BRHAA

       I=1
       DOWHILE(MA.GE.HAAMUS5(1,1)
     .   .AND. HAAMUS5(I,1).LE.MA .AND. I.LT.NHAAMUS5)
        I=I+1
       ENDDO
       IF(I.GT.1 .AND. MA.LE.HAAMUS5(NHAAMUS5,1))THEN
        IF(MH.GE.90d0 .AND. MH.LE.150d0)THEN
         IF(MA.LT.125d0)THEN
          LOWBOUND=HAAMUS5(I-1,2)+(MH-90d0)/(125d0-90d0)
     .            *(HAAMUS5(I-1,3)-HAAMUS5(I-1,2))
          HIGHBOUND=HAAMUS5(I,2)+(MH-90d0)/(125d0-90d0)
     .             *(HAAMUS5(I,3)-HAAMUS5(I,2))
         ELSE
          LOWBOUND=HAAMUS5(I-1,3)+(MH-125d0)/(150d0-125d0)
     .            *(HAAMUS5(I-1,4)-HAAMUS5(I-1,3))
          HIGHBOUND=HAAMUS5(I,3)+(MH-2d0)/(150d0-125d0)
     .             *(HAAMUS5(I,4)-HAAMUS5(I,3))
         ENDIF
         LIMIT=(LOWBOUND
     .        +(MH-HAAMUS5(I-1,1))/(HAAMUS5(I,1)-HAAMUS5(I-1,1))
     .        *(HIGHBOUND-LOWBOUND))/1d3 ! translated in pb
       PROB(52)=PROB(52)+DDIM(ggF13(MH)*C2BRHAA*BRMM(K)**2/LIMIT,1d0)
        ENDIF
       ENDIF

      ENDIF
       ENDDO
        ENDDO

      END


      SUBROUTINE HSM_AA_PHOTONS_CPV(PROB)

*     H_125 -> AA -> photons from ATLAS, arXiv:1509.05051 + CMS PAS HIG-21-003
*     PROB(63) =/= 0: excluded 

      IMPLICIT NONE

      INTEGER I,J,K,N,N2
      PARAMETER (N=185,N2=71)

      DOUBLE PRECISION PROB(*),S,SMAX,M(N),L(N),M2(N2),L2(N2),MA,MH
      DOUBLE PRECISION MHC,XC(2,2),MH0(5),XH(5,5),MA2
      DOUBLE PRECISION CU(5),CUP(5),CD(5),CDP(5),CB(5),CBP(5),CJ(5),
     . CJP(5),CI(5),CG(5),CGP(5),CV(5),CZG(5),CZGP(5),CL(5),CLP(5)
      DOUBLE PRECISION BRJJ(5),BREE(5),BRMM(5),BRLL(5),
     . BRCC(5),BRBB(5),BRTT(5),BRWW(5),BRZZ(5),BRGG(5),BRZG(5)
      DOUBLE PRECISION BRHHH(5,10),BRHCHC(5),BRHAZ(5,4),BRHCW(5),
     . BRHIGGS(5)
      DOUBLE PRECISION MHmin,MHmax

      COMMON/HISPEC/MHC,XC,MH0,XH,MA2
      COMMON/HNSMCOUP/CU,CUP,CD,CDP,CB,CBP,CJ,CJP,CI,CG,CGP,CV,CZG,CZGP,
     . CL,CLP
      COMMON/HNSMBR/BRJJ,BREE,BRMM,BRLL,BRCC,BRBB,BRTT,BRWW,BRZZ,
     . BRGG,BRZG
      COMMON/HNHIBR/BRHHH,BRHCHC,BRHAZ,BRHCW,BRHIGGS
      COMMON/HIGGSFIT/MHmin,MHmax

      DATA M/1d1,1.0436d1,1.0744d1,1.0913d1,1.1094d1,1.1260d1,1.1594d1,
     .1.2120d1,1.2521d1,1.2750d1,1.3071d1,1.3438d1,1.3974d1,1.4343d1,
     .1.4674d1,1.5156d1,1.5500d1,1.5746d1,1.5950d1,1.6175d1,1.6394d1,
     .1.6727d1,1.7276d1,1.7734d1,1.8192d1,1.8765d1,1.9224d1,1.9637d1,
     .2.0140d1,2.0713d1,2.1101d1,2.1343d1,2.1479d1,2.1660d1,2.1796d1,
     .2.1946d1,2.2139d1,2.2325d1,2.2606d1,2.3004d1,2.3483d1,2.3861d1,
     .2.4098d1,2.4313d1,2.4513d1,2.4769d1,2.5011d1,2.5410d1,2.5945d1,
     .2.6327d1,2.6785d1,2.7051d1,2.7268d1,2.7520d1,2.7759d1,2.8236d1,
     .2.8561d1,2.8788d1,2.8902d1,2.9013d1,2.9125d1,2.9236d1,2.9355d1,
     .2.9568d1,2.9775d1,3.0112d1,3.0555d1,3.0804d1,3.1182d1,3.1697d1,
     .3.2282d1,3.2715d1,3.3201d1,3.3659d1,3.4173d1,3.4498d1,3.4710d1,
     .3.4989d1,3.5329d1,3.5802d1,3.6004d1,3.6211d1,3.6408d1,3.6568d1,
     .3.6797d1,3.7268d1,3.7594d1,3.7949d1,3.8185d1,3.8414d1,3.8643d1,
     .3.8865d1,3.9083d1,3.9331d1,3.9554d1,3.9789d1,4.0114d1,4.0625d1,
     .4.0935d1,4.1164d1,4.1378d1,4.1529d1,4.1729d1,4.1867d1,4.2046d1,
     .4.2188d1,4.2403d1,4.2651d1,4.3054d1,4.3492d1,4.3797d1,4.3930d1,
     .4.4077d1,4.4237d1,4.4360d1,4.4473d1,4.4584d1,4.4707d1,4.4820d1,
     .4.5059d1,4.5460d1,4.5976d1,4.6205d1,4.6320d1,4.6434d1,4.6546d1,
     .4.6648d1,4.6720d1,4.6870d1,4.6964d1,4.7110d1,4.7215d1,4.7444d1,
     .4.7934d1,4.8249d1,4.8470d1,4.8611d1,4.8823d1,4.9179d1,4.9799d1,
     .4.9974d1,5.0207d1,5.0437d1,5.0663d1,5.0900d1,5.1126d1,5.1455d1,
     .5.1876d1,5.2394d1,5.2604d1,5.2839d1,5.3058d1,5.3289d1,5.3413d1,
     .5.3535d1,5.3658d1,5.3881d1,5.4110d1,5.4485d1,5.5027d1,5.5371d1,
     .5.5600d1,5.5810d1,5.5922d1,5.6031d1,5.6139d1,5.6282d1,5.6418d1,
     .5.6613d1,5.6757d1,5.6959d1,5.7204d1,5.7547d1,5.7948d1,5.8521d1,
     .5.8922d1,5.9180d1,5.9467d1,5.9713d1,6.0055d1,6.0399d1,6.0641d1,
     .6.1099d1,6.1638d1,6.2d1/
      DATA L/3.0495d-4,3.3188d-4,3.5175d-4,3.7958d-4,4.1748d-4,
     .4.5015d-4,4.9288d-4,5.0986d-4,4.7180d-4,4.3749d-4,4.0261d-4,
     .3.8321d-4,3.9233d-4,4.1524d-4,4.5016d-4,4.6345d-4,4.3712d-4,
     .4.0954d-4,3.7648d-4,3.4511d-4,3.2145d-4,3.0275d-4,3.0490d-4,
     .3.1516d-4,3.2702d-4,3.3475d-4,3.2452d-4,3.1097d-4,2.9572d-4,
     .2.9321d-4,3.1935d-4,3.4496d-4,3.7242d-4,4.0961d-4,4.4202d-4,
     .4.7699d-4,5.2462d-4,5.7701d-4,6.1537d-4,6.5265d-4,6.3860d-4,
     .6.0308d-4,5.6361d-4,5.2482d-4,4.8616d-4,4.4202d-4,4.1415d-4,
     .3.8329d-4,3.8954d-4,4.1103d-4,4.0633d-4,3.7242d-4,3.4511d-4,
     .3.1981d-4,2.9690d-4,2.8802d-4,3.1981d-4,3.5175d-4,3.7958d-4,
     .4.0961d-4,4.4202d-4,4.7699d-4,5.1473d-4,5.6613d-4,6.2266d-4,
     .6.5711d-4,6.3463d-4,5.8810d-4,5.4809d-4,5.3743d-4,5.5929d-4,
     .5.8265d-4,5.7396d-4,5.6264d-4,5.8253d-4,6.3463d-4,6.8484d-4,
     .7.2922d-4,7.7615d-4,7.3902d-4,6.7193d-4,6.1092d-4,5.6613d-4,
     .5.2462d-4,4.8002d-4,4.5880d-4,4.9458d-4,5.4330d-4,5.8161d-4,
     .6.2988d-4,6.8101d-4,7.3839d-4,7.9749d-4,8.7313d-4,9.6472d-4,
     .1.0645d-3,1.1396d-3,1.1342d-3,1.0634d-3,9.8790d-4,9.1117d-4,
     .8.4436d-4,7.6770d-4,7.1142d-4,6.4682d-4,5.9940d-4,5.4498d-4,
     .5.0833d-4,4.8501d-4,5.0502d-4,5.5516d-4,5.9940d-4,6.4682d-4,
     .7.1142d-4,7.6770d-4,8.2844d-4,8.9399d-4,9.6472d-4,1.0410d-3,
     .1.1140d-3,1.1812d-3,1.1037d-3,1.0042d-3,9.2868d-4,8.6059d-4,
     .7.9749d-4,7.3902d-4,6.8484d-4,6.2266d-4,5.7701d-4,5.2462d-4,
     .4.8616d-4,4.4428d-4,4.3512d-4,4.7699d-4,5.2462d-4,5.6409d-4,
     .6.2243d-4,6.8064d-4,6.8484d-4,6.3463d-4,5.7701d-4,5.2462d-4,
     .4.7699d-4,4.3556d-4,4.0296d-4,3.7598d-4,3.6342d-4,3.8221d-4,
     .4.0961d-4,4.4202d-4,4.8616d-4,5.3411d-4,5.7701d-4,6.2266d-4,
     .6.7193d-4,7.4853d-4,8.1282d-4,8.8536d-4,8.6768d-4,7.9209d-4,
     .7.2098d-4,6.5926d-4,6.1092d-4,5.6613d-4,5.2462d-4,4.7699d-4,
     .4.4202d-4,4.0188d-4,3.7242d-4,3.4511d-4,3.1805d-4,2.9313d-4,
     .2.7738d-4,2.8251d-4,2.9963d-4,3.1981d-4,3.5175d-4,3.7911d-4,
     .4.1656d-4,4.5876d-4,4.9140d-4,5.0985d-4,4.9083d-4,4.6356d-4/
      DATA M2/1.50d1,1.55d1,1.60d1,1.65d1,1.70d1,1.75d1,1.80d1,1.85d1,
     .1.90d1,1.95d1,2.00d1,2.05d1,2.10d1,2.15d1,2.20d1,2.25d1,2.30d1,
     .2.35d1,2.40d1,2.45d1,2.50d1,2.55d1,2.60d1,2.65d1,2.70d1,2.75d1,
     .2.80d1,2.85d1,2.90d1,2.95d1,3.00d1,3.05d1,3.10d1,3.15d1,3.20d1,
     .3.25d1,3.30d1,3.35d1,3.40d1,3.45d1,3.50d1,3.55d1,3.60d1,3.65d1,
     .3.70d1,3.75d1,3.80d1,3.85d1,3.90d1,3.95d1,4.00d1,4.10d1,4.20d1,
     .4.30d1,4.40d1,4.50d1,4.60d1,4.70d1,4.80d1,4.90d1,5.00d1,5.10d1,
     .5.20d1,5.30d1,5.40d1,5.50d1,5.60d1,5.70d1,5.80d1,5.90d1,6.00d1/
      DATA L2/7.9343d-4,8.0985d-4,6.8655d-4,7.3119d-4,6.6858d-4,
     .7.1226d-4,6.5360d-4,6.7899d-4,9.1446d-4,6.4744d-4,6.3252d-4,
     .8.7127d-4,1.1049d-3,1.0866d-3,7.9234d-4,1.0840d-3,1.1971d-3,
     .1.3934d-3,1.0945d-3,1.1715d-3,1.3034d-3,1.3609d-3,1.2852d-3,
     .1.2768d-3,1.2798d-3,9.8828d-4,7.2102d-4,7.0356d-4,7.2274d-4,
     .9.3673d-4,9.2499d-4,8.0704d-4,9.3319d-4,9.6534d-4,9.3283d-4,
     .9.8500d-4,1.0547d-3,7.2552d-4,7.0777d-4,8.4998d-4,8.6233d-4,
     .8.3290d-4,7.6307d-4,7.8149d-4,7.7770d-4,9.0271d-4,7.5051d-4,
     .7.6786d-4,7.4789d-4,7.1205d-4,7.4245d-4,7.3085d-4,1.0472d-3,
     .9.3785d-4,1.0672d-3,8.3667d-4,6.4840d-4,5.5166d-4,6.2965d-4,
     .6.4664d-4,8.1622d-4,5.8860d-4,5.2280d-4,2.7844d-4,2.6492d-4,
     .4.4071d-4,6.2135d-4,4.9351d-4,3.5910d-4,2.3507d-4,3.2608d-4/

      PROB(63)=0d0

      DO I=1,2
       MA=dsqrt(MH0(I))

       IF(MA.GT.M(1) .AND. MA.LE.M(N))THEN
        S=0d0
        J=1
        DOWHILE(M(J).LT.MA)
         J=J+1
        ENDDO
        SMAX=L(J-1)+(MA-M(J-1))/(M(J)-M(J-1))*(L(J)-L(J-1))
        DO K=I+1,5
         MH=dsqrt(MH0(K))
         IF(MH.GE.MHMIN .AND. MH.LE.MHMAX)THEN
          S=S+(CJ(K)**2+CJP(K)**2)*BRHHH(K,2*I-1)*BRGG(I)**2
         ENDIF
        ENDDO
        PROB(63)=PROB(63)+DDIM(S/SMAX,1d0)
       ENDIF

       IF(MA.GT.M2(1) .AND. MA.LE.M2(N2))THEN
        S=0d0
        J=1
        DOWHILE(M2(J).LT.MA)
         J=J+1
        ENDDO
        SMAX=L2(J-1)+(MA-M2(J-1))/(M2(J)-M2(J-1))*(L2(J)-L2(J-1))
        DO K=I+1,5
         MH=dsqrt(MH0(K))
         IF(MH.GE.MHMIN .AND. MH.LE.MHMAX)THEN
          S=S+(CJ(K)**2+CJP(K)**2)*BRHHH(K,2*I-1)*BRGG(I)**2
         ENDIF
        ENDDO
        PROB(63)=PROB(63)+DDIM(S/SMAX,1d0)
       ENDIF

      ENDDO

      END


      SUBROUTINE HSM_ZA_CPV(PROB)

*     H_125 -> ZA, A -> hadrons from ATLAS, arXiv:2004.01678
*     H_125 -> ZA, A -> muons from ATLAS, arXiv:2110.13673
*     PROB(74) =/= 0: excluded 

      IMPLICIT NONE

      INTEGER I,J,K,N,N2
      PARAMETER (N=9,N2=16)

      DOUBLE PRECISION PROB(*),S,SMAX,M(N),L(N),M2(N2),L2(N2),MA,MH
      DOUBLE PRECISION MHC,XC(2,2),MH0(5),XH(5,5),MA2
      DOUBLE PRECISION CU(5),CUP(5),CD(5),CDP(5),CB(5),CBP(5),CJ(5),
     . CJP(5),CI(5),CG(5),CGP(5),CV(5),CZG(5),CZGP(5),CL(5),CLP(5)
      DOUBLE PRECISION BRJJ(5),BREE(5),BRMM(5),BRLL(5),
     . BRCC(5),BRBB(5),BRTT(5),BRWW(5),BRZZ(5),BRGG(5),BRZG(5)
      DOUBLE PRECISION BRHHH(5,10),BRHCHC(5),BRHAZ(5,4),BRHCW(5),
     . BRHIGGS(5)
      DOUBLE PRECISION MHmin,MHmax,gg13,VB13,VH13,TH13

      COMMON/HISPEC/MHC,XC,MH0,XH,MA2
      COMMON/HNSMCOUP/CU,CUP,CD,CDP,CB,CBP,CJ,CJP,CI,CG,CGP,CV,CZG,CZGP,
     . CL,CLP
      COMMON/HNSMBR/BRJJ,BREE,BRMM,BRLL,BRCC,BRBB,BRTT,BRWW,BRZZ,
     . BRGG,BRZG
      COMMON/HNHIBR/BRHHH,BRHCHC,BRHAZ,BRHCW,BRHIGGS
      COMMON/HIGGSFIT/MHmin,MHmax

      DATA M/.5d0,.75d0,1d0,1.5d0,2d0,2.5d0,3d0,3.5d0,4d0/
      DATA L/17d0,20d0,18d0,20d0,24d0,33d0,68d0,120d0,340d0/
      DATA M2/15d0,16d0,17d0,18d0,19d0,20d0,21d0,22d0,23d0,
     .24d0,25d0,26d0,27d0,28d0,29d0,30d0/
      DATA L2/0.8843d-3,0.8012d-3,0.7169d-3,0.1239d-2,0.1764d-2,
     .0.1116d-2,0.9808d-3,0.5484d-3,0.3523d-3,0.3404d-3,0.6708d-3,
     .0.1143d-2,0.1116d-2,0.1065d-2,0.9872d-3,0.9059d-3/

      PROB(74)=0d0
      gg13=48.61d0
      VB13=3.766d0
      VH13=2.238d0
      TH13=.7029d0

      DO I=1,2
       MA=dsqrt(MH0(I))

       IF(MA.GT.M(1) .AND. MA.LE.M(N))THEN
        S=0d0
        J=1
        DOWHILE(M(J).LT.MA)
         J=J+1
        ENDDO
        SMAX=L(J-1)+(MA-M(J-1))/(M(J)-M(J-1))*(L(J)-L(J-1))
        DO K=I+1,5
         MH=dsqrt(MH0(K))
         IF(MH.GE.MHMIN .AND. MH.LE.MHMAX)THEN
          S=S+((CJ(K)**2+CJP(K)**2)*gg13+CV(K)**2*(VB13+VH13)
     .         +(CU(K)**2+CUP(K)**2)*TH13)*BRHAZ(K,I)*BRJJ(I)
         ENDIF
        ENDDO
        PROB(74)=PROB(74)+DDIM(S/SMAX,1d0)
       ENDIF

       IF(MA.GT.M2(1) .AND. MA.LE.M2(N2))THEN
        S=0d0
        J=1
        DOWHILE(M2(J).LT.MA)
         J=J+1
        ENDDO
        SMAX=L2(J-1)+(MA-M2(J-1))/(M2(J)-M2(J-1))*(L2(J)-L2(J-1))
        DO K=I+1,5
         MH=dsqrt(MH0(K))
         IF(MH.GE.MHMIN .AND. MH.LE.MHMAX)THEN
          S=S+(CJ(K)**2+CJP(K)**2)*gg13*BRHAZ(K,I)*BRMM(I)
         ENDIF
        ENDDO
        PROB(74)=PROB(74)+DDIM(S/SMAX,1d0)
       ENDIF

      ENDDO

      END


      SUBROUTINE HEAVYH_ZHSM_bb_CPV(PROB)

*     A -> ZHSM, HSM ->bb from CMS, arXiv:1903.00941
*     PROB(76) =/= 0: excluded
*     and ATLAS, arXiv:1712.06518 + ATLAS-CONF-2020-043
*     PROB(77) =/= 0: excluded

      IMPLICIT NONE

      INTEGER I,J,N1,N2,N3,N4
      PARAMETER (N1=51,N2=53,N3=35,N4=14)

      DOUBLE PRECISION PROB(*),M1(N1),L1(N1),M2(N2),L2(N2)
      DOUBLE PRECISION M3(N3),L3(N3),L3B(N3),M4(N4),L4(N4)
      DOUBLE PRECISION MA,MH,SIGJ,SIGB,L,ggF13,bbH13
      DOUBLE PRECISION MHC,XC(2,2),MH0(5),XH(5,5),MA2
      DOUBLE PRECISION CU(5),CUP(5),CD(5),CDP(5),CB(5),CBP(5),CJ(5),
     . CJP(5),CI(5),CG(5),CGP(5),CV(5),CZG(5),CZGP(5),CL(5),CLP(5)
      DOUBLE PRECISION WIDTH(5),HCWIDTH
      DOUBLE PRECISION BRJJ(5),BREE(5),BRMM(5),BRLL(5),
     . BRCC(5),BRBB(5),BRTT(5),BRWW(5),BRZZ(5),BRGG(5),BRZG(5)
      DOUBLE PRECISION BRHHH(5,10),BRHCHC(5),BRHAZ(5,4),BRHCW(5),
     . BRHIGGS(5)
      DOUBLE PRECISION MHmin,MHmax

      COMMON/HISPEC/MHC,XC,MH0,XH,MA2
      COMMON/HNSMCOUP/CU,CUP,CD,CDP,CB,CBP,CJ,CJP,CI,CG,CGP,CV,CZG,CZGP,
     . CL,CLP
      COMMON/HIWIDTH/WIDTH,HCWIDTH
      COMMON/HNSMBR/BRJJ,BREE,BRMM,BRLL,BRCC,BRBB,BRTT,BRWW,BRZZ,
     . BRGG,BRZG
      COMMON/HNHIBR/BRHHH,BRHCHC,BRHAZ,BRHCW,BRHIGGS
      COMMON/HIGGSFIT/MHmin,MHmax

      DATA M1/2.25d2,2.35d2,2.40d2,2.45d2,2.50d2,2.55d2,2.65d2,2.70d2,
     .2.75d2,2.80d2,2.85d2,2.95d2,3.00d2,3.05d2,3.10d2,3.15d2,3.20d2,
     .3.30d2,3.35d2,3.40d2,3.50d2,3.60d2,3.80d2,3.90d2,4.00d2,4.10d2,
     .4.30d2,4.40d2,4.60d2,4.70d2,4.90d2,5.00d2,5.25d2,5.50d2,5.75d2,
     .6.00d2,6.25d2,6.50d2,6.75d2,7.00d2,7.25d2,7.50d2,7.75d2,8.00d2,
     .8.25d2,8.50d2,8.75d2,9.00d2,9.50d2,9.75d2,1.00d3/
      DATA L1/7.8694d-1,3.5916d-1,3.8894d-1,7.0770d-1,8.2091d-1,
     .6.2560d-1,6.7967d-1,6.7240d-1,6.3711d-1,7.1989d-1,6.9598d-1,
     .4.5546d-1,3.3952d-1,2.7001d-1,2.2829d-1,2.1499d-1,2.2683d-1,
     .3.7358d-1,3.9508d-1,3.7865d-1,2.0652d-1,1.5039d-1,2.4399d-1,
     .2.3884d-1,2.0291d-1,1.6002d-1,8.5323d-2,7.0728d-2,6.0887d-2,
     .6.2368d-2,7.9997d-2,7.2467d-2,7.9594d-2,4.1929d-2,3.2668d-2,
     .3.4909d-2,2.9929d-2,2.8912d-2,2.9880d-2,3.9561d-2,4.2100d-2,
     .3.9169d-2,2.5838d-2,1.7032d-2,1.1388d-2,9.8492d-3,1.1023d-2,
     .1.2719d-2,1.7473d-2,1.9602d-2,2.0650d-2/
      DATA M2/2.25d2,2.35d2,2.40d2,2.45d2,2.50d2,2.55d2,2.60d2,2.65d2,
     .2.70d2,2.75d2,2.80d2,2.85d2,3.00d2,3.10d2,3.15d2,3.20d2,3.25d2,
     .3.30d2,3.35d2,3.40d2,3.50d2,3.60d2,3.70d2,3.80d2,3.90d2,4.00d2,
     .4.10d2,4.20d2,4.30d2,4.40d2,4.50d2,4.60d2,4.70d2,4.90d2,5.00d2,
     .5.25d2,5.50d2,5.75d2,6.00d2,6.25d2,6.50d2,6.75d2,7.00d2,7.25d2,
     .7.50d2,8.00d2,8.25d2,8.50d2,9.00d2,9.25d2,9.50d2,9.75d2,1.00d3/
      DATA L2/8.8507d-1,4.1274d-1,4.3231d-1,6.4800d-1,8.0138d-1,
     .6.5623d-1,6.8894d-1,7.0975d-1,6.7071d-1,6.3655d-1,7.4587d-1,
     .7.4587d-1,3.7741d-1,2.9134d-1,2.8881d-1,3.1365d-1,3.7972d-1,
     .4.8589d-1,4.9955d-1,4.6142d-1,2.4028d-1,2.2282d-1,2.9598d-1,
     .3.6404d-1,3.4935d-1,3.1142d-1,2.5437d-1,1.7922d-1,1.1937d-1,
     .9.1615d-2,8.0745d-2,7.3751d-2,7.3144d-2,8.9605d-2,8.0537d-2,
     .9.1365d-2,4.8903d-2,3.9779d-2,4.2093d-2,3.6803d-2,3.5535d-2,
     .3.8201d-2,5.0418d-2,5.3468d-2,4.9883d-2,2.3526d-2,1.5182d-2,
     .1.2985d-2,1.7649d-2,2.1813d-2,2.5328d-2,2.7331d-2,2.8566d-2/
      DATA M3/2.2d2,2.4d2,2.6d2,2.8d2,3d2,3.2d2,3.4d2,3.6d2,3.8d2,
     .4d2,4.2d2,4.4d2,4.6d2,4.8d2,5d2,5.5d2,6d2,6.5d2,7d2,7.5d2,8d2,
     .8.5d2,9d2,9.5d2,1d3,1.1d3,1.2d3,1.3d3,1.4d3,1.5d3,1.6d3,1.7d3,
     .1.8d3,1.9d3,2d3/
      DATA L3/0.543059d0,0.807928d0,0.672405d0,0.431714d0,
     .0.286503d0,0.424770d0,0.158343d0,0.192906d0,0.243432d0,
     .0.228180d0,0.232623d0,0.209680d0,0.132303d0,0.814106d-1,
     .0.111777d0,0.548937d-1,0.191029d-1,0.187403d-1,0.143245d-1,
     .0.130368d-1,0.858329d-2,0.995274d-2,0.118245d-1,0.129652d-1,
     .0.102848d-1,0.548329d-2,0.779966d-2,0.615908d-2,0.487568d-2,
     .0.342878d-2,0.244605d-2,0.213393d-2,0.217185d-2,0.206720d-2,
     .0.186863d-2/
      DATA L3B/0.374596d0,0.730751d0,0.604972d0,0.385757d0,
     .0.271575d0,0.259020d0,0.161298d0,0.153750d0,0.163088d0,
     .0.257945d0,0.283227d0,0.289577d0,0.199457d0,0.129605d0,
     .0.126958d0,0.487894d-1,0.283099d-1,0.287228d-1,0.224613d-1,
     .0.188684d-1,0.117466d-1,0.120664d-1,0.138738d-1,0.144952d-1,
     .0.123484d-1,0.853456d-2,0.112575d-1,0.906258d-2,0.801244d-2,
     .0.578640d-2,0.451774d-2,0.347948d-2,0.341194d-2,0.383358d-2,
     .0.393010d-2/
      DATA M4/3.0d2,4.0d2,4.2d2,4.6d2,5.0d2,6.0d2,7.0d2,8.0d2,9.0d2,
     .1.0d3,1.2d3,1.4d3,1.6d3,2.0d3/
      DATA L4/5.9829d-1,9.2330d-2,5.8537d-2,6.6281d-2,9.5266d-2,
     .2.6663d-2,1.4450d-2,1.4037d-2,1.0772d-2,7.1061d-3,4.7603d-3,
     .3.3316d-3,2.1455d-3,2.4617d-3/

      PROB(76)=0d0
      PROB(77)=0d0

      DO I=2,5
       MA=dsqrt(MH0(I))
       SIGJ=0d0
       SIGB=0d0

       DO J=1,4
        MH=dsqrt(MH0(J))
        IF(DDIM(MH/MHMAX,1d0)-DDIM(1d0,MH/MHMIN).EQ.0d0)THEN
         SIGJ=SIGJ+(CJ(I)**2+CJP(I)**2)*ggF13(MA)*BRHAZ(I,J)*BRBB(J)
         SIGB=SIGB+(CB(I)**2+CBP(I)**2)*bbH13(MA)*BRHAZ(I,J)*BRBB(J)
        ENDIF
       ENDDO

       IF(SIGJ.NE.0d0)THEN

        J=1
        DOWHILE(M1(J).LE.MA .AND. J.LT.N1)
          J=J+1
        ENDDO
        IF(J.GE.2 .AND. MA.LE.M1(N1)) THEN
         L=L1(J-1)+(MA-M1(J-1))/(M1(J)-M1(J-1))*(L1(J)-L1(J-1))
         PROB(76)=PROB(76)+DDIM(SIGJ/L,1d0)
        ENDIF

        J=1
        DOWHILE(M2(J).LE.MA .AND. J.LT.N2)
          J=J+1
        ENDDO
        IF(J.GE.2 .AND. MA.LE.M2(N2)) THEN
         L=L2(J-1)+(MA-M2(J-1))/(M2(J)-M2(J-1))*(L2(J)-L2(J-1))
         PROB(76)=PROB(76)+DDIM(SIGB/L,1d0)
        ENDIF

        J=1
        DOWHILE(M3(J).LE.MA .AND. J.LT.N3)
          J=J+1
        ENDDO
        IF(J.GE.2 .AND. MA.LE.M3(N3)) THEN
         L=L3(J-1)+(MA-M3(J-1))/(M3(J)-M3(J-1))*(L3(J)-L3(J-1))
         PROB(77)=PROB(77)+DDIM(SIGJ/L,1d0)
        ENDIF

        J=1
        DOWHILE(M3(J).LE.MA .AND. J.LT.N3)
          J=J+1
        ENDDO
        IF(J.GE.2 .AND. MA.LE.M3(N3)) THEN
         L=L3B(J-1)+(MA-M3(J-1))/(M3(J)-M3(J-1))*(L3B(J)-L3B(J-1))
         PROB(77)=PROB(77)+DDIM(SIGB/L,1d0)
        ENDIF

        J=1
        DOWHILE(M4(J).LE.MA .AND. J.LT.N4)
          J=J+1
        ENDDO
        IF(J.GE.2 .AND. MA.LE.M4(N4)) THEN
         L=L4(J-1)+(MA-M4(J-1))/(M4(J)-M4(J-1))*(L4(J)-L4(J-1))
         PROB(77)=PROB(77)+DDIM(SIGJ/.569d0/L,1d0)
        ENDIF

       ENDIF

      ENDDO

      END


      SUBROUTINE HEAVYH_ZH_CPV(PROB)

*     H/A -> ZA/H ->bb from CMS arXiv:1911.03781 and
*     PROB(78) =/= 0: excluded
*     H/A -> ZA/H ->bb/WW from ATLAS arXiv:2011.05639
*     PROB(79) =/= 0: excluded

      IMPLICIT NONE

      INTEGER I,J,K,NHZH1,NHZH2,NHZH3,NHZH4,NHZHT1,NHZHT2
      INTEGER NHZHT3,NHZHT4,HZHT1(10000,3),HZHT2(10000,3)
      INTEGER HZHT3(10000,3),HZHT4(10000,3),HHHT(10000,3)

      DOUBLE PRECISION PROB(*),MA,MH,SIG,L,D,DMIN,ggF13,bbH13
      DOUBLE PRECISION MHC,XC(2,2),MH0(5),XH(5,5),MA2
      DOUBLE PRECISION CU(5),CUP(5),CD(5),CDP(5),CB(5),CBP(5),CJ(5),
     . CJP(5),CI(5),CG(5),CGP(5),CV(5),CZG(5),CZGP(5),CL(5),CLP(5)
      DOUBLE PRECISION BRJJ(5),BREE(5),BRMM(5),BRLL(5),
     . BRCC(5),BRBB(5),BRTT(5),BRWW(5),BRZZ(5),BRGG(5),BRZG(5)
      DOUBLE PRECISION BRHHH(5,10),BRHCHC(5),BRHAZ(5,4),BRHCW(5),
     . BRHIGGS(5)
      DOUBLE PRECISION HZH1(1000,3),HZH2(10000,3)
      DOUBLE PRECISION HZH3(10000,3),HZH4(10000,3)

      COMMON/HISPEC/MHC,XC,MH0,XH,MA2
      COMMON/HNSMCOUP/CU,CUP,CD,CDP,CB,CBP,CJ,CJP,CI,CG,CGP,CV,CZG,CZGP,
     . CL,CLP
      COMMON/HNSMBR/BRJJ,BREE,BRMM,BRLL,BRCC,BRBB,BRTT,BRWW,BRZZ,
     . BRGG,BRZG
      COMMON/HNHIBR/BRHHH,BRHCHC,BRHAZ,BRHCW,BRHIGGS
      COMMON/LHZH/HZH1,HZH2,HZH3,HZH4,HZHT1,HZHT2,HZHT3,HZHT4,
     .      NHZH1,NHZH2,NHZH3,NHZH4,NHZHT1,NHZHT2,NHZHT3,NHZHT4

      PROB(78)=0d0
      PROB(79)=0d0

* CMS

      DO I=2,5
       MA=dsqrt(MH0(I))
       DO J=1,I-1
        MH=dsqrt(MH0(J))
        SIG=((CJ(I)**2+CJP(I)**2)*ggF13(MA)
     .      +(CB(I)**2+CBP(I)**2)*bbH13(MA))
     .       *BRHAZ(I,J)*BRBB(J)*0.0673d0
        IF(SIG.NE.0d0)THEN
	 CALL TABTRI(HZH1,NHZH1,HZHT1,NHZHT1,MA,MH,L)
         IF(L.NE.0d0)PROB(78)=PROB(78)+DDIM(SIG/L,1d0)
        ENDIF
       ENDDO
      ENDDO

* ATLAS ggF/bb

      DO I=2,5
       MA=dsqrt(MH0(I))
       DO J=1,I-1
        MH=dsqrt(MH0(J))
        SIG=(CJ(I)**2+CJP(I)**2)*ggF13(MA)*BRHAZ(I,J)*BRBB(J)
        IF(SIG.NE.0d0)THEN
	 CALL TABTRI(HZH2,NHZH2,HZHT2,NHZHT2,MA,MH,L)
         IF(L.NE.0d0)PROB(79)=PROB(79)+DDIM(SIG/L,1d0)
        ENDIF
       ENDDO
      ENDDO

* ATLAS bbH/bb

      DO I=2,5
       MA=dsqrt(MH0(I))
       DO J=1,I-1
        MH=dsqrt(MH0(J))
        SIG=(CB(I)**2+CBP(I)**2)*bbH13(MA)*BRHAZ(I,J)*BRBB(J)
        IF(SIG.NE.0d0)THEN
	 CALL TABTRI(HZH3,NHZH3,HZHT3,NHZHT3,MA,MH,L)
         IF(L.NE.0d0)PROB(79)=PROB(79)+DDIM(SIG/L,1d0)
        ENDIF
       ENDDO
      ENDDO

* ATLAS ggF/WW

      DO I=2,5
       MA=dsqrt(MH0(I))
       DO J=1,I-1
        MH=dsqrt(MH0(J))
        SIG=(CJ(I)**2+CJP(I)**2)*ggF13(MA)*BRHAZ(I,J)*BRWW(J)
        IF(SIG.NE.0d0)THEN
	 CALL TABTRI(HZH4,NHZH4,HZHT4,NHZHT4,MA,MH,L)
         IF(L.NE.0d0)PROB(79)=PROB(79)+DDIM(SIG/L,1d0)
        ENDIF
       ENDDO
      ENDDO

      END


      SUBROUTINE HEAVYH_HSMH_CPV(PROB)

*     H/A -> (HSM -> tautau) + (H/A ->bb) from CMS arXiv:2106.10361
*     PROB(80) =/= 0: excluded
*     H/A -> (HSM -> bb) + (H/A ->bb) from CMS PAS-B2G-21-003
*     PROB(81) =/= 0: excluded

      IMPLICIT NONE

      INTEGER I,J,K,N,NHHH,NHHH2,NHHHT,NHHHT2
      INTEGER HHHT(10000,3),HHHT2(10000,3)

      DOUBLE PRECISION PROB(*),MA,MH,MS,SIG,L,ggF13
      DOUBLE PRECISION HHH(10000,3),HHH2(10000,3)
      DOUBLE PRECISION MHC,XC(2,2),MH0(5),XH(5,5),MA2
      DOUBLE PRECISION CU(5),CUP(5),CD(5),CDP(5),CB(5),CBP(5),CJ(5),
     . CJP(5),CI(5),CG(5),CGP(5),CV(5),CZG(5),CZGP(5),CL(5),CLP(5)
      DOUBLE PRECISION BRJJ(5),BREE(5),BRMM(5),BRLL(5),
     . BRCC(5),BRBB(5),BRTT(5),BRWW(5),BRZZ(5),BRGG(5),BRZG(5)
      DOUBLE PRECISION BRHHH(5,10),BRHCHC(5),BRHAZ(5,4),BRHCW(5),
     . BRHIGGS(5)
      DOUBLE PRECISION MHmin,MHmax

      COMMON/HISPEC/MHC,XC,MH0,XH,MA2
      COMMON/HNSMCOUP/CU,CUP,CD,CDP,CB,CBP,CJ,CJP,CI,CG,CGP,CV,CZG,CZGP,
     . CL,CLP
      COMMON/HNSMBR/BRJJ,BREE,BRMM,BRLL,BRCC,BRBB,BRTT,BRWW,BRZZ,
     . BRGG,BRZG
      COMMON/HNHIBR/BRHHH,BRHCHC,BRHAZ,BRHCW,BRHIGGS
      COMMON/HIGGSFIT/MHmin,MHmax
      COMMON/LHHH/HHH,HHH2,HHHT,HHHT2,NHHH,NHHH2,NHHHT,NHHHT2

      PROB(80)=0d0
      PROB(81)=0d0

      DO I=2,5
      MA=dsqrt(MH0(I))

       DO J=1,I-1
        MH=dsqrt(MH0(J))
        IF(MH.GE.MHMIN .AND. MH.LE.MHMAX)THEN

         DO K=1,I-1
          MS=dsqrt(MH0(K))
          IF(J.EQ.1.AND.K.EQ.1)N=1
          IF(J.EQ.1.AND.K.EQ.2 .OR. J.EQ.2.AND.K.EQ.1)N=2
          IF(J.EQ.2.AND.K.EQ.2)N=3
          IF(J.EQ.3.AND.K.EQ.1 .OR. J.EQ.3.AND.K.EQ.1)N=4
          IF(J.EQ.3.AND.K.EQ.2 .OR. J.EQ.3.AND.K.EQ.2)N=5
          IF(J.EQ.3.AND.K.EQ.3)N=6
          IF(J.EQ.4.AND.K.EQ.1 .OR. J.EQ.4.AND.K.EQ.1)N=7
          IF(J.EQ.4.AND.K.EQ.2 .OR. J.EQ.4.AND.K.EQ.2)N=8
          IF(J.EQ.4.AND.K.EQ.3 .OR. J.EQ.4.AND.K.EQ.3)N=9
          IF(J.EQ.4.AND.K.EQ.4)N=10
          SIG=(CJ(I)**2+CJP(I)**2)*ggF13(MA)*BRHHH(I,N)*BRBB(K)
          IF(SIG.NE.0d0)THEN
           CALL TABTRI(HHH,NHHH,HHHT,NHHHT,MA,MS,L)
           IF(L.NE.0d0)PROB(80)=PROB(80)+DDIM(SIG*BRLL(J)/L,1d0)
           CALL TABTRI(HHH2,NHHH2,HHHT2,NHHHT2,MA,MS,L)
           IF(L.NE.0d0)PROB(81)=PROB(81)+DDIM(SIG*BRBB(J)/L,1d0)
          ENDIF
         ENDDO
        ENDIF
       ENDDO
      ENDDO

      END


      SUBROUTINE HEAVYH_HSMHSM_CPV(PROB)

*     H -> (HSM -> bb) + (HSM ->gamgam) from ATLAS arXiv:2112.11876
*     and ATLAS-CONF-2021-052
*     PROB(82) =/= 0: excluded

      IMPLICIT NONE

      INTEGER I,J,K,N,N1,N2
      PARAMETER (N1=22,N2=29)

      DOUBLE PRECISION PROB(*),MH,MHSM,SIG,L,ggF13
      DOUBLE PRECISION M1(N1),L1(N1),M2(N2),L2(N2)
      DOUBLE PRECISION MHC,XC(2,2),MH0(5),XH(5,5),MA2
      DOUBLE PRECISION CU(5),CUP(5),CD(5),CDP(5),CB(5),CBP(5),CJ(5),
     . CJP(5),CI(5),CG(5),CGP(5),CV(5),CZG(5),CZGP(5),CL(5),CLP(5)
      DOUBLE PRECISION BRJJ(5),BREE(5),BRMM(5),BRLL(5),
     . BRCC(5),BRBB(5),BRTT(5),BRWW(5),BRZZ(5),BRGG(5),BRZG(5)
      DOUBLE PRECISION BRHHH(5,10),BRHCHC(5),BRHAZ(5,4),BRHCW(5),
     . BRHIGGS(5)
      DOUBLE PRECISION MHmin,MHmax

      COMMON/HISPEC/MHC,XC,MH0,XH,MA2
      COMMON/HNSMCOUP/CU,CUP,CD,CDP,CB,CBP,CJ,CJP,CI,CG,CGP,CV,CZG,CZGP,
     . CL,CLP
      COMMON/HNSMBR/BRJJ,BREE,BRMM,BRLL,BRCC,BRBB,BRTT,BRWW,BRZZ,
     . BRGG,BRZG
      COMMON/HNHIBR/BRHHH,BRHCHC,BRHAZ,BRHCW,BRHIGGS
      COMMON/HIGGSFIT/MHmin,MHmax

      DATA M1/251d0,260d0,270d0,280d0,290d0,300d0,312.5d0,325d0,
     .337.5d0,350d0,375d0,400d0,425d0,450d0,475d0,500d0,550d0,
     .600d0,700d0,800d0,900d0,1000d0/
      DATA L1/388.084d-3,639.573d-3,595.337d-3,346.985d-3,243.617d-3,
     .363.312d-3,404.646d-3,251.503d-3,262.119d-3,347.905d-3,414.069d-3,
     .204.934d-3,182.217d-3,133.674d-3,142.856d-3,173.434d-3,87.4755d-3,
     .73.635d-3,49.3917d-3,71.0234d-3,77.1504d-3,51.4985d-3/
      DATA M2/250d0,260d0,270d0,280d0,290d0,300d0,312.5d0,325d0,337.5d0,
     .350d0,375d0,400d0,450d0,500d0,600d0,700d0,800d0,900d0,1000d0,
     .1100d0,1200d0,1300d0,1400d0,1500d0,1600d0,1800d0,2000d0,2500d0,
     .3000d0/
      DATA L2/4.04d-1,5.82d-1,5.91d-1,2.39d-1,2.41d-1,2.78d-1,3.95d-1,
     .1.77d-1,2.56d-1,1.5d-1,1.43d-1,5.81d-2,4.31d-2,4.08d-2,1.35d-2,
     .1.5d-2,1.44d-2,1.65d-2,1.06d-2,1.45d-2,1.02d-2,6.18d-3,7.93d-3,
     .7.48d-3,5.34d-3,3.29d-3,2.82d-3,1.98d-3,1.16d-3/


      PROB(82)=0d0

      DO I=2,5
      MH=dsqrt(MH0(I))
       DO J=1,I-1
        MHSM=dsqrt(MH0(I))
        IF(MHSM.GE.MHMIN .AND. MHSM.LE.MHMAX)THEN
         IF(J.EQ.1)N=1
         IF(J.EQ.2)N=3
         IF(J.EQ.3)N=6
         IF(J.EQ.4)N=10
         SIG=(CJ(I)**2+CJP(I)**2)*ggF13(MH)*BRHHH(I,N)
         IF(SIG.NE.0d0)THEN
          K=1
          DO WHILE(M1(K).LE.MH .AND. K.LT.N1)
            K=K+1
          ENDDO
          IF(K.GE.2 .AND. MH.LE.M1(N1)) THEN
           L=L1(K-1)+(MH-M1(K-1))/(M1(K)-M1(K-1))*(L1(K)-L1(K-1))
           PROB(82)=PROB(82)
     .             +DDIM(SIG*BRBB(J)/5.824d-1*BRGG(J)/2.270d-3/L,1d0)
          ENDIF
          K=1
          DO WHILE(M2(K).LE.MH .AND. K.LT.N2)
            K=K+1
          ENDDO
          IF(K.GE.2 .AND. MH.LE.M2(N2)) THEN
           L=L2(K-1)+(MH-M2(K-1))/(M2(K)-M2(K-1))*(L2(K)-L2(K-1))
           PROB(82)=PROB(82)+DDIM(SIG/L,1d0)
          ENDIF
         ENDIF
        ENDIF
       ENDDO
      ENDDO

      END
