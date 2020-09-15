****Priject: Never Married vs. Continuously married
****Author:  Siyun Peng
****Date:    2020/03/16
****Version: 16.1
****Purpose: Create childhood self-rated health

local long "C:\Users\bluep\Desktop\HRS"
*adding core survey 1996-2014
use "`long'\h96f4a.dta",replace
keep e5648  hhid pn
merge 1:1  hhid pn using "`long'\h98f2c.dta"
keep e5648 f992  hhid pn 
merge 1:1  hhid pn using "`long'\h00f1c.dta"
keep e5648 f992 g1079  hhid pn 
merge 1:1  hhid pn using "`long'\h02f2c.dta"
keep e5648 f992 g1079 hb019  hhid pn 
merge 1:1  hhid pn using "`long'\h04f1c.dta"
keep e5648 f992 g1079 hb019 jb019  hhid pn 
merge 1:1  hhid pn using "`long'\h06f3a.dta"
keep e5648 f992 g1079 hb019 jb019 kb019  hhid pn 
merge 1:1  hhid pn using "`long'\h08f3a.dta"
keep e5648 f992 g1079 hb019 jb019 kb019 lb019  hhid pn 
merge 1:1  hhid pn using "`long'\hd10f5e.dta"
keep e5648 f992 g1079 hb019 jb019 kb019 lb019 mb019  hhid pn 
merge 1:1  hhid pn using "`long'\h12f2a.dta"
keep e5648 f992 g1079 hb019 jb019 kb019 lb019 mb019 nb019  hhid pn 
merge 1:1  hhid pn using "`long'\h14f2a.dta"
keep e5648 f992 g1079 hb019 jb019 kb019 lb019 mb019 nb019 ob019  hhid pn 
merge 1:1  hhid pn using "`long'\h16f2a.dta"
keep e5648 f992 g1079 hb019 jb019 kb019 lb019 mb019 nb019 ob019 pb019  hhid pn 


/*adding internet survey vars (not necessary because the internet survey does not add info about childhood srh to core interviews)
*2006
merge 1:1 hhid pn using "`long'\Net2006\NET06_R.dta"
keep e5648 f992 g1079 hb019 jb019 kb019 lb019 mb019 nb019 ob019 I2_CHDHLTH hhid pn 

*2007
merge 1:1 hhid pn using "`long'\Net2007\NET07_R.dta"
keep e5648 f992 g1079 hb019 jb019 kb019 lb019 mb019 nb019 ob019 I2_CHDHLTH I3_CHDHLTH hhid pn 

gen srhltI2 = I2_CHDHLTH 
drop I2_CHDHLTH
gen srhltI3 = I3_CHDHLTH 
drop I3_CHDHLTH
*/

*childhood self-rated health
gen CHsrhlt_m = .
replace CHsrhlt_m = e5648 if CHsrhlt_m == .
replace CHsrhlt_m = f992 if CHsrhlt_m == .
replace CHsrhlt_m = g1079 if CHsrhlt_m == .
replace CHsrhlt_m = jb019 if CHsrhlt_m== .
replace CHsrhlt_m = hb019 if CHsrhlt_m == .
replace CHsrhlt_m = kb019 if CHsrhlt_m == .
replace CHsrhlt_m = lb019 if CHsrhlt_m == .
replace CHsrhlt_m = mb019 if CHsrhlt_m == .
replace CHsrhlt_m = nb019 if CHsrhlt_m == .
replace CHsrhlt_m = ob019 if CHsrhlt_m == .
replace CHsrhlt_m = pb019 if CHsrhlt_m == .
/* 0 changes in the here
replace CHsrhlt_m = srhltI2 if CHsrhlt_m == .
replace CHsrhlt_m = srhltI3 if CHsrhlt_m == .
*/
recode CHsrhlt_m (8/9=.) (1=5) (2=4) (3=3) (4=2) (5=1)
label define CHsrhlt_m 5 "excellent" 4 "very good" 3 "good" 2 "fair" 1 "poor"
label values CHsrhlt_m CHsrhlt_m CHsrhlt_m
rename CHsrhlt_m chsrh
keep chsrh hhid pn
save "C:\Users\bluep\Desktop\HRS\CleanData\chsrh2016.dta", replace	
