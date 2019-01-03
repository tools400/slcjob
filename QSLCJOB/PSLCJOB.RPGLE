      /IF NOT DEFINED(PSLCJOB)
      /DEFINE PSLCJOB
      *
      /COPY QLSTJOB,PLSTJOB
      *
      *  Type definitions
      /COPY QLSTJOB,FDJOBL0100
      *
      *  Prototype for job select program
      /IF DEFINED(SLCJOB_INTERNALLY)
     D SLCJOB...
     D                 PR                         extpgm('SLCJOB')
      /ELSE
     D cSLCJOB_PGM_NAME...
     D                 C                   'SLCJOB'
     D g_pgm_slcjob    S             21A   inz
     D SLCJOB...
     D                 PR                         extpgm(g_pgm_slcjob)
      /ENDIF
     D  gi_qJob                            const  likeds(qJob_t    )
     D  go_qJob                                   likeds(qJob_t    )
     D  go_cmdKey                     1A
     D  gi_pChkSflE                    *   const  procptr options(*nopass)
      *
      *  Procedure interface for job check procedure
      /IF DEFINED(SLCJOB_INTERNALLY)
     D g_SLCJOB_cb_isJobValid...
     D                 S               *          procptr
     D SLCJOB_cb_isJobValid...
     D                 PR              N          extproc(
     D                                            g_SLCJOB_cb_isJobValid)
      /ELSE
     D SLCJOB_cb_isJobValid...
     D                 PR              N          extproc('+
     D                                            SLCJOB_cb_isJobValid')
      /ENDIF
     D  i_jobl0100                         const  likeds(jobl0100_t  )
      *
      /ENDIF
