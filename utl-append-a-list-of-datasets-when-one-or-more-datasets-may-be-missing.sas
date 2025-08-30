%let pgm=utl-append-a-list-of-datasets-when-one-or-more-datasets-may-be-missing;

%stop_submission;

see github for complete solution

Append a list of datasets when one or more datasets may be missing

 Two Solutions

      1 open code macro if
      2 dosubl
      3 related untranspose repos

%array(_ds, values=L1 L2 L3 L4 L5);

1 OPEN CODE MACRO IF
--------------------
data want;
 set
  %do_over(_ds,phrase=%nrstr(
   %if %sysfunc(exist(?))
     %then %do; ? %end;));
run;quit;

2 DOSUBL
--------
data _null_;
 %do_over(_ds,phrase=%str(
   if exist("?") then
     rc=dosubl("
       proc append data=? base=all;
       run;quit;");));
run;quit;

github
https://tinyurl.com/mrpxxtz9
https://github.com/rogerjdeangelis/utl-append-a-list-of-datasets-when-one-or-more-datasets-may-be-missing

communities.sas
https://tinyurl.com/56vfzucn
https://communities.sas.com/t5/SAS-Programming/SET-data-sets-IF-exits/m-p/755049#M238208

/**************************************************************************************************************************/
/*  INPUT                   | PROCES                                  | OUTPUT                                            */
/*  =====                   | ======                                  | ======                                            */
/*  %array(_ds,             | 1 OPEN CODE MACRO IF                    | WORK>WANT                                         */
/*    values=L1             | ====================                    | ID     X                                          */
/*           L2             |                                         |   1    10                                         */
/*           L3             | data want;                              |   2    20                                         */
/*           L4             |  set                                    |   3    30                                         */
/*           L5);           |   %do_over(_ds,phrase=%nrstr(           |   4    10                                         */
/*                          |    %if %sysfunc(exist(?))               |   5    20                                         */
/*  %put &=_ds1; *L1;       |      %then %do; ? %end;));              |   7    30                                         */
/*  *...;                   | run;quit;                               |   8    60                                         */
/*  %put &=_ds5; *L5;       |                                         |   9    40                                         */
/*  %put &=_dsn; *5;        |                                         |                                                   */
/*                          |                                         |                                                   */
/*  WORK TABLES             |                                         |                                                   */
/*                          |                                         |                                                   */
/*     L1 |   L2 |  L3      | 2 DOSUBL                                | WORK>WANT                                         */
/*  ID  X |      |          | ========                                | ID     X                                          */
/*   1 10 | 1 10 | 1 10     |                                         |   1    10                                         */
/*   2 20 | 2 20 | 2 20     | proc datasets lib=work;                 |   2    20                                         */
/*   3 30 | 3 30 | 3 30     |  delete want;                           |   3    30                                         */
/*                          | run;quit;                               |   4    10                                         */
/*                          |                                         |   5    20                                         */
/*  data l1;                | data _null_;                            |   7    30                                         */
/*  input id  x;            |  %do_over(_ds,phrase=%str(              |   8    60                                         */
/*  cards;                  |    if exist("?") then                   |   9    40                                         */
/*  1 10                    |      rc=dosubl("                        |                                                   */
/*  2 20                    |        proc append data=?               |                                                   */
/*  3 30                    |          base=want;                     |                                                   */
/*  ;                       |        run;quit;");));                  |                                                   */
/*  run;                    | run;quit;                               |                                                   */
/*                          |                                         |                                                   */
/*  data l2;                |                                         |                                                   */
/*  input id  x;            |                                         |                                                   */
/*  cards;                  |                                         |                                                   */
/*  4 10                    |                                         |                                                   */
/*  5 20                    |                                         |                                                   */
/*  7 30                    |                                         |                                                   */
/*  ;                       |                                         |                                                   */
/*  run;                    |                                         |                                                   */
/*                          |                                         |                                                   */
/*  data l5;                |                                         |                                                   */
/*  input id  x;            |                                         |                                                   */
/*  cards;                  |                                         |                                                   */
/*  8 60                    |                                         |                                                   */
/*  9 40                    |                                         |                                                   */
/*  ;                       |                                         |                                                   */
/*  run;                    |                                         |                                                   */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

%array(_ds,
  values=L1
         L2
         L3
         L4
         L5);


%put &=_ds1; *L1;
*...;
%put &=_ds5; *L5;
%put &=_dsn; *5;

data l1;
input id  x;
cards;
1 10
2 20
3 30
;
run;

data l2;
input id  x;
cards;
4 10
5 20
7 30
;
run;

data l5;
input id  x;
cards;
8 60
9 40
;
run;

/**************************************************************************************************************************/
/* %array(_ds, values=L1 L2 L3 L4 L5);                                                                                    */
/*                                                                                                                        */
/* %put &=_ds1; *L1;                                                                                                      */
/* *...;                                                                                                                  */
/* %put &=_ds5; *L5;                                                                                                      */
/* %put &=_dsn; *5;                                                                                                       */
/*                                                                                                                        */
/* WORK.L1    | WORK.L2    | WORK.L5                                                                                      */
/*  ID     X  |  ID     X  | ID     X                                                                                     */
/*   1    10  |   4    10  |  8    60                                                                                     */
/*   2    20  |   5    20  |  9    40                                                                                     */
/*   3    30  |   7    30  |                                                                                              */
/**************************************************************************************************************************/

/*                                          _                                        _  __
/ |   ___  _ __   ___ _ __     ___ ___   __| | ___  _ __ ___   __ _  ___ _ __ ___   (_)/ _|
| |  / _ \| `_ \ / _ \ `_ \   / __/ _ \ / _` |/ _ \| `_ ` _ \ / _` |/ __| `__/ _ \  | | |_
| | | (_) | |_) |  __/ | | | | (_| (_) | (_| |  __/| | | | | | (_| | (__| | | (_) | | |  _|
|_|  \___/| .__/ \___|_| |_|  \___\___/ \__,_|\___||_| |_| |_|\__,_|\___|_|  \___/  |_|_|
          |_|
*/

proc datasets lib=work;
 delete want;
run;quit;

data want;
 set
  %do_over(_ds,phrase=%nrstr(
   %if %sysfunc(exist(?))
     %then %do; ? %end;));
run;quit;


/**************************************************************************************************************************/
/*   D     X                                                                                                              */
/*   1    10                                                                                                              */
/*   2    20                                                                                                              */
/*   3    30                                                                                                              */
/*   4    10                                                                                                              */
/*   5    20                                                                                                              */
/*   7    30                                                                                                              */
/*   8    60                                                                                                              */
/*   9    40                                                                                                              */
/**************************************************************************************************************************/

/*___        _                 _     _
|___ \    __| | ___  ___ _   _| |__ | |
  __) |  / _` |/ _ \/ __| | | | `_ \| |
 / __/  | (_| | (_) \__ \ |_| | |_) | |
|_____|  \__,_|\___/|___/\__,_|_.__/|_|

*/

proc datasets lib=work;
 delete want;
run;quit;

data _null_;
 %do_over(_ds,phrase=%str(
   if exist("?") then
     rc=dosubl("
       proc append data=?
         base=want;
       run;quit;");));
run;quit;

/**************************************************************************************************************************/
/*   D     X                                                                                                              */
/*   1    10                                                                                                              */
/*   2    20                                                                                                              */
/*   3    30                                                                                                              */
/*   4    10                                                                                                              */
/*   5    20                                                                                                              */
/*   7    30                                                                                                              */
/*   8    60                                                                                                              */
/*   9    40                                                                                                              */
/**************************************************************************************************************************/

4 related untranpose

https://github.com/rogerjdeangelis/utl-classic-untranspose-problem-posted-in-stackoverflow-r
https://github.com/rogerjdeangelis/utl-fast-normalization-and-join-using-vvaluex-arrays-sql-hash-untranspose-macro
https://github.com/rogerjdeangelis/utl-normalizing-multiple-horizontal-arrays-of-variables-using-macro-untranspose
https://github.com/rogerjdeangelis/utl-pivot-multiple-columns-to-long-format-untranspose
https://github.com/rogerjdeangelis/utl-simple-transpose-of-two-variables-using-normalization-gather-and-untranspose
https://github.com/rogerjdeangelis/utl-transposing-normalizing-a-table-using-four-techniques-arrays-untranspose-transpose-and-gather
https://github.com/rogerjdeangelis/utl-untranspose-mutiple-arrays-fat-to-skinny-or-normalize
https://github.com/rogerjdeangelis/utl-using-sas-gather-macro-to-untranspose-a-fat-dataset-into-one-obsevation


/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
