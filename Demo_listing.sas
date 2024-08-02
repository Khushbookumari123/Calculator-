******************************************************************************************************
**
** SPONSOR/CRO                  : 
** PROTOCOL NO.         		: 
** STATSMETRIKA PROJECT NO.     : 
**
** PROGRAM NAME                 : 
** PROGRAM LOCATION             : 
** DESCRIPTION   				: Demographic and Baseline Characteristics by Sequence Group - Randomized Population                     			                                       
**								
** PRROGAM AUTHOR               : Venkat Gopi K
** CREATION DATE                : 
** PROGRAM VERSION NO.          : V1.0
** PROGRAM LAST VERSION NO.     : N/A
**
** DATASETS USED                : 
**
** NAME AND LOCATION OF OUTPUT  : 
**
** DERIVED DATASET LIBRARY      :
** RAW DATASET LIBRARY          : 
** SAS FORMAT LIBRARY           : NA
** EXTERNAL MACRO LIBRARY       : NA
** ---------------------------------------------------------------------------------------------------
** MODIFICATION NOTE            : NA
** CHANGE #      				: NA
** NAME                         : New Program (Name of the Modifier)
** DATE                         : dd MMM yyyy
** DESCRIPTION/REASON           : New Program (Description/Reason for modifiy)
**
******************************************************************************************************;

proc datasets library = work kill noprint;
run;
quit;

libname ana "D:\studies\Avant Santé\AS-AN-MAR-21-0014\Dev\Datasets";

%inc "D:\studies\Avant Santé\AS-AN-MAR-21-0014\Dev\Programs\Tables\MK_Template.sas";

title1 j = r "Versión = Final";
title2 j = L "Proyecto: AS.AN.MAR-21.0014";

proc sort data = ana.adsl out = final(keep=usubjid age Height Weight BMI SEX saffl); 
     by USUBJID; 
run;

data final;
     set final;
	 page_nb=ceil(_n_/30);
run; 

Proc sql; 
select count(DISTINCT usubjid)INTO:TOTAL from final;
quit;
%PUT &TOTAL;


options yearcutoff=1950 nomlogic nomprint nosymbolgen topmargin="1.0in" bottommargin="1.0in" rightmargin="1.0in" leftmargin="1.0in"
nodate nobyline nonumber orientation=landscape LINESIZE=max;
ods escapechar='^';

footnote j=l "Fecha y hora de ejecución: 21DEC2022 & 18:18" j=r "Página: ^{thispage} of ^{lastpage}"; 

ods pdf file= "D:\studies\Avant Santé\AS-AN-MAR-21-0014\Dev\Outputs\Listings\Table_Demo_listing.pdf" style=cnpdf;
proc report data = final split = "~";
	columns page_nb usubjid sex AGE HEIGHT WEIGHT BMI;
	define page_nb / noprint order;
	define usubjid / "Sujeto" style(column)=[width = 19% just=l] style(header)=[just=l];
	define sex / "Género" style(column)=[width = 20% just=l] style(header)=[just=l];
	define age / "Edad" style(column)=[width = 15% just=l] style(header)=[just=l];
	define HEIGHT / "Altura (cm)" style(column)=[width = 15% just=c] style(header)=[just=c];
	define WEIGHT / "Peso (kg)" style(column)=[width = 15% just=c] style(header)=[just=c];
	define BMI / "IMC (kg/m2)" style(column)=[width = 15% just=c] style(header)=[just=c];


	compute after page_nb/style=[just = l FONT_FACE=courier color=black backgroundcolor=white font_size=8pt];
            uline=repeat('_',133);
            line @1 uline $130.;
    endcomp;
	compute before page_nb;
			line "";
	endcomp;
	break after page_nb / page;
	title3 j=c "Tabla 10. Estadística descriptiva de todos los sujetos(N=%sysfunc(compress(&TOTAL)))";


run;

ods pdf close;


