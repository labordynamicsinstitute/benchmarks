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

  To change the load, there are two ways:

  * easy: modify the let size= statement below. 
          If size=small, only a small dataset
          gets created. If size= blank, 
          a large dataset gets created.
  * detailed: if the large dataset is too small,
          modify the following parameters in the code
          below: NOBS, NVARS, NVARS2. NOBS makes the
          file "longer", NVARS make the file wider
          (and the processing more intense).


==================================================*/

/* parameters are inhaled from the config file */
%include "benchmark-lehd.config.sas"/source2;

/* this will show all sas options, most notably memsize, sumsize,
realmemsize, sortsize, cpucount and others */
%put %sysfunc(sysget(HOSTNAME));
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

proc sort data=INTERWRK.copy_wide_file out=INPUTS.sort_copy_wide_file;
by x1 x&nvars2 x&nvars.;
run;

proc summary data=INPUTS.create_wide_file;
class flagn;
var x x1-x&nvars.;
output out=INTERWRK.summarize_wide_file sum=;
run;

%cleanup;  /* this has to be defined in the config program */

endsas;

