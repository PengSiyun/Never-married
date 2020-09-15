****Priject: Never Married vs. Continuously married
****Author:  Siyun Peng
****Date:    2020/03/16
****Version: 16.1
****Purpose: data cleaning

capture log close
log using Dataclean, replace text

************************************************************************
*Clean data (r12 interviewed in 2014)
************************************************************************
clear
local data "C:\Users\bluep\Desktop\HRS"
local work "C:\Users\bluep\Desktop\HRS\CleanData"

/*Merge Left Behind questionquares with RAND longitudinal file*/
use "`data'\randhrs1992_2016v2.dta",replace
keep r12* ra* hhid pn
drop if r12agey_m<50 | missing(r12mstat)
merge 1:1 hhid pn using "`data'\h14f2a.dta"
drop _merge
keep if olbelig==1 //keep respondents eligible for leftbehind
save "`work'\2014.dta", replace	

use "`data'\randhrs1992_2016v2.dta",replace
keep r11* ra* hhid pn
drop if r11agey_m<50 | missing(r11mstat)
merge 1:1 hhid pn using "`data'\h12f2a.dta"
drop _merge
keep if nlbelig==1 //keep respondents eligible for leftbehind
save "`work'\2012.dta", replace	

/*Combine those who received Left Behind questionquares in 2014 and 2012.*/
append using "`work'\2014.dta"

/*add childhood selfrated health to data*/
merge 1:1 hhid pn using "C:\Users\bluep\Desktop\HRS\CleanData\chsrh2016.dta"

************************************************************************
*Recode Variables
************************************************************************
/*DV*/
gen cesd=r11cesd
replace cesd=r12cesd if missing(r11cesd)
label var cesd "Depressive symptoms" //depressive symptoms


foreach x of varlist r12tr20 r12ser7 r12bwc20 {
        local newname=substr("`x'", 4, .)
		replace `x'=r11`newname' if missing(`x')
}
gen cogn=r12tr20 + r12ser7 + r12bwc20
recode cogn (12/27=0) (0/11=1),gen(cogn_b)
label define cogn_b 0 "Normal cognition" 1 "Possible CIND/dementia" 
label values cogn_b cogn_b 
label var cogn_b "Possible CIND/dementia" //cognition


/*foreach x in orc183m1-orc183m10 { 
        recode `x' (1/40=1) (50/60=0) (60-100=.)
}
*/ //delayed recall (too complicated)

*OCRP_ADJ //inflamation

replace r11shlt=r12shlt if missing(r11shlt)
rename (r11shlt) (srho) 
revrs srho, replace
label define srho 1 "Poor" 2 "Fair" 3 "Good" 4 "Very good" 5 "Excellent"
label values srho srho
label var srho "Self-rated health-Ordinal" 
recode srho (1/2=1) (3/5=0),gen(srh)
label define srh 0 "Good/Very good/Excellent" 1 "Poor/Fair"
label values srh srh
label var srh "Poor/Fair health" //Self rated health

replace r11diabe=r12diabe if missing(r11diabe)
rename (r11diabe) (diabe) 
label define diabe 0 "No" 1 "Yes"
label values diabe diabe
label var diabe "Ever had diabetes" //Diabetes 

replace r11hearte=r12hearte if missing(r11hearte)
rename (r11hearte) (heart) 
label define heart 0 "No" 1 "Yes"
label values heart heart
label var heart "Ever had heart disease" //Heart diseases 

replace r11lunge=r12lunge if missing(r11lunge)
rename (r11lunge) (lung) 
label define lung 0 "No" 1 "Yes"
label values lung lung
label var heart "Ever had Lung disease" //lung diseases 

replace r11cancre=r12cancre if missing(r11cancre)
rename (r11cancre) (cancer) 
label define cancer 0 "No" 1 "Yes"
label values cancer cancer
label var heart "Ever had cancer" //Cancer 

replace r11stroke=r12stroke if missing(r11stroke)
rename (r11stroke) (stroke) 
label define stroke 0 "No" 1 "Yes"
label values stroke stroke
label var stroke "Ever had stroke" //stroke 

replace r11hibpe=r12hibpe if missing(r11hibpe)
rename (r11hibpe) (blood) 
label define blood 0 "No" 1 "Yes"
label values blood blood
label var blood "Ever had hypertension" //high blood pressure 

egen chronic=rowtotal(diabe heart lung cancer stroke blood), missing
label var chronic "# Chronic diseases"

replace r11bmi=r12bmi if missing(r11bmi)
rename (r11bmi) (bmi) 
recode bmi (0/29.99=0) (30/100=1),gen(obese)
label define obese 0 "No" 1 "Yes"
label values obese obese
label var obese "Obesity" //Obesity

replace r11adla=r12adla if missing(r11adla)
recode r11adla (1/5=1),gen(adl)
label define adl 0 "No ADL" 1 "Having any ADL" 
label values adl adl 
label var adl "ADL" //ADL 

/*IV*/
replace r11mstat=9 if r11mrct==1&r11mstat==1
fre r11mstat
recode r11mstat (1=2) (2=.) (4 5=4) (7=5) (8=6) (9=1)

replace r12mstat=9 if r12mrct==1&r12mstat==1
fre r12mstat
recode r12mstat (1=2) (2=.) (4 5=4) (7=5) (8=6) (9=1)

gen mstat=r11mstat
replace mstat=r12mstat if missing(r11mstat)
label define mstat 1 "1st marriage" 2 "2+ marriage" 3 "Partnered" ///
                 4 "Separated/divorced" 5 "Widowed" 6 "Never married"
label values mstat mstat
fre mstat //all categiries 

recode mstat (1=0) (2/5=.) (6=1),gen(nmar) 
label define nmar 0 "1st marriage" 1 "Never married"
label values nmar nmar 
label var nmar "Never married" //never married vs. 1st marriage

/*Mediators*/
replace r11smokev=2 if r11smoken==1
replace r12smokev=2 if r12smoken==1
gen smok=r11smokev 
replace smok=r12smokev if missing(r11smokev)
label define smok 0 "Never smoke" 1 "Ex-smoker" 2 "Current smoker"
label values smok smok
label var smok "Smoking" //smoke

foreach x in r11ltactx r11mdactx r11vgactx {
    local newname=substr("`x'", 4, .)
	replace `x'= r12`newname' if missing(`x')
	recode `x' (1=4) (2=3) (3=2) (4=1) (5=0) 
	gen `newname'= `x'
	}
gen phya=1.2*ltactx+1.4*mdactx+1.8*vgactx
recode phya (0/1.99=0) (2/3.99=1) (4/7.99=2) (8/17.6=3)
label define phya 0 "Sedentary" 1 "Light" 2 "Moderate" 3 "Vigorous"
label values phya phya
label var phya "Physical activity" //physical activity

replace r11drinkn=r12drinkn if missing(r11drinkn)
recode r11drinkn (1/4=1) (5/30=2),gen(drink)
replace drink=2 if r11drinkn==4 & ragender==2
label define drink 0 "Abstainer" 1 "Moderate drinking" 2 "Binge drinking"
label values drink drink
label var drink "Drinking" //drinking

replace olb034e=nlb039e if missing(olb034e)
replace olb034f=nlb039f if missing(olb034f)
revrs olb034e olb034f, replace 
alpha olb034e olb034f,gen(finc) 
label define finc 1 "NOT AT ALL SATISFIED" 2 "NOT VERY SATISFIED" ///
                  3 "SOMEWHAT SATISFIED" 4 "VERY SATISFIED" 5 "COMPLETELY SATISFIED"
label values finc finc
label var finc "Financial situation"
fre finc //financial situation alpha=0.94

foreach x of varlist olb019a-olb019k {
       local newname=substr("`x'", 7, .)
       replace `x' = nlb020`newname' if missing(`x')
}
revrs olb019a-olb019c olb019e,replace  
alpha olb019a-olb019k,gen(lone) 
label var lone "Loneliness" //lonely alpha=0.88

foreach x of varlist olb033a-olb033g {
       local newname=substr("`x'", 7, .)
       replace `x' = nlb035`newname' if missing(`x')
}
revrs olb033b olb033d olb033e olb033f,replace
alpha olb033a-olb033g,gen(life) 
label var life "Life purpose" //life purpose alpha=0.77

/* in Fat files
olb011a-olb011g: family support; olb010 have immediate family
olb015a-olb015g: friends support; olb014 have any friend
*/
foreach x of varlist olb008a olb008b olb008c {
       local newname=substr("`x'", 7, .)
       replace `x' = nlb009`newname' if missing(`x')
}
revrs olb008a olb008b olb008c,replace  
alpha olb008a olb008b olb008c,gen(kcont) 

foreach x of varlist olb012a olb012b olb012c {
       local newname=substr("`x'", 7, .)
       replace `x' = nlb013`newname' if missing(`x')
}
revrs olb012a olb012b olb012c,replace 
alpha olb012a olb012b olb012c,gen(fmcont) 

foreach x of varlist olb016a olb016b olb016c {
       local newname=substr("`x'", 7, .)
       replace `x' = nlb017`newname' if missing(`x')
}
revrs olb016a olb016b olb016c,replace   
alpha olb016a olb016b olb016c ,gen(frcont) 
alpha kcont fmcont frcont,gen(contact)


/*controls*/
replace r11agey_m=r12agey_m if missing(r11agey_m)
rename (r11agey_m) (age)
label var age "Age"
recode ragender (1=0) (2=1),gen(women)
label define women 0 "Men" 1 "Women"
label values women women
label var women "Women"
rename (raracem) (race)
label define race 1 "White" 2 "Black" 3 "Other"
label values race race
label var race "Race"
rename (raeduc) (edu)
label define edu 1 "Lt high-school" 2 "GED" 3 "High school" 4 "Some college" ///
                 5 "College and above"
label values edu edu
label var edu "Education"

************************************************************************
*Compare missing and not missing
************************************************************************
egen miss=rowmiss(smok phya drink finc lone life age women race edu chsrh)
recode miss (1/11=1)
foreach x of varlist nmar cesd srh adl blood obese {
        tab `x' miss,chi col
} //Full sample vs. current: small but siginificant difference (1-2% difference in each cell)

label define miss 1 "by mail" 2 "by phone" 4 "by proxy" 5 "not completed"
label values nlbcomp olbcomp miss
recode nlbcomp olbcomp (5=.),gen(lb12 lb14) 
egen leftbehind=rowmiss(lb12 lb14)
preserve
drop if missing(nmar)
drop if leftbehind==2
count // sample size meet the inclusion criteria
keep if miss==0 //number of missing
count // final sample size
restore

/*save data*/
drop if missing(mstat)
keep mstat nmar cesd srh srho adl chronic diabe heart lung cancer stroke blood obese ///
     smok phya drink finc lone life age women race edu nlbcomp olbcomp bmi cogn lb12 ///
	 lb14 chsrh kcont fmcont frcont contact
save "`work'\Final-12-14.dta", replace

************************************************************************
* Multiple imputation
************************************************************************
replace lb12=lb14 if missing(lb12) // completion method

mi set wide
mi register imp age women race edu finc lone life smok phya drink chsrh
mi imp chain ///
  (mlogit) edu smok phya drink race chsrh ///
  (logit)  women ///
  (regress) age finc lone life ///
   = i.mstat cesd srho i.adl i.lb12 i.cogn_b ///
   i.diabe i.heart i.lung i.cancer i.stroke i.blood i.obese ///
   , add(20) augment rseed(91169) force dots
save "`work'\MI-data-12-14.dta", replace

*************		
log close
exit
*************
