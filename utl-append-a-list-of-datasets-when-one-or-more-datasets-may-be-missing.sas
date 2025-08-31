%let pgm=utl-append-a-list-of-datasets-when-one-or-more-datasets-may-be-missing;

%stop_submission;

see github for complete solution

Append a list of datasets when one or more datasets may be missing

 Three Solutions

      0 nodsnferr  (best)
        Bartosz Jablonski
        yabwon@gmail.com
      1 open code macro if
      2 dosubl

0 NODSNFERR
-----------
options nodsnferr;
data want;
 set l1 l2 l3 l4 l5;
run;
options dsnferr;

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
/*  %array(_ds,             |  0 nodsnferr                            | ID     X                                          */
/*    values=L1             |  ===========                            |   1    10                                         */
/*           L2             |  options nodsnferr;                     |   2    20                                         */
/*           L3             |  data want;                             |   3    30                                         */
/*           L4             |   set l1 l2 l3 l4 l5;                   |   4    10                                         */
/*           L5);           |  run;                                   |   5    20                                         */
/*                          |  options dsnferr;                       |   7    30                                         */
/*  %put &=_ds1; *L1;       |                                         |   8    60                                         */
/*  *...;                   |                                         |   9    40                                         */
/*  *...;                   |-------------------------------------------------------------------------------------------- */
/*  %put &=_ds5; *L5;       | 1 OPEN CODE MACRO IF                    | WORK.WANT                                         */
/*  %put &=_dsn; *5;        | ====================                    | ID     X                                          */
/*                          |                                         |   1    10                                         */
/*  WORK TABLES             | data want;                              |   2    20                                         */
/*                          |  set                                    |   3    30                                         */
/*     L1 |   L2 |  L3      |   %do_over(_ds,phrase=%nrstr(           |   4    10                                         */
/*  ID  X |      |          |    %if %sysfunc(exist(?))               |   5    20                                         */
/*   1 10 | 1 10 | 1 10     |      %then %do; ? %end;));              |   7    30                                         */
/*   2 20 | 2 20 | 2 20     | run;quit;                               |   8    60                                         */
/*   3 30 | 3 30 | 3 30     |                                         |   9    40                                         */
/*                          |                                         |                                                   */
/*                          |---------------------------------------------------------------------------------------------*/
/*  data l1;                | 2 DOSUBL                                | WORK.WANT                                         */
/*  input id  x;            | ========                                | ID     X                                          */
/*  cards;                  |                                         |   1    10                                         */
/*  1 10                    | proc datasets lib=work;                 |   2    20                                         */
/*  2 20                    |  delete want;                           |   3    30                                         */
/*  3 30                    | run;quit;                               |   4    10                                         */
/*  ;                       |                                         |   5    20                                         */
/*  run;                    | data _null_;                            |   7    30                                         */
/*                          |  %do_over(_ds,phrase=%str(              |   8    60                                         */
/*  data l2;                |    if exist("?") then                   |   9    40                                         */
/*  input id  x;            |      rc=dosubl("                        |                                                   */
/*  cards;                  |        proc append data=?               |                                                   */
/*  4 10                    |          base=want;                     |                                                   */
/*  5 20                    |        run;quit;");));                  |                                                   */
/*  7 30                    | run;quit;                               |                                                   */
/*  ;                       |                                         |                                                   */
/*  run;                    |                                         |                                                   */
/*                          |                                         |                                                   */
/*  data l5;                |                                         |                                                   */
/*  input id  x;            |                                         |                                                   */
/*  cards;                  |                                         |                                                   */
/*  8 60                    |                                         |                                                   */
/*  9 40                    |                                         |                                                   */
/*  ;                       |                                                                                             */
/*  run;                    |                                                                                             */
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

/*___                    _            __
 / _ \   _ __   ___   __| |___ _ __  / _| ___ _ __ _ __
| | | | | `_ \ / _ \ / _` / __| `_ \| |_ / _ \ `__| `__|
| |_| | | | | | (_) | (_| \__ \ | | |  _|  __/ |  | |
 \___/  |_| |_|\___/ \__,_|___/_| |_|_|  \___|_|  |_|

*/

options nodsnferr;
data want;
 set l1 l2 l3 l4 l5;
run;
options dsnferr;


/**************************************************************************************************************************/
/*  ID     X                                                                                                              */
/*   1    10                                                                                                              */
/*   2    20                                                                                                              */
/*   3    30                                                                                                              */
/*   4    10                                                                                                              */
/*   5    20                                                                                                              */
/*   7    30                                                                                                              */
/*   8    60                                                                                                              */
/*   9    40                                                                                                              */
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
/*  ID     X                                                                                                              */
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
/*  ID     X                                                                                                              */
/*   1    10                                                                                                              */
/*   2    20                                                                                                              */
/*   3    30                                                                                                              */
/*   4    10                                                                                                              */
/*   5    20                                                                                                              */
/*   7    30                                                                                                              */
/*   8    60                                                                                                              */
/*   9    40                                                                                                              */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/

