Maintaining all significant digits when importing excel sheets

It worked for me using SAS 9.4M2.
I tested 5 algorithms.
Not sure if 'proc import/export' works, because I do not use then.


INPUT
=====
  Workbook d:\xls\sig16.xlsx

      +-------------------+
      |         A         |
      +-------------------+
   1  |       SIG16       |
      +-------------------+
   2  | 0.065554856287590 |
      +-------------------+


SOLUTIONS (these all maintained all the significant digits)
============================================================

  Download utl_maintaining_all_significant_digits_when_importing_excel_sheet.xlsx
  from github or dropbox(see below)
  Rename to sig16.xlsx

  1. libname xel "d:/xls/sig16.xlsx";
     proc sql;
       select
          sig16   format=18.15
         ,sig16 - 0.000000000000090 as chk format=18.15
       from
          xel.'Sheet1$'n
     ;quit;

  2. data _null_;
        set xel.'sheet1$'n;
        put sig16= 18.15;
        chk=sig16-0.000000000000090;
        put chk= 18.15;
     run;quit;

  3. proc sql dquote=ansi;
       connect to excel (Path="d:\xls\sig16.xlsx" mixed=yes);
         select
             sig16                             format=18.15
            ,sig16 -0.000000000000090 as chk format=18.15
             from connection to Excel
             (
              Select
                 sig16
              from
                [sheet1$]
             );
         disconnect from Excel;
     Quit;

  4. %utl_submit_r64('
     source("c:/Program Files/R/R-3.3.1/etc/Rprofile.site",echo=T);
     library(XLConnect);
     wb <- loadWorkbook("d:/xls/sig16.xlsx", create = FALSE);
     sheetin = readWorksheet(wb, sheet = "sheet1");
     format(sheetin$sig16,digits=15,format="f");
     chk<-sheetin$sig16 -0.00000000000009;
     format(chk,digits=15,format="f");
     ');

  5. proc sql dquote=ansi;
       connect to excel (Path="d:\xls\sig16.xlsx" mixed=yes);
         select
             ChrNum
             from connection to Excel
             (
              Select
                 format(sig16,'0.0##################') as ChrNum
              from
                [sheet1$]
             );
         disconnect from Excel;
     Quit;
     libname xel clear;

OUTPUT   from all of them (except 5 which has character 18.15)
==============================================================

SAS

             sig16      subtract                           chk
--------------------------------------------------------------
 0.065554856287590     0.000000000000090    0.065554856287500

R

[1] "0.06555485628759"
[1] "0.0655548562875"

see
https://goo.gl/9gS2GP
https://communities.sas.com/t5/Base-SAS-Programming/Length-of-decimal-importing-excel-sheet/m-p/415969


*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;
Or just copy and paste the result from the post into an excel sheet.

dropbox
https://goo.gl/EsoZqm
https://www.dropbox.com/s/f8br03p8rkpuug2/utl_maintaining_all_significant_digits_when_importing_excel_sheet.xlsx?dl=0

github
https://goo.gl/2htUzg
https://github.com/rogerjdeangelis/utl_maintaining_all_significant_digits_when_importing_excel_sheet/blob/master
/utl_maintaining_all_significant_digits_when_importing_excel_sheet.xlsx

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __  ___
/ __|/ _ \| | | | | __| |/ _ \| '_ \/ __|
\__ \ (_) | | |_| | |_| | (_) | | | \__ \
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/

;

libname xel "d:/xls/sig16.xlsx";
proc sql;
  select
     sig16   format=18.15
    ,sig16 - 0.000000000000090 as chk format=18.15
  from
     xel.'Sheet1$'n
;quit;

data _null_;
   set xel.'sheet1$'n;
   put sig16= 18.15;
   chk=sig16-0.000000000000090;
   put chk= 18.15;
run;quit;

proc sql dquote=ansi;
  connect to excel (Path="d:\xls\sig16.xlsx" mixed=yes);
    select
        sig16                             format=18.15
       ,sig16 -0.000000000000090 as chk format=18.15
        from connection to Excel
        (
         Select
            sig16
         from
           [sheet1$]
        );
    disconnect from Excel;
Quit;

%utl_submit_r64('
source("c:/Program Files/R/R-3.3.1/etc/Rprofile.site",echo=T);
library(XLConnect);
wb <- loadWorkbook("d:/xls/sig16.xlsx", create = FALSE);
sheetin = readWorksheet(wb, sheet = "sheet1");
format(sheetin$sig16,digits=15,format="f");
chk<-sheetin$sig16 -0.00000000000009;
format(chk,digits=15,format="f");
');

proc sql dquote=ansi;
  connect to excel (Path="d:\xls\sig16.xlsx" mixed=yes);
    select
        ChrNum
        from connection to Excel
        (
         Select
            format(sig16,'0.0##################') as ChrNum
         from
           [sheet1$]
        );
    disconnect from Excel;
Quit;
libname xel clear;

