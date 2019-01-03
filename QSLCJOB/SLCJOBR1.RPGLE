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
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
     H EXTBININT(*YES)
      /COPY QSLCJOB,COPYRIGHT
       //=====================================================================*
     FSLCJOBFM  CF   E             WORKSTN usropn
     F                                     extfile(g_dspF)
     F                                     indds(workstnInd)
     F                                     infds(workstnInf)
     F                                     SFILE(PBSFL: g_sflrrn)

     D g_dspF          S             21a   inz
     D g_sflrrn        S              5i 0 inz

     D workstnInd      DS                  qualified
     D sflDsp                 80     80n
     D sflDspCtl              81     81n
     D sflClr                 82     82n
     D sflEnd                 83     83n
     D sflNxtChg              84     84n
     D ##OPTION_RI            85     85n
     D ##OPTION_PC            86     86n
     D isWideScreen           88     88n

     D workstnInf      DS                  likeds(workstn_infds_t)

       // ------------------------------------
       //  Type definitions
       // ------------------------------------
      /COPY QSLCJOB,WORKSTN
      /COPY QLSTJOB,FDJOBI0200
      /COPY QLSTJOB,FDJOBI0400

       // ------------------------------------
       //  External Prototypes
       // ------------------------------------
      /COPY QLSTJOB,PLSTJOB
      /COPY QBASICS1,PBASICS1

     D QCMDEXC...
     D                 PR                         extpgm('QCMDEXC')
     D  i_cmd                     32702A   const  options(*varsize)
     D  i_length                     15P 5 const
     D  i_IGC_control                 3A   const  options(*nopass)

       // Resend Escape Message (QMHRSNEM) API
     D QMHRSNEM...
     D                 PR                         extpgm('QMHRSNEM')
     D  i_msgKey                      4A   const
     D  io_ErrCode                32767A          options(*varsize )
     D  i_callStkE                32767A   const  options(*nopass: *varsize)
     D  i_lenStkE                    10I 0 const  options(*nopass)
     D  i_fmtStkE                     8A   const  options(*nopass)
     D  i_frmStkEAdr                 16A   const  options(*nopass)
     D  i_frmStkECnt                 10I 0 const  options(*nopass)

       // ------------------------------------
       //  Prototypes
       // ------------------------------------
      /DEFINE SLCJOB_INTERNALLY
      /COPY QSLCJOB,PSLCJOB
      /UNDEFINE SLCJOB_INTERNALLY

     D main...
     D                 PR
     D  i_qJob                             const  likeds(qJob_t)
     D  o_qJob                                    likeds(qJob_t)
     D  o_cmdKey                                  like(keyPressed_t)
     D  i_pJobValid                    *   const  procptr

       //  Load subfile
     D loadSubfile...
     D                 PR              N
     D                                     extproc('loadSubfile')
     D  hJobs                              const  like(lstJob_handle_t)

       //  Clear subfile
     D clearSubfile...
     D                 PR
     D                                     extproc('clearSubfile')

       //  Show screen and wait for user input
     D showScreen...
     D                 PR                         like(keyPressed_t)
     D                                     extproc('showScreen')

       //  Perform selected user actions
     D doSubfileOptions...
     D                 PR              N
     D                                     extproc('doSubfileOptions')
     D  o_qJob                                    likeds(qJob_t)

       //  Read selected user actions
     D readc...
     D                 PR              N
     D                                     extproc('readc')
     D  o_SUBFILE                                 likerec(PBSFL)

       //  Check selected job entry
     D isSubfileRecordValid...
     D                 PR              N
     D                                     extproc('isSubfileRecordValid')
     D  i_SUBFILE_IN                       value  likerec(PBSFL: *INPUT)

       //  Check user option
     D isSubfileOptionValid...
     D                 PR              N
     D                                     extproc('isSubfileOptionValid')
     D  i_option                           value  like(##OPTION)

       //  Clear subfile error indicators
     D clearSubfileErrorIndicator...
     D                 PR
     D                                     extproc('clearSubfileErrorIndicator')

       //  Load text of subfile item
     D loadSubfileText...
     D                 PR                         likerec(PBSFL: *OUTPUT)
     D                                     extproc('loadSubfileText')
     D  i_SUBFILE_OUT                             likerec(PBSFL: *OUTPUT)

       //  Prepare image for subfile update
     D prepareSubfileUpdateImage...
     D                 PR                         likerec(PBSFL: *OUTPUT)
     D                                     extproc('prepareSubfileUpdateImage')
     D  i_SUBFILE_IN                              likerec(PBSFL: *INPUT )

       //  Get the unique job
     D getUniqueJob...
     D                 PR              N
     D                                     extproc('getUniqueJob')
     D  hJobs                              const  like(lstJob_handle_t)
     D  q1Job                                     likeds(qJob_t       )

       //  Prüfen, ob der Jobstatus gültig ist.
     D isJobValid...
     D                 PR              N
     D                                     extproc('isJobValid')
     D  jobl0100                           const  likeds(jobl0100_t  )

       //  Initialisieren Programm
     D initProgram...
     D                 PR

       // ------------------------------------
       //  Global fields
       // ------------------------------------
     D g_pssr          DS                  qualified
     D  isActive                       N   inz(cFalse)

       // ------------------------------------
       //  Program Status Information
       // ------------------------------------
     D sds            SDS                  qualified
     D  pgmName                1     10A
     D  statusCode            11     15S 0
     D  statusCodePrv         16     20S 0
     D  srcLineNbr            21     28A
     D  routine               29     36A
     D  numParms              37     39S 0
     D  msgID                 40     46A
     D   excType                      3A   overlay(msgID)
     D   excNbr                       4A   overlay(msgID: *next)
     D  reserved_1            47     50A
     D  msgWorkArea           51     80A
     D  pgmLib                81     90A
     D  msgText               91    170A
     D  excpID               171    174A
     D  lastFileUsed         175    184A
     D  reserved_2           185    190A
     D  jobDate              191    198A
     D  century              199    200S 0
     D  lastFileUsed8        201    208A
     D  lastFileStat         209    243A
     D  job                  244    253A
     D  user                 254    263A
     D  nbr                  264    269A
     D  pgmDate              270    275S 0
     D  date                 276    281S 0
     D  time                 282    287S 0
     D  pgmCrtDate           288    293A
     D  pgmCrtTime           294    299A
     D  compilerLvl          300    303A
     D  srcFile              304    313A
     D  srcLib               314    323A
     D  srcMbr               324    333A
     D  prcOfPgm             334    343A
     D  prcOfMod             344    353A
     D  Reserved             354    429A
     D  curUsrPrf            358    367A
       //
       //===============================================================*
       //  Program Entry Point
       //===============================================================*
     D SLCJOB...
     D                 PI
     D  gi_qJob                            const  likeds(qJob_t    )
     D  go_qJob                                   likeds(qJob_t    )
     D  go_cmdKey                                 like(keyPressed_t)
     D  gi_pJobValid                   *   const  procptr options(*nopass)
       //
     D p_pJobValid     C                   const(4)
       //
     D pJobValid       S               *   procptr            inz
     D errCode         DS                  likeds(errCode_t ) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

       //
       //===============================================================*
       //  Haupsteuerung
       //===============================================================*
      /END-FREE
     P main...
     P                 B
       //
     D main...
     D                 PI
     D  i_qJob                             const  likeds(qJob_t    )
     D  o_qJob                                    likeds(qJob_t    )
     D  o_cmdKey                                  like(keyPressed_t)
     D  i_pJobValid                    *   const  procptr
       //
       //  Schleifensteuerung
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
     D doShowScreen    S               N   inz(cTrue )
     D key             S                   like(keyPressed_t ) inz
       //
       //  Hilfsfelder
     D hJobs           S                   like(lstJob_handle_t)   inz
     D q1Job           DS                  likeds(qJob_t       )   inz
     D jobl0100        DS                  likeds(jobl0100_t   )   inz
     D jobi0200        DS                  likeds(jobi0200_t   )   inz
     D msg             DS                  likeds(msg_t      )     inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

       //
      /END-FREE
     P main...
     P                 E

       //===============================================================*
       //  Load subfile
       //===============================================================*
     P loadSubfile...
     P                 B
     D                 PI              N
     D  hJobs                              const  like(lstJob_handle_t)

     D isData          S               N   inz(cFalse)

     D x               S             10I 0
     D ds_SUBFILE_OUT  DS                  likerec(PBSFL: *OUTPUT) inz
     D msg             DS                  likeds(msg_t) inz
     D jobl0100        DS                  likeds(jobl0100_t) inz
     D jobi0200        DS                  likeds(jobi0200_t) inz
     D jobi0400        DS                  likeds(jobi0400_t) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E

       //===============================================================*
       //  Clear subfile
       //===============================================================*
     P clearSubfile...
     P                 B
     D                 PI

     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E

       //===============================================================*
       //  Show screen and wait for user input
       //===============================================================*
     P showScreen...
     P                 B
     D                 PI                         like(keyPressed_t)

     D key             S                   like(keyPressed_t) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       write MSGCTL;

       if not workstnInd.sflDsp;
          write PBLEER;
       endif;

       write PBBOT;

       exfmt PBCTL;

       key = workstnInf.AID;

       return key;

      /END-FREE
     P                 E

       //===============================================================*
       //  Perform selected user actions
       //===============================================================*
     P doSubfileOptions...
     P                 B
     D                 PI              N
     D  o_qJob                                    likeds(qJob_t    )

     D isChanged       S               N   inz(cTrue)

     D isError         S               N   inz(cFalse)
     D cmd             S           2048A   varying inz
     D option          S                   like(ds_SUBFILE_OUT.##OPTION) inz
     D sflRrn          DS                  qualified inz
     D  firstError                    5I 0
     D  lastChanged                   5I 0
     D ds_SUBFILE_IN   DS                  likerec(PBSFL: *INPUT )
     D ds_SUBFILE_OUT  DS                  likerec(PBSFL: *OUTPUT)

     D cEOF            C                   const(*ON )
     D cCMD_WRKJOB...
     D                 C                   const('WRKJOB +
     D                                              JOB(&NBR/&USER/&JOB)')
     D cCMD_WRKJOB_SPLF...
     D                 C                   const('WRKJOB +
     D                                              JOB(&NBR/&USER/&JOB) +
     D                                              OPTION(*SPLF)')
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E

       //===============================================================*
       //  Read selected user actions
       //===============================================================*
     P readc...
     P                 B
     D                 PI              N
     D  o_SUBFILE                                 likerec(PBSFL)

     D isEOF           S               N   inz(cFalse)
      /FREE

       readc PBSFL o_SUBFILE;
       if %eof(SLCJOBFM);
          isEOF = cTrue;
       else;
          isEOF = cFalse;
       endif;

       return isEOF;

      /END-FREE
     P                 E

       //===============================================================*
       //  Check selected job entry
       //===============================================================*
     P isSubfileRecordValid...
     P                 B
     D                 PI              N
     D  i_SUBFILE_IN                       value  likerec(PBSFL: *INPUT)

     D isValid         S               N   inz(cFalse)

     D isError         S               N   inz(cFalse)
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E

       //===============================================================*
       //  Check user option
       //===============================================================*
     P isSubfileOptionValid...
     P                 B
     D                 PI              N
     D  i_option                           value  like(##OPTION)

     D isValid         S               N   inz(cFalse)
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       if (i_option = 1) or (i_option = 5) or (i_option = 8);
          isValid = cTrue;
          isValid = cTrue;
       else;
          isValid = cFalse;
       endif;

       return isValid;

      /END-FREE
     P                 E

       //===============================================================*
       //  Clear subfile error indicators
       //===============================================================*
     P clearSubfileErrorIndicator...
     P                 B
     D                 PI
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       workstnInd.##OPTION_RI = cFalse;
       workstnInd.##OPTION_PC = cFalse;

       return;

      /END-FREE
     P                 E

       //===============================================================*
       //  Load text of subfile item
       //===============================================================*
     P loadSubfileText...
     P                 B
     D                 PI                         likerec(PBSFL: *OUTPUT)
     D  i_SUBFILE_OUT                             likerec(PBSFL: *OUTPUT)

     D ds_SUBFILE_OUT  DS                  likerec(PBSFL: *OUTPUT) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E

       //===============================================================*
       //  Prepare image for subfile update
       //===============================================================*
     P prepareSubfileUpdateImage...
     P                 B
     D                 PI                         likerec(PBSFL: *OUTPUT)
     D  i_SUBFILE_IN                              likerec(PBSFL: *INPUT )

     D ds_SUBFILE_OUT  DS                  likerec(PBSFL: *OUTPUT) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E

       //===============================================================*
       //  Prüfen auf eindeutige Jobauswahl und ermitteln Job.
       //===============================================================*
     P getUniqueJob...
     P                 B
     D                 PI              N
     D  hJobs                              const  like(lstJob_handle_t)
     D  q1Job                                     likeds(qJob_t       )

     D isUniqueJob     S               N   inz(cFalse)

     D x               S             10I 0
     D numJobs         S             10I 0
     D jobl0100        DS                  likeds(jobl0100_t) inz
     D tmpJobl0100     DS                  likeds(jobl0100) inz
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
     P                 E

       //===============================================================*
       //  Prüfen, ob der Jobstatus gültig ist.
       //===============================================================*
     P isJobValid...
     P                 B
     D                 PI              N
     D  jobl0100                           const  likeds(jobl0100_t  )

     D isValid         S               N   inz(cFalse)
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       isValid = cTrue;

       return isValid;

      /END-FREE
     P                 E

       //===============================================================*
       //  Initialize program
       //===============================================================*
     P initProgram...
     P                 B
     D                 PI
       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

       §PGMQ = '*'; // Message queue that is displayed

       if f_getDisplayMode() = cDISPLAY_MODE_DS3;
          workstnInd.isWideScreen = cFalse;  // Screen size 24x80
       else;
          workstnInd.isWideScreen = cTrue;   // Screen size 27x132
       endif;

       return;

      /END-FREE
     P                 E

