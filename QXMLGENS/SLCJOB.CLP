/* --------------------------------------------------------------- */
/* SLCJOB     - SCRIPT MEMBER                                      */
/* Use commands  xmlgenINC (generate text for install pgm)         */
/*               xmlgenMBR (to define source members               */
/*               xmlgenCMD (execute qcmdexc at run time            */
/* Put &TOLIB where you want user selected lib at run time.        */
   DCL &TOLIB *CHAR 10
/* --------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)

             XMLGENVRS XSRCFILE(QSLCJOB) XSRCLIB(TOOLS400) XSRCMBR(COPYRIGHT)

             XMLGENSET  XVAR(&SRCFILE) XVALUE(QSLCJOB)

/* ---------------------------------- */
/*  Deploy source member              */
/* ---------------------------------- */
             XMLGENMBR  XMBR(A_INSTALL ) XMBRATR(CLLE  ) +
                          XFROMSRCF(QSLCJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSLCJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_README  ) XMBRATR(TXT   ) +
                          XFROMSRCF(QSLCJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSLCJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COPYRIGHT ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QSLCJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QSLCJOB   ) XOBJTYPE(*CMD    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PSLCJOB   ) XMBRATR(RPGLE   ) +
                          XFROMSRCF(QSLCJOB   ) XFROMSRCL(RADDATZ) +
                          XTOSRCF(QSLCJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(SLCJOB    ) XMBRATR(MAKPGM  ) +
                          XFROMSRCF(QSLCJOB   ) XFROMSRCL(RADDATZ) +
                          XTOSRCF(QSLCJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(SLCJOBFM  ) XMBRATR(DSPF    ) +
                          XFROMSRCF(QSLCJOB   ) XFROMSRCL(RADDATZ) +
                          XTOSRCF(QSLCJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(SLCJOBR1  ) XMBRATR(RPGLE   ) +
                          XFROMSRCF(QSLCJOB   ) XFROMSRCL(RADDATZ) +
                          XTOSRCF(QSLCJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(WORKSTN   ) XMBRATR(RPGLE   ) +
                          XFROMSRCF(QSLCJOB   ) XFROMSRCL(RADDATZ) +
                          XTOSRCF(QSLCJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

/* ---------------------------------- */
/*  Create objects                    */
/* ---------------------------------- */
             XMLGENCMD  XCMD(CRTBNDCL PGM(&TOLIB/A_INSTALL) +
                          SRCFILE(&TOLIB/QSLCJOB) SRCMBR(*PGM) +
                          DFTACTGRP(*NO) ACTGRP(*NEW) +
                          DBGVIEW(*LIST)) XDLTSPLF(A_INSTALL)

             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_INSTALL) +
                             PARM('&TGTRLS' '&SRCFILE' '&TOLIB'))
             XMLGENCMD  XCMD(DLTPGM PGM(&TOLIB/A_INSTALL))

