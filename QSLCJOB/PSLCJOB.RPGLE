**free
/if NOT defined(PSLCJOB)
/define PSLCJOB

/copy QLSTJOB,PLSTJOB

//  Type definitions
/copy QLSTJOB,FDJOBL0100

//  Prototype for job select program
/if defined(SLCJOB_INTERNALLY)
dcl-pr SLCJOB extpgm('SLCJOB');
/else
  dcl-c cSLCJOB_PGM_NAME 'SLCJOB';
  dcl-s g_pgm_slcjob char(21) inz;
dcl-pr SLCJOB extpgm(g_pgm_slcjob);
/endif
  gi_qJob     likeds(qJob_t) const;
  go_qJob     likeds(qJob_t);
  go_cmdKey   char(1);
  gi_pChkSflE pointer(*proc) options(*nopass) const;
end-pr;

//  Procedure interface for job check procedure
/if defined(SLCJOB_INTERNALLY)
dcl-s g_SLCJOB_cb_isJobValid pointer(*proc);
dcl-pr SLCJOB_cb_isJobValid ind extproc(g_SLCJOB_cb_isJobValid);
/else
dcl-pr SLCJOB_cb_isJobValid ind extproc('SLCJOB_cb_isJobValid');
/endif
  i_jobl0100 likeds(jobl0100_t) const;
end-pr;

/endif
