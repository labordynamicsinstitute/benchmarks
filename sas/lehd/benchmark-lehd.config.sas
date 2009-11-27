/* $Id$ */
/* $URL$ */
/* Use this define the parameters for the benchmark SAS program */
libname INPUTS (WORK);
* libname INPUTS "/path/to/inputs";
libname INTERWRK (WORK);
* libname INTERWRK "/path/to/interwrk";
libname OUTPUTS (WORK);
* libname OUTPUTS "/path/to/outputs";

%let size=&sysparm;

%macro checkobs;

%global nobs nvars nvars2;
    %if ( "&size" = "large" ) %then %do;
       %let nobs=50000;
       %let nvars=5000;
       %let nvars2=2500;
       %end;
    %else %do;
        %let nobs=500;
        %let nvars=50;
        %let nvars2=25;
        %end;



%put ;
%put ;
%put    TESTING: Obs = &nobs.;
%put    TESTING: Vars= &nvars.;
%put ;
%mend;

%checkobs;

