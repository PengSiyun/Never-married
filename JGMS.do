****Priject: Never Married vs. Continuously married
****Author:  Siyun Peng
****Date:    2020/03/16
****Version: 16.1
****Purpose: data analysis by gender

capture log close
log using Dataanalysis-gender, replace text

use "C:\Users\bluep\Dropbox\peng\Academia\Solo\Never Married\HRS\Data\Final-12-14.dta",replace
/*cd ~/desktop*/
cd "C:\Users\bluep\Dropbox\peng\Academia\Solo\Never Married\HRS\Results\JGMS"
drop nmar
recode mstat (1 2=0) (6=1) (3/5=.),gen(nmar)
egen lb1214=rowmiss(lb12 lb14)
*inclusion criteria
drop if lb1214==2 //drop missing on both waves
drop if missing(nmar) //drop other marital status
count //9184 meeting inclusion criteria
*missing cases
drop if missing(smok, phya, drink, finc, lone, life, race, edu, chsrh) // 516 missing
count //N=8668 
************************************************************************
*Descriptive table (Table 1)
************************************************************************
desctable i.nmar cesd adl i.srh obese chronic i.smok i.phya i.drink finc ///
     lone life age i.race i.edu i.chsrh ///
	 , filename("descriptives-gender") stats(mean sd range n) group(women)

************************************************************************
*Modeling
************************************************************************
/*Coeficient plot figure (Figure 1 & 2)*/
local 	con 	"age i.race i.edu chsrh"	// Controls		
local 	med 	"i.smok i.phya i.drink finc lone life"     // all mediators
est clear
qui nbreg cesd i.nmar `med' `con' if women==0,vce(robust) 
margins, dydx(nmar) post
est store cesd
qui logit srh i.nmar `med' `con' if women==0,vce(robust)
margins, dydx(nmar) post
est store srh
qui logit adl i.nmar `med' `con' if women==0,vce(robust)
margins, dydx(nmar) post
est store adl
qui nbreg chronic i.nmar `med' `con' if women==0,vce(robust) difficult technique(bhhh)
margins, dydx(nmar) post
est store chronic
qui logit obese i.nmar `med' `con' if women==0,vce(robust)
margins, dydx(nmar) post
est store obese
qui reg cogn i.nmar `med' `con' if women==0,vce(robust)
margins, dydx(nmar) post
est store cogn

qui nbreg cesd i.nmar `con' if women==0,vce(robust) 
margins, dydx(nmar) post
est store cesd0
qui logit srh i.nmar `con' if women==0,vce(robust)
margins, dydx(nmar) post
est store srh0
qui logit adl i.nmar `con' if women==0,vce(robust)
margins, dydx(nmar) post
est store adl0
qui nbreg chronic i.nmar `con' if women==0,vce(robust) difficult technique(bhhh)
margins, dydx(nmar) post
est store chronic0
qui logit obese i.nmar `con' if women==0,vce(robust)
margins, dydx(nmar) post
est store obese0
qui reg cogn i.nmar `con' if women==0,vce(robust)
margins, dydx(nmar) post
est store cogn0

qui nbreg cesd i.nmar `med' `con' if women==1,vce(robust) 
margins, dydx(nmar) post
est store cesdw
qui logit srh i.nmar `med' `con' if women==1,vce(robust)
margins, dydx(nmar) post
est store srhw
qui logit adl i.nmar `med' `con' if women==1,vce(robust)
margins, dydx(nmar) post
est store adlw
qui nbreg chronic i.nmar `med' `con' if women==1,vce(robust) difficult technique(bhhh)
margins, dydx(nmar) post
est store chronicw
qui logit obese i.nmar `med' `con' if women==1,vce(robust)
margins, dydx(nmar) post
est store obesew
qui reg cogn i.nmar `med' `con' if women==1,vce(robust)
margins, dydx(nmar) post
est store cognw

qui nbreg cesd i.nmar `con' if women==1,vce(robust) 
margins, dydx(nmar) post
est store cesdw0
qui logit srh i.nmar `con' if women==1,vce(robust)
margins, dydx(nmar) post
est store srhw0
qui logit adl i.nmar `con' if women==1,vce(robust)
margins, dydx(nmar) post
est store adlw0
qui nbreg chronic i.nmar `con' if women==1,vce(robust) difficult technique(bhhh)
margins, dydx(nmar) post
est store chronicw0
qui logit obese i.nmar `con' if women==1,vce(robust)
margins, dydx(nmar) post
est store obesew0
qui reg cogn i.nmar `con' if women==1,vce(robust)
margins, dydx(nmar) post
est store cognw0

coefplot (cesd, aseq(# depressive symptoms) \ srh, aseq(Poor/Fair health) ///
         \ adl, aseq(ADL limitation) ///
		 \ chronic, aseq(# chronic diseases)) ///
		 , bylabel("Models With Mediators (Men)") || ///
		 (cesdw, aseq(# depressive symptoms) \ srhw, aseq(Poor/Fair health) ///
         \ adlw, aseq(ADL limitation) ///
		 \ chronicw, aseq(# chronic diseases)) ///
		 , bylabel("Models With Mediators (Women)") ///
		 keep(1.nmar) xline(0) legend(off) ///
		 mlabel format(%9.2f) mlabposition(12) mlabsize(medium) ///
		 ytit("Marginal effect of being never married (ref. = married)") ///
		 coeflabels(1.nmar=" ") ylabel(,labsize(medlarge)) xlabel(-0.2(0.2)0.8)
graph export ~/desktop/Coeffigure-gender-mediators.tif,replace

coefplot (cesd0, aseq(# depressive symptoms) \ srh0, aseq(Poor/Fair health) ///
         \ adl0, aseq(ADL limitation)  ///
		 \ chronic0, aseq(# chronic diseases)) ///
		 , bylabel("Men") ||  ///
		 (cesdw0, aseq(# depressive symptoms) \ srhw0, aseq(Poor/Fair health) ///
         \ adlw0, aseq(ADL limitation) ///
		 \ chronicw0, aseq(# chronic diseases)) ///
		 , bylabel("Women") ///
		 keep(1.nmar) xline(0) legend(off) ///
		 mlabel format(%9.2f) mlabposition(12) mlabsize(medium) ///
		 ytit("Marginal effect of being never married (ref. = married)") ///
		 coeflabels(1.nmar=" ") ylabel(,labsize(medlarge)) xlabel(-0.2(0.2)0.8)
graph export ~/desktop/Coeffigure-gender.tif,replace

coefplot (cesd0, aseq(# depressive symptoms) \ srh0, aseq(Poor/Fair health) ///
         \ adl0, aseq(ADL limitation) \ obese0, aseq(Obesity) ///
		 \ chronic0, aseq(# chronic diseases)) ///
		 , bylabel("Base Models (Men)") || ///
         (cesd, aseq(# depressive symptoms) \ srh, aseq(Poor/Fair health) ///
         \ adl, aseq(ADL limitation) \ obese, aseq(Obesity) ///
		 \ chronic, aseq(# chronic diseases)) ///
		 , bylabel("Models With Mediators (Men)") || ///
		 (cesdw0, aseq(# depressive symptoms) \ srhw0, aseq(Poor/Fair health) ///
         \ adlw0, aseq(ADL limitation) \ obesew0, aseq(Obesity) ///
		 \ chronicw0, aseq(# chronic diseases)) ///
		 , bylabel("Base Models (Women)") || ///
         (cesdw, aseq(# depressive symptoms) \ srhw, aseq(Poor/Fair health) ///
         \ adlw, aseq(ADL limitation) \ obesew, aseq(Obesity) ///
		 \ chronicw, aseq(# chronic diseases)) ///
		 , bylabel("Models With Mediators (Women)") ///
		 keep(1.nmar) xline(0) legend(off) ///
		 mlabel format(%9.2f) mlabposition(12) mlabsize(medium) ///
		 ytit("Marginal effect of being never married (ref. = married)") ///
		 coeflabels(1.nmar=" ") ylabel(,labsize(medlarge)) xlabel(-0.2(0.2)0.8)
graph export ~/desktop/Coeffigure-gender-all.tif,replace

************************************************************************
*Mediation (Table 2)
************************************************************************

/*Self-rated Health*/
*(Table 2)
foreach x of newlist srh1-srh6 {
    gen `x'=srh if women==0
}
foreach x of newlist srhw1-srhw6 {
    gen `x'=srh if women==1
}
*mediation: Finances
local 	con 	"age i.race i.edu chsrh"	// Controls		
local 	heb 	"i.smok i.phya i.drink"     // health behaviors
local 	med 	"finc lone life i.smok i.phya i.drink"     // all mediators
qui gsem (srh1  <- i.nmar `con', logit) ///
         (srh2 <- i.nmar `con' finc, logit) ///
		 (srhw1  <- i.nmar `con', logit) ///
         (srhw2 <- i.nmar `con' finc, logit) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1,   rowname(ADC Men: Base) stat(est se p) clear //average discrete change
qui mlincom 6,   rowname(ADC Women: Base) stat(est se p) add 
qui mlincom 1-3, rowname(Diff Men: Finance) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: Finance) stat(est se p) add
qui mlincom 1-6, rowname(Gender Diff: Base) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: Finance) stat(est se p) add
*mediation: loneliness
qui gsem (srh1  <- i.nmar `con', logit) ///
         (srh2 <- i.nmar `con' lone, logit) ///
		 (srhw1  <- i.nmar `con', logit) ///
         (srhw2 <- i.nmar `con' lone, logit) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: Loneliness) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: Loneliness) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: Loneliness) stat(est se p) add
*mediation: life purpose
qui gsem (srh1  <- i.nmar `con', logit) ///
         (srh2 <- i.nmar `con' life, logit) ///
		 (srhw1  <- i.nmar `con', logit) ///
         (srhw2 <- i.nmar `con' life, logit) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: life) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: life) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: life) stat(est se p) add
*mediation: health behaviors
qui gsem (srh1  <- i.nmar `con', logit) ///
         (srh2 <- i.nmar `con' `heb', logit) ///
		 (srhw1  <- i.nmar `con', logit) ///
         (srhw2 <- i.nmar `con' `heb', logit) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: health behaviors) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: health behaviors) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: health behaviors) stat(est se p) add
*mediation: All
qui gsem (srh1  <- i.nmar `con', logit) ///
         (srh2 <- i.nmar `con' `med', logit) ///
		 (srhw1  <- i.nmar `con', logit) ///
         (srhw2 <- i.nmar `con' `med', logit) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: All) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: All) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: All) stat(est se p) add
mlincom, title("SRH-mediation") 

/*ADL*/
*(Table 3) 
foreach x of newlist adl1-adl6 {
    gen `x'=adl if women==0
}
foreach x of newlist adlw1-adlw6 {
    gen `x'=adl if women==1
}
*mediation: Finances
local 	con 	"age i.race i.edu chsrh"	// Controls		
local 	heb 	"i.smok i.phya i.drink"     // health behaviors
local 	med 	"finc lone life i.smok i.phya i.drink"     // all mediators
qui gsem (adl1  <- i.nmar `con', logit) ///
         (adl2 <- i.nmar `con' finc, logit) ///
		 (adlw1  <- i.nmar `con', logit) ///
         (adlw2 <- i.nmar `con' finc, logit) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1,   rowname(ADC Men: Base) stat(est se p) clear //average discrete change
qui mlincom 6,   rowname(ADC Women: Base) stat(est se p) add 
qui mlincom 1-3, rowname(Diff Men: Finance) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: Finance) stat(est se p) add
qui mlincom 1-6, rowname(Gender Diff: Base) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: Finance) stat(est se p) add
*mediation: loneliness
qui gsem (adl1  <- i.nmar `con', logit) ///
         (adl2 <- i.nmar `con' lone, logit) ///
		 (adlw1  <- i.nmar `con', logit) ///
         (adlw2 <- i.nmar `con' lone, logit) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: Loneliness) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: Loneliness) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: Loneliness) stat(est se p) add
*mediation: life purpose
qui gsem (adl1  <- i.nmar `con', logit) ///
         (adl2 <- i.nmar `con' life, logit) ///
		 (adlw1  <- i.nmar `con', logit) ///
         (adlw2 <- i.nmar `con' life, logit) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: life) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: life) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: life) stat(est se p) add
*mediation: health behaviors
qui gsem (adl1  <- i.nmar `con', logit) ///
         (adl2 <- i.nmar `con' `heb', logit) ///
		 (adlw1  <- i.nmar `con', logit) ///
         (adlw2 <- i.nmar `con' `heb', logit) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: health behaviors) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: health behaviors) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: health behaviors) stat(est se p) add
*mediation: All
qui gsem (adl1  <- i.nmar `con', logit) ///
         (adl2 <- i.nmar `con' `med', logit) ///
		 (adlw1  <- i.nmar `con', logit) ///
         (adlw2 <- i.nmar `con' `med', logit) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: All) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: All) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: All) stat(est se p) add
mlincom, title("adl-mediation") 


/*CESD*/
*(Table 3)
foreach x of newlist cesd1-cesd6 {
    gen `x'=cesd if women==0
}
foreach x of newlist cesdw1-cesdw6 {
    gen `x'=cesd if women==1
}
*mediation: Finances
local 	con 	"age i.race i.edu chsrh"	// Controls		
local 	heb 	"i.smok i.phya i.drink"     // health behaviors
local 	med 	"finc lone life i.smok i.phya i.drink"     // all mediators
qui gsem (cesd1  <- i.nmar `con', nbreg) ///
         (cesd2 <- i.nmar `con' finc, nbreg) ///
		 (cesdw1  <- i.nmar `con', nbreg) ///
         (cesdw2 <- i.nmar `con' finc, nbreg) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1,   rowname(ADC Men: Base) stat(est se p) clear //average discrete change
qui mlincom 6,   rowname(ADC Women: Base) stat(est se p) add 
qui mlincom 1-3, rowname(Diff Men: Finance) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: Finance) stat(est se p) add
qui mlincom 1-6, rowname(Gender Diff: Base) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: Finance) stat(est se p) add
*mediation: loneliness
qui gsem (cesd1  <- i.nmar `con', nbreg) ///
         (cesd2 <- i.nmar `con' lone, nbreg) ///
		 (cesdw1  <- i.nmar `con', nbreg) ///
         (cesdw2 <- i.nmar `con' lone, nbreg) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: Loneliness) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: Loneliness) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: Loneliness) stat(est se p) add
*mediation: life purpose
qui gsem (cesd1  <- i.nmar `con', nbreg) ///
         (cesd2 <- i.nmar `con' life, nbreg) ///
		 (cesdw1  <- i.nmar `con', nbreg) ///
         (cesdw2 <- i.nmar `con' life, nbreg) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: life) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: life) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: life) stat(est se p) add
*mediation: health behaviors
qui gsem (cesd1  <- i.nmar `con', nbreg) ///
         (cesd2 <- i.nmar `con' `heb', nbreg) ///
		 (cesdw1  <- i.nmar `con', nbreg) ///
         (cesdw2 <- i.nmar `con' `heb', nbreg) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: health behaviors) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: health behaviors) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: health behaviors) stat(est se p) add
*mediation: All
qui gsem (cesd1  <- i.nmar `con', nbreg) ///
         (cesd2 <- i.nmar `con' `med', nbreg) ///
		 (cesdw1  <- i.nmar `con', nbreg) ///
         (cesdw2 <- i.nmar `con' `med', nbreg) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: All) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: All) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: All) stat(est se p) add
mlincom, title("cesd-mediation") 

/*obesity*/
*(Table 3)
foreach x of newlist obese1-obese6 {
    gen `x'=obese if women==0
}
foreach x of newlist obesew1-obesew6 {
    gen `x'=obese if women==1
}
*mediation: Finances
local 	con 	"age i.race i.edu chsrh"	// Controls		
local 	heb 	"i.smok i.phya i.drink"     // health behaviors
local 	med 	"finc lone life i.smok i.phya i.drink"     // all mediators
qui gsem (obese1  <- i.nmar `con', logit) ///
         (obese2 <- i.nmar `con' finc, logit) ///
		 (obesew1  <- i.nmar `con', logit) ///
         (obesew2 <- i.nmar `con' finc, logit) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1,   rowname(ADC Men: Base) stat(est se p) clear //average discrete change
qui mlincom 6,   rowname(ADC Women: Base) stat(est se p) add 
qui mlincom 1-3, rowname(Diff Men: Finance) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: Finance) stat(est se p) add
qui mlincom 1-6, rowname(Gender Diff: Base) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: Finance) stat(est se p) add
*mediation: loneliness
qui gsem (obese1  <- i.nmar `con', logit) ///
         (obese2 <- i.nmar `con' lone, logit) ///
		 (obesew1  <- i.nmar `con', logit) ///
         (obesew2 <- i.nmar `con' lone, logit) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: Loneliness) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: Loneliness) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: Loneliness) stat(est se p) add
*mediation: life purpose
qui gsem (obese1  <- i.nmar `con', logit) ///
         (obese2 <- i.nmar `con' life, logit) ///
		 (obesew1  <- i.nmar `con', logit) ///
         (obesew2 <- i.nmar `con' life, logit) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: life) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: life) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: life) stat(est se p) add
*mediation: health behaviors
qui gsem (obese1  <- i.nmar `con', logit) ///
         (obese2 <- i.nmar `con' `heb', logit) ///
		 (obesew1  <- i.nmar `con', logit) ///
         (obesew2 <- i.nmar `con' `heb', logit) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: health behaviors) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: health behaviors) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: health behaviors) stat(est se p) add
*mediation: All
qui gsem (obese1  <- i.nmar `con', logit) ///
         (obese2 <- i.nmar `con' `med', logit) ///
		 (obesew1  <- i.nmar `con', logit) ///
         (obesew2 <- i.nmar `con' `med', logit) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: All) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: All) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: All) stat(est se p) add
mlincom, title("obese-mediation") 

/*chronic diseases*/
*(Table 3)
foreach x of newlist chronic1-chronic6 {
    gen `x'=chronic if women==0
}
foreach x of newlist chronicw1-chronicw6 {
    gen `x'=chronic if women==1
}

*mediation: Finances
local 	con 	"age i.race i.edu chsrh"	// Controls		
local 	heb 	"i.smok i.phya i.drink"     // health behaviors
local 	med 	"finc lone life i.smok i.phya i.drink"     // all mediators
qui gsem (chronic1  <- i.nmar `con', nbreg) ///
         (chronic2 <- i.nmar `con' finc, nbreg) ///
		 (chronicw1  <- i.nmar `con', nbreg) ///
         (chronicw2 <- i.nmar `con' finc, nbreg) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1,   rowname(ADC Men: Base) stat(est se p) clear //average discrete change
qui mlincom 6,   rowname(ADC Women: Base) stat(est se p) add 
qui mlincom 1-3, rowname(Diff Men: Finance) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: Finance) stat(est se p) add
qui mlincom 1-6, rowname(Gender Diff: Base) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: Finance) stat(est se p) add
*mediation: loneliness
qui gsem (chronic1  <- i.nmar `con', nbreg) ///
         (chronic2 <- i.nmar `con' lone, nbreg) ///
		 (chronicw1  <- i.nmar `con', nbreg) ///
         (chronicw2 <- i.nmar `con' lone, nbreg) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: Loneliness) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: Loneliness) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: Loneliness) stat(est se p) add
*mediation: life purpose
qui gsem (chronic1  <- i.nmar `con', nbreg) ///
         (chronic2 <- i.nmar `con' life, nbreg) ///
		 (chronicw1  <- i.nmar `con', nbreg) ///
         (chronicw2 <- i.nmar `con' life, nbreg) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: life) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: life) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: life) stat(est se p) add
*mediation: health behaviors
qui gsem (chronic1  <- i.nmar `con', nbreg) ///
         (chronic2 <- i.nmar `con' `heb', nbreg) ///
		 (chronicw1  <- i.nmar `con', nbreg) ///
         (chronicw2 <- i.nmar `con' `heb', nbreg) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: health behaviors) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: health behaviors) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: health behaviors) stat(est se p) add
*mediation: All
qui gsem (chronic1  <- i.nmar `con', nbreg) ///
         (chronic2 <- i.nmar `con' `med', nbreg) ///
		 (chronicw1  <- i.nmar `con', nbreg) ///
         (chronicw2 <- i.nmar `con' `med', nbreg) ///
         ,vce(robust)
margins, dydx(nmar) over(women) post  
qui mlincom 1-3, rowname(Diff Men: All) stat(est se p) add
qui mlincom 6-8, rowname(Diff Women: All) stat(est se p) add
qui mlincom (1-3)- (6-8), rowname(Gender Diff: All) stat(est se p) add
mlincom, title("chronic-mediation") 
*khb
local 	con 	"age i.race i.edu chsrh"	// Controls		
local 	heb 	"i.smok i.phya i.drink"     // health behaviors
local 	med 	"finc lone life i.smok i.phya i.drink"     // all mediators

eststo med1: khb nbreg chronic i.nmar || finc if women==0, c(`con') summary vce(robust) ape
eststo med2: khb nbreg chronic i.nmar || lone if women==0, c(`con') summary vce(robust) ape
eststo med3: khb nbreg chronic i.nmar || life if women==0, c(`con') summary vce(robust) ape
eststo med4: khb nbreg chronic i.nmar || `heb' if women==0, c(`con') summary vce(robust) ape
eststo med5: khb nbreg chronic i.nmar || `med' if women==0, c(`con') summary vce(robust) ape 
eststo medw1: khb nbreg chronic i.nmar || finc if women==1, c(`con') summary vce(robust) ape
eststo medw2: khb nbreg chronic i.nmar || lone if women==1, c(`con') summary vce(robust) ape
eststo medw3: khb nbreg chronic i.nmar || life if women==1, c(`con') summary vce(robust) ape
eststo medw4: khb nbreg chronic i.nmar || `heb' if women==1, c(`con') summary vce(robust) ape
eststo medw5: khb nbreg chronic i.nmar || `med' if women==1, c(`con') summary vce(robust) ape 
 

esttab med1  med2  med3  med4 med5 medw1  medw2  medw3  medw4 medw5 ///
  using ~/desktop/medadl-Base-AME_women.csv, replace label nobaselevels b(%5.3f) ///
  se(%5.3f) star nogap ///
  mtitle("Finance""Loneliness""Life Purpose""Health Behavior""All") ///
  title("Table Med ADL-Base-AME")

************************************************************************
* Analyses with Multiple imputation (Figure A1)
************************************************************************
use "C:\Users\siypeng\Dropbox\peng\Academia\Never Married\HRS\Data\MI-data-12-14.dta",replace
drop if missing(nmar) //for 1st marriage vs. never married

/*Coeficient plot figure*/	 
local 	con 	"age i.race i.edu chsrh"	// Controls		
local 	med 	"i.smok i.phya i.drink finc lone life"     // all mediators

estimates clear

qui mi est: nbreg cesd i.nmar `med' `con' if women==0,vce(robust) 
*mimrgns, dydx(nmar) 
est store cesd
qui mi est: logit srh i.nmar `med' `con' if women==0,vce(robust)
*mimrgns, dydx(nmar) predict(pr) post
est store srh
qui mi est: logit adl i.nmar `med' `con' if women==0,vce(robust)
est store adl
qui mi est: nbreg chronic i.nmar `med' `con' if women==0,vce(robust)
est store chronic
qui mi est: logit obese i.nmar `med' `con' if women==0,vce(robust)
est store obese

qui mi est: nbreg cesd i.nmar `con' if women==0,vce(robust) 
est store cesd0
qui mi est: logit srh i.nmar `con' if women==0,vce(robust)
est store srh0
qui mi est: logit adl i.nmar `con' if women==0,vce(robust)
est store adl0
qui mi est: nbreg chronic i.nmar `con' if women==0,vce(robust) iterate(100)
est store chronic0
qui mi est: logit obese i.nmar `con' if women==0,vce(robust)
est store obese0

qui mi est: nbreg cesd i.nmar `med' `con' if women==1,vce(robust) 
est store cesdw
qui mi est: logit srh i.nmar `med' `con' if women==1,vce(robust)
est store srhw
qui mi est: logit adl i.nmar `med' `con' if women==1,vce(robust)
est store adlw
qui mi est: nbreg chronic i.nmar `med' `con' if women==1,vce(robust)
est store chronicw
qui mi est: logit obese i.nmar `med' `con' if women==1,vce(robust)
est store obesew

qui mi est: nbreg cesd i.nmar `con' if women==1,vce(robust) 
est store cesdw0
qui mi est: logit srh i.nmar `con' if women==1,vce(robust)
est store srhw0
qui mi est: logit adl i.nmar `con' if women==1,vce(robust)
est store adlw0
qui mi est: nbreg chronic i.nmar `con' if women==1,vce(robust) iterate(100)
est store chronicw0
qui mi est: logit obese i.nmar `con' if women==1,vce(robust)
est store obesew0

coefplot (cesd0, aseq(# depressive symptoms) \ srh0, aseq(Poor/Fair health) ///
         \ adl0, aseq(ADL limitation) \ obese0, aseq(Obesity) ///
		 \ chronic0, aseq(# chronic diseases)) ///
		 , bylabel("Base Models (Men)") || ///
         (cesd, aseq(# depressive symptoms) \ srh, aseq(Poor/Fair health) ///
         \ adl, aseq(ADL limitation) \ obese, aseq(Obesity) ///
		 \ chronic, aseq(# chronic diseases)) ///
		 , bylabel("Models With Mediators (Men)") || ///
		 (cesdw0, aseq(# depressive symptoms) \ srhw0, aseq(Poor/Fair health) ///
         \ adlw0, aseq(ADL limitation) \ obesew0, aseq(Obesity) ///
		 \ chronicw0, aseq(# chronic diseases)) ///
		 , bylabel("Base Models (Women)") || ///
         (cesdw, aseq(# depressive symptoms) \ srhw, aseq(Poor/Fair health) ///
         \ adlw, aseq(ADL limitation) \ obesew, aseq(Obesity) ///
		 \ chronicw, aseq(# chronic diseases)) ///
		 , bylabel("Models With Mediators (Women)") ///
		 keep(1.nmar) xline(1) legend(off) ///
		 mlabel format(%9.2f) mlabposition(12) mlabsize(small) ///
		 ytit("Never married (ref. = 1st marriage)") ///
		 coeflabels(1.nmar=" ") ylabel(,labsize(medlarge))
graph export ~/desktop/Coeffigure-Mediators-MI.tif,replace

coefplot (cesd0, aseq(# depressive symptoms) \ srh0, aseq(Poor/Fair health) ///
         \ adl0, aseq(ADL limitation) \ obese0, aseq(Obesity) ///
		 \ chronic0, aseq(# chronic diseases)) ///
		 , bylabel("Men") || ///
		 (cesdw0, aseq(# depressive symptoms) \ srhw0, aseq(Poor/Fair health) ///
         \ adlw0, aseq(ADL limitation) \ obesew0, aseq(Obesity) ///
		 \ chronicw0, aseq(# chronic diseases)) ///
		 , bylabel("Women") eform ///
		 keep(1.nmar) xline(1) legend(off) xscale(range(-.2 1)) ///
		 mlabel format(%9.2f) mlabposition(12) mlabsize(medium) ///
		 ytit("Never married (ref. = 1st marriage)") ///
		 coeflabels(1.nmar=" ") ylabel(,labsize(medlarge))
graph export ~/desktop/Coeffigure-MI.tif,replace

*Mediation
local 	con 	"age i.race i.edu chsrh"	// Controls		
local 	med 	"i.smok i.phya i.drink finc lone life"     // all mediators

mi est, cmdok: khb logit adl i.nmar || `med' if women==1, c(`con') summary  vce(robust) d //khb is not officially supported by mi est


************************************************************************
* All marital status
************************************************************************
drop if missing(mstat, smok, phya, drink, finc, lone, life, race, edu, chsrh) //for all marital status
local 	con 	"age i.race i.edu chsrh"	// Controls		
local 	med 	"i.smok i.phya i.drink finc lone life"     // all mediators
est clear
qui nbreg cesd ib6.mstat `med' `con' if women==0,vce(robust) 
margins, dydx(mstat) post
est store cesd
qui logit srh ib6.mstat `med' `con' if women==0,vce(robust)
margins, dydx(mstat) post
est store srh
qui logit adl ib6.mstat `med' `con' if women==0,vce(robust)
margins, dydx(mstat) post
est store adl
qui nbreg chronic ib6.mstat `med' `con' if women==0,vce(robust)
margins, dydx(mstat) post
est store chronic
qui logit obese ib6.mstat `med' `con' if women==0,vce(robust)
margins, dydx(mstat) post
est store obese
qui logit cogn ib6.mstat `med' `con' if women==0,vce(robust)
margins, dydx(mstat) post
est store cogn

qui nbreg cesd ib6.mstat `con' if women==0,vce(robust) 
margins, dydx(mstat) post
est store cesd0
qui logit srh ib6.mstat `con' if women==0,vce(robust)
margins, dydx(mstat) post
est store srh0
qui logit adl ib6.mstat `con' if women==0,vce(robust)
margins, dydx(mstat) post
est store adl0
qui nbreg chronic ib6.mstat `con' if women==0,vce(robust)
margins, dydx(mstat) post
est store chronic0
qui logit obese ib6.mstat `con' if women==0,vce(robust)
margins, dydx(mstat) post
est store obese0
qui logit cogn ib6.mstat `con' if women==0,vce(robust)
margins, dydx(mstat) post
est store cogn0

qui nbreg cesd ib6.mstat `med' `con' if women==1,vce(robust) 
margins, dydx(mstat) post
est store cesdw
qui logit srh ib6.mstat `med' `con' if women==1,vce(robust)
margins, dydx(mstat) post
est store srhw
qui logit adl ib6.mstat `med' `con' if women==1,vce(robust)
margins, dydx(mstat) post
est store adlw
qui nbreg chronic ib6.mstat `med' `con' if women==1,vce(robust)
margins, dydx(mstat) post
est store chronicw
qui logit obese ib6.mstat `med' `con' if women==1,vce(robust)
margins, dydx(mstat) post
est store obesew
qui logit cogn ib6.mstat `med' `con' if women==1,vce(robust)
margins, dydx(mstat) post
est store cognw

qui nbreg cesd ib6.mstat `con' if women==1,vce(robust) 
margins, dydx(mstat) post
est store cesdw0
qui logit srh ib6.mstat `con' if women==1,vce(robust)
margins, dydx(mstat) post
est store srhw0
qui logit adl ib6.mstat `con' if women==1,vce(robust)
margins, dydx(mstat) post
est store adlw0
qui nbreg chronic ib6.mstat `con' if women==1,vce(robust)
margins, dydx(mstat) post
est store chronicw0
qui logit obese ib6.mstat `con' if women==1,vce(robust)
margins, dydx(mstat) post
est store obesew0
qui reg cogn ib6.mstat `con' if women==1,vce(robust)
margins, dydx(mstat) post
est store cognw0

coefplot (cesdw0, label(Women)) (cesd0, label(Men)), bylabel(# depressive symptoms) || ///
         (srhw0) (srh0) , bylabel(Poor/Fair health) || ///
         (adlw0) (adl0) , bylabel(ADL limitation) || ///
         (obesew0) (obese0) , bylabel(Obesity) || ///
		 (chronicw0) (chronic0), bylabel(# chronic diseases) || ///
         , xline(0) ytit("Marginal effect of marital status (ref. = Never married)") ///
		 ylabel(,labsize(medlarge)) byopts(xrescale) //byopts(xrescale) different scales for subgraphs
graph export ~/desktop/All.tif,replace


coefplot (cesdw0, label(Women)) (cesd0, label(Men)), bylabel(# depressive symptoms) || ///
         (chronicw0) (chronic0), bylabel(# chronic diseases) || ///
		 , xline(0) mlabel  mlabposition(12) format(%9.2f) mlabsize(small) ///
		 ytit("Marginal effect of marital status (ref. = Never married)") ///
		 ylabel(,labsize(medlarge))
		 
coefplot (srhw0, label(Women)) (srh0, label(Men)) , bylabel(Poor/Fair health) || ///
         (adlw0, label(Women)) (adl0, label(Men)) , bylabel(ADL limitation) || ///
         (obesew0, label(Women)) (obese0, label(Men)) , bylabel(Obesity) || ///
         , xline(0) mlabel  mlabposition(9) format(%9.2f) mlabsize(small) ///
		 ytit("Marginal effect of marital status (ref. = Never married)") ///
		 ylabel(,labsize(medlarge))
************************************************************************
* bmi instead of obese 
************************************************************************
eststo clear
qui eststo bmi1: reg bmi i.nmar `con' if women==0,vce(robust) 
qui eststo bmi2: reg bmi i.nmar finc `con' if women==0,vce(robust) 
qui eststo bmi3: reg bmi i.nmar lone `con' if women==0,vce(robust) 
qui eststo bmi4: reg bmi i.nmar life `con' if women==0,vce(robust) 
qui eststo bmi5: reg bmi i.nmar `heb' `con' if women==0,vce(robust) 
qui eststo bmi6: reg bmi i.nmar `med' `con' if women==0,vce(robust) 

esttab bmi1 bmi2 bmi3 bmi4 bmi5 bmi6 ///
  using ~/desktop/bmi-men.csv, replace label nobaselevels ///
   star r2(%5.2f) nogap ///
  mtitle("Model 1""Model 2""Model 3""Model 4""Model 5""Model 6") ///
  title("Table bmi-Men")

eststo clear
qui eststo bmi1: reg bmi i.nmar `con' if women==1,vce(robust) 
qui eststo bmi2: reg bmi i.nmar finc `con' if women==1,vce(robust) 
qui eststo bmi3: reg bmi i.nmar lone `con' if women==1,vce(robust) 
qui eststo bmi4: reg bmi i.nmar life `con' if women==1,vce(robust) 
qui eststo bmi5: reg bmi i.nmar `heb' `con' if women==1,vce(robust) 
qui eststo bmi6: reg bmi i.nmar `med' `con' if women==1,vce(robust) 

esttab bmi1 bmi2 bmi3 bmi4 bmi5 bmi6 ///
  using ~/desktop/bmi-women.csv, replace label nobaselevels ///
   star r2(%5.2f) nogap ///
  mtitle("Model 1""Model 2""Model 3""Model 4""Model 5""Model 6") ///
  title("Table bmi-Women")


************************************************************************
* Self-rated health as ordinal variable
************************************************************************
/*Self-rated health*/
eststo clear
qui eststo srho1: ologit srho i.nmar `con' if women==0,vce(robust) 
qui eststo srho2: ologit srho i.nmar finc `con' if women==0,vce(robust) 
qui eststo srho3: ologit srho i.nmar lone `con' if women==0,vce(robust) 
qui eststo srho4: ologit srho i.nmar life `con' if women==0,vce(robust) 
qui eststo srho5: ologit srho i.nmar `heb' `con' if women==0,vce(robust) 
qui eststo srho6: ologit srho i.nmar `med' `con' if women==0,vce(robust) 

esttab srho1 srho2 srho3 srho4 srho5 srho6 ///
  using ~/desktop/srho-men.csv, replace label eform nobaselevels ///
   star r2(%5.2f) nogap ///
  mtitle("Model 1""Model 2""Model 3""Model 4""Model 5""Model 6") ///
  title("Table srho-Men")

eststo clear
qui eststo srho1: ologit srho i.nmar `con' if women==1,vce(robust) 
qui eststo srho2: ologit srho i.nmar finc `con' if women==1,vce(robust) 
qui eststo srho3: ologit srho i.nmar lone `con' if women==1,vce(robust) 
qui eststo srho4: ologit srho i.nmar life `con' if women==1,vce(robust) 
qui eststo srho5: ologit srho i.nmar `heb' `con' if women==1,vce(robust) 
qui eststo srho6: ologit srho i.nmar `med' `con' if women==1,vce(robust) 

esttab srho1 srho2 srho3 srho4 srho5 srho6 ///
  using ~/desktop/srho-women.csv, replace label eform nobaselevels ///
   star r2(%5.2f) nogap ///
  mtitle("Model 1""Model 2""Model 3""Model 4""Model 5""Model 6") ///
  title("Table srho-Women")


*y-standardized
qui ologit srho i.nmar `con' if women==0,vce(robust) 
qui listcoef, std help
qui mat b1=r(table)
qui ologit srho i.nmar finc `con' if women==0,vce(robust) 
qui listcoef, std help
qui mat b2=r(table)
qui ologit srho i.nmar lone `con' if women==0,vce(robust) 
qui listcoef, std help
qui mat b3=r(table)
qui ologit srho i.nmar life `con' if women==0,vce(robust) 
qui listcoef, std help
qui mat b4=r(table)
qui ologit srho i.nmar `heb' `con' if women==0,vce(robust) 
qui listcoef, std help
qui mat b5=r(table)
qui ologit srho i.nmar `med' `con' if women==0,vce(robust) 
qui listcoef, std help
qui mat b6=r(table)

display "Y-standardize (Men) " %5.3f b1[1,5] "  " %5.3f b2[1,5] /// 
        "  " %5.3f b3[1,5] "  " %5.3f b4[1,5] "  " %5.3f b5[1,5] ///
		"  " %5.3f b6[1,5]

qui ologit srho i.nmar `con' if women==1,vce(robust) 
qui listcoef, std help
qui mat b1=r(table)
qui ologit srho i.nmar finc `con' if women==1,vce(robust) 
qui listcoef, std help
qui mat b2=r(table)
qui ologit srho i.nmar lone `con' if women==1,vce(robust) 
qui listcoef, std help
qui mat b3=r(table)
qui ologit srho i.nmar life `con' if women==1,vce(robust) 
qui listcoef, std help
qui mat b4=r(table)
qui ologit srho i.nmar `heb' `con' if women==1,vce(robust) 
qui listcoef, std help
qui mat b5=r(table)
qui ologit srho i.nmar `med' `con' if women==1,vce(robust) 
qui listcoef, std help
qui mat b6=r(table)

display "Y-standardize (Women) " %5.3f b1[1,5] "  " %5.3f b2[1,5] ///
        "  " %5.3f b3[1,5] "  " %5.3f b4[1,5] "  " %5.3f b5[1,5] ///
		"  " %5.3f b6[1,5]

*************		
log close
exit
*************
