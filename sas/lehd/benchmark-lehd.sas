/*============================================================
$Id$
$HeadURL$
 
           How to run this code

  All data is generated internally. No external data
  is needed. Total processing time will be influenced by that.

  Data will be written, processed,  and read from THREE filesystems

     INPUTS:   data gets generated, and stored here
     INTERWRK: intermediate processing occurs here
     OUTPUTS:  final data gets stored here.

  In normal LEHD processing, SAS jobs read
  pre-existing files from INPUTS, intermediate
  files get written to WORK and INTERWRK, 
  and the final datasets get stored in OUTPUTS.
  In general, OUTPUTS and INPUTS are the same
  filesystem. INTERWRK and WORK can be different
  filesystems, but are defined to be one and the
  same here.

  The default assumption in this program is 
  that all three filesystems (INPUTS, INTERWRK, OUTPUTS)
  are one and the same, and are defined by the WORK
  path defined on the SAS command line by the associated
  BASH script:

    sas -work /myfastdisk test.sas

. This behavior can be changed  in the following lines, 
  by changing the libname definitions.
==================================================*/

libname INPUTS (WORK);
* libname INPUTS "/path/to/inputs";
libname INTERWRK (WORK);
* libname INTERWRK "/path/to/interwrk";
libname OUTPUTS (WORK);
* libname OUTPUTS "/path/to/outputs";



/*==================================================
  Please keep separate logs for runs on different filesystems.
  As with all benchmarking, multiple runs are needed to obtain
  reliable answers. 5-10 is a good number of repetitions. Each
  repetition should have its own log.
==================================================*/



/*==================================================
   turn off after testing 
==================================================*/
%let size=small;

%macro checkobs;

%global nobs nvars nvars2;
%if ( "&sysparm" = "" ) %then
    %if ( "&size" = "small" ) %then %do;
       %let nobs=100;
       %let nvars=50;
       %let nvars2=25;
       %end;
    %else %do;
	%let nobs=50000;
	%let nvars=5000;
	%let nvars2=2500;
	%end;

%else %do;
    %let nobs=&sysparm;
    %let nvars=5000;
    %let nvars2=2500;
%end;


%put ;
%put ;
%put    TESTING: Obs = &nobs.;
%put    TESTING: Vars= &nvars.;
%put ;
%mend;

%checkobs;

/* this will show all sas options, most notably memsize, sumsize,
realmemsize, sortsize, cpucount and others */

Proc options;run;

libname _all_ list; /* lists the physical paths of all the current
                       libnames, most notably work */

options msglevel=i; /* will add a note to the log when background
                       dataset conversions are taking place */

options fullstimer STIMEFMT=seconds;

%put sysscp = &sysscp     sysscpl = &sysscpl;
/* tells us whether you are running V8 32 bit or V8 64 bit */
/* this only works on Linux */

filename unixpipe PIPE "cat /proc/cpuinfo | grep processor | wc -l";
data _null_;
infile unixpipe;
input cpucount; 				
put "** cpu count =" cpucount ;
run;


/* used for testing of the SPDE engine */
*libname interim spde '/home/schwa305/sastests' temp=yes;
*options USER=interim;

data INPUTS.create_wide_file;
    do x =1 to &nobs.;
     rand=ranuni(1);
     if rand<=.25 then do;
        flagn=1; flagc='1';
     end;
     else if rand>=.25 and rand<=.5 then do;
        flagn=2; flagc='2';
     end;
     else if rand>=.50 then do;
        flagn=3; flagc='3';
     end;
  array vars x1-x&nvars.;
   do over vars;
      vars=ranuni(2);
   end;
 output INPUTS.create_wide_file;
;
end;
run;


data INTERWRK.copy_wide_file;
     set INPUTS.create_wide_file;
run;

proc sort data=INTERWRK.copy_wide_file out=INTEWRK.sort_copy_wide_file;
by x1 x&nvars2 x&nvars.;
run;

proc summary data=INTERWRK.create_wide_file;
class flagn;
var x x1-x&nvars.;
output out=OUTPUTS.summarize_wide_file sum=;
run;


endsas;
