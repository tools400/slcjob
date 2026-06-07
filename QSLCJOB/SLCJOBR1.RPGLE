**free
//=====================================================================*
//                                                                     *
//  Kurzdokumentation :                                                *
//                                                                     *
//  Bereich . . . : SLCJOB                                             *
//  Objekt  . . . : SLCJOB                                             *
//  Beschreibung  : Select Job                                         *
//  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      *
//  Datum . . . . : 16.08.2007                                         *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  23.05.2013  Th.Raddatz    Fixed problem, that SFLEND was not       *
//                            properly displayed. (End/More...)        *
//                                                                     *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
// >>PRE-COMPILER<<                                                    *
//                                                                     *
//   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *
//                           SRCFILE(&SL/&SF) +                        *
//                           SRCMBR(&SM);                              *
//                                                                     *
//   >>COMPILE<<                                                       *
//     >>PARM<< TRUNCNBR(*NO);                                         *
//     >>PARM<< DBGVIEW(*LIST);                                        *
//     >>PARM<< OPTION(*EVENTF);                                       *
//   >>END-COMPILE<<                                                   *
//                                                                     *
//   >>EXECUTE<<                                                       *
//                                                                     *
// >>END-PRE-COMPILER<<                                                *
//=====================================================================*
ctl-opt debug option(*srcstmt: *nodebugio);
ctl-opt decedit('0,') datedit(*DMY.);
ctl-opt datfmt(*iso) timfmt(*iso);
ctl-opt expropts(*resdecpos);
ctl-opt extbinint(*yes);
/copy QSLCJOB,COPYRIGHT
//=====================================================================*
dcl-f SLCJOBFM workstn(*ext) usage(*input: *output) usropn extfile(g_dspF) indds(workstnInd)
  infds(workstnInf) sfile(PBSFL: g_sflrrn);

dcl-s g_dspF char(21) inz;
dcl-s g_sflrrn int(5) inz;

dcl-ds workstnInd qualified;
  sflDsp       ind pos(80);
  sflDspCtl    ind;
  sflClr       ind;
  sflEnd       ind;
  sflNxtChg    ind;
  ##OPTION_RI  ind;
  ##OPTION_PC  ind;
  isWideScreen ind pos(88);
end-ds;

dcl-ds workstnInf likeds(workstn_infds_t);

// ------------------------------------
//  Type definitions
// ------------------------------------
/copy QSLCJOB,WORKSTN
/copy QLSTJOB,FDJOBI0200
/copy QLSTJOB,FDJOBI0400

// ------------------------------------
//  External Prototypes
// ------------------------------------
/copy QLSTJOB,PLSTJOB
/copy QBASICS1,PBASICS1

dcl-pr QCMDEXC extpgm('QCMDEXC');
  i_cmd         char(32702) options(*varsize) const;
  i_length      packed(15: 5) const;
  i_IGC_control char(3) options(*nopass) const;
end-pr;

// Resend Escape Message (QMHRSNEM) API
dcl-pr QMHRSNEM extpgm('QMHRSNEM');
  i_msgKey     char(4) const;
  io_ErrCode   char(32767) options(*varsize);
  i_callStkE   char(32767) options(*nopass: *varsize) const;
  i_lenStkE    int(10) options(*nopass) const;
  i_fmtStkE    char(8) options(*nopass) const;
  i_frmStkEAdr char(16) options(*nopass) const;
  i_frmStkECnt int(10) options(*nopass) const;
end-pr;

// ------------------------------------
//  Prototypes
// ------------------------------------
/define SLCJOB_INTERNALLY
/copy QSLCJOB,PSLCJOB
/undefine SLCJOB_INTERNALLY

dcl-pr main;
  i_qJob      likeds(qJob_t) const;
  o_qJob      likeds(qJob_t);
  o_cmdKey    like(keyPressed_t);
  i_pJobValid pointer(*proc) const;
end-pr;

//  Load subfile
dcl-pr loadSubfile ind extproc('loadSubfile');
  hJobs like(lstJob_handle_t) const;
end-pr;

//  Clear subfile
dcl-pr clearSubfile extproc('clearSubfile');
end-pr;

//  Show screen and wait for user input
dcl-pr showScreen like(keyPressed_t) extproc('showScreen');
end-pr;

//  Perform selected user actions
dcl-pr doSubfileOptions ind extproc('doSubfileOptions');
  o_qJob likeds(qJob_t);
end-pr;

//  Read selected user actions
dcl-pr readc ind extproc('readc');
  o_SUBFILE likerec(PBSFL);
end-pr;

//  Check selected job entry
dcl-pr isSubfileRecordValid ind extproc('isSubfileRecordValid');
  i_SUBFILE_IN likerec(PBSFL: *input) value;
end-pr;

//  Check user option
dcl-pr isSubfileOptionValid ind extproc('isSubfileOptionValid');
  i_option like(##OPTION) value;
end-pr;

//  Clear subfile error indicators
dcl-pr clearSubfileErrorIndicator extproc('clearSubfileErrorIndicator');
end-pr;

//  Load text of subfile item
dcl-pr loadSubfileText likerec(PBSFL: *OUTPUT) extproc('loadSubfileText');
  i_SUBFILE_OUT likerec(PBSFL: *OUTPUT);
end-pr;

//  Prepare image for subfile update
dcl-pr prepareSubfileUpdateImage likerec(PBSFL: *OUTPUT) extproc('prepareSubfileUpdateImage');
  i_SUBFILE_IN likerec(PBSFL: *input);
end-pr;

//  Get the unique job
dcl-pr getUniqueJob ind extproc('getUniqueJob');
  hJobs like(lstJob_handle_t) const;
  q1Job likeds(qJob_t);
end-pr;

//  Prüfen, ob der Jobstatus gültig ist.
dcl-pr isJobValid ind extproc('isJobValid');
  jobl0100 likeds(jobl0100_t) const;
end-pr;

//  Initialisieren Programm
dcl-pr initProgram;
end-pr;

// ------------------------------------
//  Global fields
// ------------------------------------
dcl-ds g_pssr qualified;
  isActive ind inz(cFalse);
end-ds;

// ------------------------------------
//  Program Status Information
// ------------------------------------
dcl-ds sds qualified psds;
  pgmName       char(10) pos(1);
  statusCode    zoned(5) pos(11);
  statusCodePrv zoned(5) pos(16);
  srcLineNbr    char(8) pos(21);
  routine       char(8) pos(29);
  numParms      zoned(3) pos(37);
  msgID         char(7) pos(40);
  excType       char(3) overlay(msgID);
  excNbr        char(4) overlay(msgID: *next);
  reserved_1    char(4) pos(47);
  msgWorkArea   char(30) pos(51);
  pgmLib        char(10) pos(81);
  msgText       char(80) pos(91);
  excpID        char(4) pos(171);
  lastFileUsed  char(10) pos(175);
  reserved_2    char(6) pos(185);
  jobDate       char(8) pos(191);
  century       zoned(2) pos(199);
  lastFileUsed8 char(8) pos(201);
  lastFileStat  char(35) pos(209);
  job           char(10) pos(244);
  user          char(10) pos(254);
  nbr           char(6) pos(264);
  pgmDate       zoned(6) pos(270);
  date          zoned(6) pos(276);
  time          zoned(6) pos(282);
  pgmCrtDate    char(6) pos(288);
  pgmCrtTime    char(6) pos(294);
  compilerLvl   char(4) pos(300);
  srcFile       char(10) pos(304);
  srcLib        char(10) pos(314);
  srcMbr        char(10) pos(324);
  prcOfPgm      char(10) pos(334);
  prcOfMod      char(10) pos(344);
  Reserved      char(76) pos(354);
  curUsrPrf     char(10) pos(358);
end-ds;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi SLCJOB;
  gi_qJob      likeds(qJob_t) const;
  go_qJob      likeds(qJob_t);
  go_cmdKey    like(keyPressed_t);
  gi_pJobValid pointer(*proc) options(*nopass) const;
end-pi;

dcl-c p_pJobValid 4;

dcl-s pJobValid pointer(*proc) inz;
dcl-ds errCode likeds(errCode_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if %parms() >= p_pJobValid;
  pJobValid = gi_pJobValid;
else;
  pJobValid = *NULL;
endif;

main(gi_qJob: go_qJob: go_cmdKey: pJobValid);

*inlr = *on;

return;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//   Error handle
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

begsr   *PSSR;

  if not g_pssr.isActive;
    g_pssr.isActive = cTrue;

    errCode = f_newApiErRCode(cTrue);
    QMHRSNEM('': errCode);

  endif;

endsr   '*CANCL';


//===============================================================*
//  Haupsteuerung
//===============================================================*
dcl-proc main;
  dcl-pi *n;
    i_qJob      likeds(qJob_t) const;
    o_qJob      likeds(qJob_t);
    o_cmdKey    like(keyPressed_t);
    i_pJobValid pointer(*proc) const;
  end-pi;

  //  Schleifensteuerung
  dcl-s isDone ind inz(cFalse);
  dcl-s isError ind inz(cFalse);
  dcl-s doShowScreen ind inz(cTrue);
  dcl-s key like(keyPressed_t) inz;

  //  Hilfsfelder
  dcl-s hJobs like(lstJob_handle_t) inz;
  dcl-ds q1Job likeds(qJob_t) inz;
  dcl-ds jobl0100 likeds(jobl0100_t) inz;
  dcl-ds jobi0200 likeds(jobi0200_t) inz;
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Initialisieren Programm
  initProgram();

  // Set procedure to check whether is to be listed or not.
  if i_pJobValid <> *NULL;
    g_SLCJOB_cb_isJobValid = i_pJobValid;
  else;
    g_SLCJOB_cb_isJobValid = %paddr('isJobValid');
  endif;

  // Tue es , bis wir fertig sind oder ein Fehler auftritt:
  dou isDone or isError;

    // Abrufen Job-Liste
    f_opnJobLst(i_qJob.name: i_qJob.user: i_qJob.nbr:
                cLSTJOB_STATUS_ALL: cLSTJOB_ORDERBY_NAME_DESC: hJobs);

    // Wenn nur 1 Job den Suchkriterien entspricht, ...
    if getUniqueJob(hJobs: q1Job);
      // ... dann diesen Job direkt als gefunden
      //     zurück geben.
      o_qJob = q1Job;
      // ... fake that ENTER was pressed
      key    = cKeyEnter;
      // ... leave processing loop
      isDone = cTrue;
      leave;
    endif;

    // Öffnen Bildschirmdatei
    g_dspF = %trim(sds.pgmLib) + '/' + 'SLCJOBFM';
    open SLCJOBFM;

    // Füllen Subfile
    loadSubfile(hJobs);

    // Ausgeben Bildschirm
    doShowScreen = cTrue;

    dow doShowScreen;

      key = showScreen();

      // Verarbeiten Eingabe für ...
      select;
      // ... F3
      when key = cKeyF3;
        doShowScreen = cFalse;
      // ... F5
      when key = cKeyF5;
        if (not HANDLE_isNull(hJobs));
          f_cloJobLst(hJobs);
        endif;
        f_opnJobLst(i_qJob.name: i_qJob.user: i_qJob.nbr:
                    cLSTJOB_STATUS_ALL: cLSTJOB_ORDERBY_NAME_DESC:
                    hJobs);
        loadSubfile(hJobs);
        doShowScreen = cTrue;
      // ... F12
      when key = cKeyF12;
        doShowScreen = cFalse;
      // ... ENTER
      when key = cKeyEnter;
        if doSubfileOptions(o_qJob);
          doShowScreen = cTrue;
        else;
          doShowScreen = cFalse;
        endif;
      endsl;

    enddo;

    // Everything is done
    isDone = cTrue;
  enddo;

  o_cmdKey = key;

  // Schließen Bildschirmdatei
  if %open(SLCJOBFM);
    close SLCJOBFM;
    g_dspF = '';
  endif;

  // Schließen Liste der Jobs
  if (not HANDLE_isNull(hJobs));
    f_cloJobLst(hJobs);
  endif;

  return;


end-proc main;

//===============================================================*
//  Load subfile
//===============================================================*
dcl-proc loadSubfile;
  dcl-pi *n ind;
    hJobs like(lstJob_handle_t) const;
  end-pi;

  dcl-s isData ind inz(cFalse);

  dcl-s x int(10);
  dcl-ds ds_SUBFILE_OUT likerec(PBSFL: *OUTPUT) inz;
  dcl-ds msg likeds(msg_t) inz;
  dcl-ds jobl0100 likeds(jobl0100_t) inz;
  dcl-ds jobi0200 likeds(jobi0200_t) inz;
  dcl-ds jobi0400 likeds(jobi0400_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Clear subfile
  clearSubfile();

  // Load jobs
  for x = 1 to f_getNumJobAvl(hJobs);

    // Get first/next job
    if x = 1;
      f_getFirstJob(hJobs: jobl0100);
    else;
      f_getNextJob(hJobs: jobl0100);
    endif;

    if SLCJOB_cb_isJobValid(jobl0100);

      // Retrieve additional job attributes
      jobi0200 = f_rtvJobA(jobl0100.intJobID: 'JOBI0200': msg);
      jobi0400 = f_rtvJobA(jobl0100.intJobID: 'JOBI0400': msg);

      // Clear subfile fields
      clear ds_SUBFILE_OUT;

      // Set hidden fields
      ds_SUBFILE_OUT.H_JOB      = jobi0400.job;
      ds_SUBFILE_OUT.H_USER     = jobi0400.user;
      ds_SUBFILE_OUT.H_NBR      = jobi0400.nbr;
      ds_SUBFILE_OUT.H_TYPE     = jobi0400.type;
      ds_SUBFILE_OUT.H_STATUS   = jobi0400.status;
      ds_SUBFILE_OUT.H_ACTJOBST = jobi0200.actJobSts;
      ds_SUBFILE_OUT.H_DATTIMEN = jobi0400.dateTimeEnt;

      // Clear user option field
      ds_SUBFILE_OUT.##OPTION = 0;

      // Job job text
      ds_SUBFILE_OUT = loadSubfileText(ds_SUBFILE_OUT);

      clearSubfileErrorIndicator();
      workstnInd.sflNxtChg   = cFalse;

      g_sflrrn = g_sflrrn + 1;
      write PBSFL ds_SUBFILE_OUT;

      // Display subfile records
      workstnInd.sflDsp = cTrue;
      isData = cTrue;

    endif;
  endfor;

  workstnInd.sflEnd = cTrue;

  SFSANR = 1;

  return isData;

end-proc;

//===============================================================*
//  Clear subfile
//===============================================================*
dcl-proc clearSubfile;
  dcl-pi *n;
  end-pi;

  dcl-s isDone ind inz(cFalse);
  dcl-s isError ind inz(cFalse);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  workstnInd.sflDsp    = cFalse;
  workstnInd.sflDspCtl = cFalse;
  workstnInd.sflClr    = cTrue;
  workstnInd.sflEnd    = cFalse;

  write PBCTL;

  workstnInd.sflDsp    = cFalse;
  workstnInd.sflDspCtl = cTrue;
  workstnInd.sflClr    = cFalse;
  workstnInd.sflEnd    = cFalse;

  g_sflrrn = 0;

  return;

end-proc;

//===============================================================*
//  Show screen and wait for user input
//===============================================================*
dcl-proc showScreen;
  dcl-pi *n like(keyPressed_t);
  end-pi;

  dcl-s key like(keyPressed_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  write MSGCTL;

  if not workstnInd.sflDsp;
    write PBLEER;
  endif;

  write PBBOT;

  exfmt PBCTL;

  key = workstnInf.AID;

  return key;

end-proc;

//===============================================================*
//  Perform selected user actions
//===============================================================*
dcl-proc doSubfileOptions;
  dcl-pi *n ind;
    o_qJob likeds(qJob_t);
  end-pi;

  dcl-s isChanged ind inz(cTrue);

  dcl-s isError ind inz(cFalse);
  dcl-s cmd varchar(2048) inz;
  dcl-s option like(ds_SUBFILE_OUT.##OPTION) inz;
  dcl-ds sflRrn qualified inz;
    firstError  int(5);
    lastChanged int(5);
  end-ds;
  dcl-ds ds_SUBFILE_IN likerec(PBSFL: *input);
  dcl-ds ds_SUBFILE_OUT likerec(PBSFL: *OUTPUT);

  dcl-c cEOF *on;
  dcl-c cCMD_WRKJOB 'WRKJOB JOB(&NBR/&USER/&JOB)';
  dcl-c cCMD_WRKJOB_SPLF 'WRKJOB JOB(&NBR/&USER/&JOB) OPTION(*SPLF)';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear sflRrn;

  clear o_qJob;

  dow (readc(ds_SUBFILE_IN) <> cEOF) and (o_qJob = '');

    clearSubfileErrorIndicator();

    if ds_SUBFILE_IN.##OPTION = 0;
      isError     = cFalse;
      workstnInd.sflNxtChg = cFalse;
    else;
      if not isSubfileRecordValid(ds_SUBFILE_IN);
        isError = cTrue;
        workstnInd.sflNxtChg = cTrue;
      else;
        isError = cFalse;
        workstnInd.sflNxtChg = cFalse;
      endif;
    endif;

    // Prepare record for subfile update
    ds_SUBFILE_OUT = prepareSubfileUpdateImage(ds_SUBFILE_IN);

    if not isError;
      option = ds_SUBFILE_OUT.##OPTION;
      ds_SUBFILE_OUT.##OPTION = 0;
    endif;

    // Update subfile record
    update PBSFL ds_SUBFILE_OUT;

    // Keep cursor position
    sflrrn.lastChanged = g_sflRrn;

    // Leave the loop on error
    if isError;
      if sflRrn.firstError = 0;
        sflrrn.firstError = g_sflRrn;
      endif;
      leave;
    endif;

    // Execute user option
    select;
    when option = 1;
      o_qJob.name = ds_SUBFILE_OUT.H_JOB;
      o_qJob.user = ds_SUBFILE_OUT.H_USER;
      o_qJob.nbr  = ds_SUBFILE_OUT.H_NBR;
      isChanged = cFalse;
    when option = 5;
      cmd = cCMD_WRKJOB;
      cmd = f_replace('&NBR' : %trim(ds_SUBFILE_OUT.H_NBR ): cmd);
      cmd = f_replace('&USER': %trim(ds_SUBFILE_OUT.H_USER): cmd);
      cmd = f_replace('&JOB' : %trim(ds_SUBFILE_OUT.H_JOB ): cmd);
      QCMDEXC(cmd: %len(cmd));
      isChanged = cTrue;
    when option = 8;
      cmd = cCMD_WRKJOB_SPLF;
      cmd = f_replace('&NBR' : %trim(ds_SUBFILE_OUT.H_NBR ): cmd);
      cmd = f_replace('&USER': %trim(ds_SUBFILE_OUT.H_USER): cmd);
      cmd = f_replace('&JOB' : %trim(ds_SUBFILE_OUT.H_JOB ): cmd);
      QCMDEXC(cmd: %len(cmd));
      isChanged = cTrue;
    endsl;
  enddo;

  // Position cursor
  if sflrrn.firstError > 0;
    SFSANR = sflRrn.firstError;
  endif;

  return isChanged;

end-proc;

//===============================================================*
//  Read selected user actions
//===============================================================*
dcl-proc readc;
  dcl-pi *n ind;
    o_SUBFILE likerec(PBSFL);
  end-pi;

  dcl-s isEOF ind inz(cFalse);

  readc PBSFL o_SUBFILE;
  if %eof(SLCJOBFM);
    isEOF = cTrue;
  else;
    isEOF = cFalse;
  endif;

  return isEOF;

end-proc;

//===============================================================*
//  Check selected job entry
//===============================================================*
dcl-proc isSubfileRecordValid;
  dcl-pi *n ind;
    i_SUBFILE_IN likerec(PBSFL: *input) value;
  end-pi;

  dcl-s isValid ind inz(cFalse);

  dcl-s isError ind inz(cFalse);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dou isError or isValid;
    if not isSubfileOptionValid(i_SUBFILE_IN.##OPTION);
      workstnInd.##OPTION_RI = cTrue;
      workstnInd.##OPTION_PC = cTrue;
      isError = cTrue;
      leave;
    endif;

    isValid = cTrue;
  enddo;

  return isValid;

end-proc;

//===============================================================*
//  Check user option
//===============================================================*
dcl-proc isSubfileOptionValid;
  dcl-pi *n ind;
    i_option like(##OPTION) value;
  end-pi;

  dcl-s isValid ind inz(cFalse);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_option = 1) or (i_option = 5) or (i_option = 8);
    isValid = cTrue;
    isValid = cTrue;
  else;
    isValid = cFalse;
  endif;

  return isValid;

end-proc;

//===============================================================*
//  Clear subfile error indicators
//===============================================================*
dcl-proc clearSubfileErrorIndicator;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  workstnInd.##OPTION_RI = cFalse;
  workstnInd.##OPTION_PC = cFalse;

  return;

end-proc;

//===============================================================*
//  Load text of subfile item
//===============================================================*
dcl-proc loadSubfileText;
  dcl-pi *n likerec(PBSFL: *OUTPUT);
    i_SUBFILE_OUT likerec(PBSFL: *OUTPUT);
  end-pi;

  dcl-ds ds_SUBFILE_OUT likerec(PBSFL: *OUTPUT) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ds_SUBFILE_OUT = i_SUBFILE_OUT;

  ds_SUBFILE_OUT.$$JOB    = ds_SUBFILE_OUT.H_JOB;
  ds_SUBFILE_OUT.$$USER   = ds_SUBFILE_OUT.H_USER;
  ds_SUBFILE_OUT.$$NBR    = ds_SUBFILE_OUT.H_NBR;

  select;
  when ds_SUBFILE_OUT.H_TYPE = 'A';
    ds_SUBFILE_OUT.$$TYPE   = 'AUTO';
  when ds_SUBFILE_OUT.H_TYPE = 'B';
    ds_SUBFILE_OUT.$$TYPE   = 'BATCH';
  when ds_SUBFILE_OUT.H_TYPE = 'I';
    ds_SUBFILE_OUT.$$TYPE   = 'INTER';
  when ds_SUBFILE_OUT.H_TYPE = 'M';
    ds_SUBFILE_OUT.$$TYPE   = 'SBS';
  when ds_SUBFILE_OUT.H_TYPE = 'R';
    ds_SUBFILE_OUT.$$TYPE   = 'RDR';
  when ds_SUBFILE_OUT.H_TYPE = 'S';
    ds_SUBFILE_OUT.$$TYPE   = 'SYS';
  when ds_SUBFILE_OUT.H_TYPE = 'W';
    ds_SUBFILE_OUT.$$TYPE   = 'WTR';
  when ds_SUBFILE_OUT.H_TYPE = 'X';
    ds_SUBFILE_OUT.$$TYPE   = 'SCPF';
  endsl;

  select;
  when ds_SUBFILE_OUT.H_STATUS = '*ACTIVE';
    ds_SUBFILE_OUT.$$STATUS = 'ACTIVE';
  when ds_SUBFILE_OUT.H_STATUS = '*JOBQ';
    ds_SUBFILE_OUT.$$STATUS = 'JOBQ';
  when ds_SUBFILE_OUT.H_STATUS = '*OUTQ';
    ds_SUBFILE_OUT.$$STATUS = 'OUTQ';
  endsl;

  %subst(ds_SUBFILE_OUT.$$STATUS               :
         1 + %len(ds_SUBFILE_OUT.$$STATUS  )
           - %len(ds_SUBFILE_OUT.H_ACTJOBST)   :
         %len(ds_SUBFILE_OUT.H_ACTJOBST)       ) =
              ds_SUBFILE_OUT.H_ACTJOBST;

  ds_SUBFILE_OUT.$$DATE = %char(
         %date(%subst(ds_SUBFILE_OUT.H_DATTIMEN: 1: 7): *CYMD0): *DMY);
  ds_SUBFILE_OUT.$$DATE = %xlate('/': '.': ds_SUBFILE_OUT.$$DATE);

  return ds_SUBFILE_OUT;

end-proc;

//===============================================================*
//  Prepare image for subfile update
//===============================================================*
dcl-proc prepareSubfileUpdateImage;
  dcl-pi *n likerec(PBSFL: *OUTPUT);
    i_SUBFILE_IN likerec(PBSFL: *input);
  end-pi;

  dcl-ds ds_SUBFILE_OUT likerec(PBSFL: *OUTPUT) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Load hidden fields
  ds_SUBFILE_OUT.H_JOB      = i_SUBFILE_IN.H_JOB;
  ds_SUBFILE_OUT.H_USER     = i_SUBFILE_IN.H_USER;
  ds_SUBFILE_OUT.H_NBR      = i_SUBFILE_IN.H_NBR;
  ds_SUBFILE_OUT.H_TYPE     = i_SUBFILE_IN.H_TYPE;
  ds_SUBFILE_OUT.H_STATUS   = i_SUBFILE_IN.H_STATUS;
  ds_SUBFILE_OUT.H_ACTJOBST = i_SUBFILE_IN.H_ACTJOBST;
  ds_SUBFILE_OUT.H_DATTIMEN = i_SUBFILE_IN.H_DATTIMEN;

  // Load visible fields
  ds_SUBFILE_OUT.##OPTION = i_SUBFILE_IN.##OPTION;

  // Load job text
  ds_SUBFILE_OUT = loadSubfileText(ds_SUBFILE_OUT);

  return ds_SUBFILE_OUT;

end-proc;

//===============================================================*
//  Prüfen auf eindeutige Jobauswahl und ermitteln Job.
//===============================================================*
dcl-proc getUniqueJob;
  dcl-pi *n ind;
    hJobs like(lstJob_handle_t) const;
    q1Job likeds(qJob_t);
  end-pi;

  dcl-s isUniqueJob ind inz(cFalse);

  dcl-s x int(10);
  dcl-s numJobs int(10);
  dcl-ds jobl0100 likeds(jobl0100_t) inz;
  dcl-ds tmpJobl0100 likeds(jobl0100) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Read jobs
  x = 1;
  numJobs = 0;

  dow (x <= f_getNumJobAvl(hJobs)) and (numJobs <= 1);

    // Get first/next job
    if x = 1;
      f_getFirstJob(hJobs: jobl0100);
    else;
      f_getNextJob(hJobs: jobl0100);
    endif;

    if SLCJOB_cb_isJobValid(jobl0100);
      tmpJobl0100 = jobl0100;
      numJobs = numJobs + 1;
    endif;

    x = x + 1;
  enddo;

  if numJobs = 1;
    q1Job.name = tmpJobl0100.job;
    q1Job.user = tmpJobl0100.user;
    q1Job.nbr  = tmpJobl0100.nbr;
    isUniqueJob = cTrue;
  endif;

  return isUniqueJob;

end-proc;

//===============================================================*
//  Prüfen, ob der Jobstatus gültig ist.
//===============================================================*
dcl-proc isJobValid;
  dcl-pi *n ind;
    jobl0100 likeds(jobl0100_t) const;
  end-pi;

  dcl-s isValid ind inz(cFalse);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  isValid = cTrue;

  return isValid;

end-proc;

//===============================================================*
//  Initialize program
//===============================================================*
dcl-proc initProgram;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  PGMQ = '*'; // Message queue that is displayed

  if f_getDisplayMode() = cDISPLAY_MODE_DS3;
    workstnInd.isWideScreen = cFalse; // Screen size 24x80
  else;
    workstnInd.isWideScreen = cTrue;  // Screen size 27x132
  endif;

  return;

end-proc;

