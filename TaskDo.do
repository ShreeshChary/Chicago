*Working Directory
 cd "C:\Users\shree\OneDrive\Documents\UK 2023\Chicago"
 
**Log File
log using "C:\Users\shree\OneDrive\Documents\UK 2023\Chicago\TaskLog.smcl"

**Loading Data
import delimited "C:\Users\shree\Downloads\RA_21_22.csv"

**Setting Survey Weights
svyset [pw=weight]

***TASK 1***********************************************************************

**BY RACE

**Generating Variable for Total Wealth
gen wealth_total= asset_total- debt_total

**Collapsing data to represent year and race wise medians
collapse (median) wealth_total [pw=weight], by(year race)

**Panel Structure and plotting
encode race, gen(rac) //converting into numeric for panel setup

xtset rac year // panel setup

xtline wealth_total, overlay ///
       title("Panel A. Median Wealth by Race") ///
       ytitle("Median Wealth ($)") ///
       xtitle("Year") ///
       graphregion(color(white)) ///
       plotregion(margin(0 0 0 0)) ///
	   saving(Race_Wealth)
	   
clear

***BY EDUCATION

**Loading Data
import delimited "C:\Users\shree\Downloads\RA_21_22.csv"

**Setting Survey Weights
svyset [pw=weight]

**Generating Variable for Total Wealth
gen wealth_total= asset_total-debt_total

**Collapsing data to represent year and education wise medians
collapse (median) wealth_total [pw=weight], by(year education)

**Panel Structure and plotting

encode education, gen(edu) //converting into numeric for panel setup

xtset edu year // panel setup

xtline wealth_total, overlay ///
       title("Panel B. Median Wealth by Education") ///
       ytitle("Median Wealth ($)") ///
       xtitle("Year") ///
       graphregion(color(white)) ///
       plotregion(margin(0 0 0 0)) ///
	   saving(Education_Wealth)
	   
gr combine Race_Wealth.gph Education_Wealth.gph
	   
clear

********************************************************************************

**TASK 2************************************************************************

**Loading Data
import delimited "C:\Users\shree\Downloads\RA_21_22.csv"

**Setting Survey Weights and filtering the data
svyset [pw=weight]
encode race, gen(rac)
drop if rac!=2 & rac!=4

**Generating Variable for Total Wealth
gen wealth_housing= asset_housing-debt_housing

**Collapsing data to represent year and race wise medians
collapse (median) wealth_housing [pw=weight], by(year rac)

**Panel Structure and plotting

xtset rac year // panel setup

xtline wealth_housing, overlay ///
       title("Panel A. Median Housing Wealth by Race") ///
       ytitle("Median Housing Wealth ($)") ///
       xtitle("Year") ///
       graphregion(color(white)) ///
       plotregion(margin(0 0 0 0)) ///
	   saving(Race_HSG_Wealth)
	   
clear

**THE MEDIAN HOUSING WEALTH OF BLACK FAMILIES APPEARS TO BE ZERO

import delimited "C:\Users\shree\Downloads\RA_21_22.csv"

svyset [pw=weight]
encode race, gen(rac)
drop if rac!=2 & rac!=4
gen wealth_housing= asset_housing-debt_housing

graph box wealth_housing [pweight = weight], over(rac) nooutsides medtype(marker) title("Panel B. Boxplot of Household Wealth") graphregion(color(white)) plotregion(margin(0 0 0 0)) saving(box)

gr combine Race_HSG_Wealth.gph box.gph

clear

**Clearly, the median black household does not have any household assets

**************************************************************************************

**TASK 3*************************************************************************

**USING AGE 25 AND ABOVE

**Loading Data
import delimited "C:\Users\shree\Downloads\RA_21_22.csv"

**Setting Survey Weights and filtering the data
svyset [pw=weight]

**Generating Variable for Total Wealth
gen wealth_housing= asset_housing-debt_housing
gen wealth_total= asset_total-debt_total
keep if age>=25
encode race, gen(rac)
drop if rac!=2 & rac!=4

**Collapsing data to represent year and race wise medians
collapse (median) wealth_housing wealth_total [pw=weight], by(year rac)
xtset rac year

xtline wealth_housing, overlay ///
       title("Panel A. Median Housing Wealth by Race (Ages 25 and Above)") ///
       ytitle("Median Housing Wealth ($)") ///
       xtitle("Year") ///
       graphregion(color(white)) ///
       plotregion(margin(0 0 0 0)) ///
	   saving(Race_HSG_Wealth_25)
	   
	   xtline wealth_total, overlay ///
       title("Panel B. Median Total Wealth by Race (Ages 25 and Above)") ///
       ytitle("Median Total Wealth ($)") ///
       xtitle("Year") ///
       graphregion(color(white)) ///
       plotregion(margin(0 0 0 0)) ///
	   saving(Race_Wealth_25)
	   
drop if year!=2007 & year!=2016
sort rac year

** Calculating the dollar change in housing wealth
gen change_housing = wealth_housing - wealth_housing[_n-1] if year == 2016

** Calculating the dollar change in total wealth
gen change_total = wealth_total - wealth_total[_n-1] if year == 2016

** Calculating percentage change in housing wealth
gen pct_change_housing = ((wealth_housing - wealth_housing[_n-1]) / wealth_housing[_n-1]) * 100 if year == 2016

** Calculating percentage change in total wealth
gen pct_change_total = ((wealth_total - wealth_total[_n-1]) / wealth_total[_n-1]) * 100 if year == 2016

list rac change_housing pct_change_housing change_total pct_change_total if year == 2016, noobs 

clear



///USING AGES 35 AND ABOVE************************************************


**Loading Data
import delimited "C:\Users\shree\Downloads\RA_21_22.csv"

**Setting Survey Weights and filtering the data
svyset [pw=weight]

**Generating Variable for Total Wealth
gen wealth_housing= asset_housing-debt_housing
gen wealth_total= asset_total-debt_total
keep if age>=35
encode race, gen(rac)
drop if rac!=2 & rac!=4

**Collapsing data to represent year and race wise medians
collapse (median) wealth_housing wealth_total [pw=weight], by(year rac)
xtset rac year

xtline wealth_housing, overlay ///
       title("Panel C. Median Housing Wealth by Race (Ages 35 and Above)") ///
       ytitle("Median Housing Wealth ($)") ///
       xtitle("Year") ///
       graphregion(color(white)) ///
       plotregion(margin(0 0 0 0)) ///
	   saving(Race_HSG_Wealth_35)
	   
	   xtline wealth_total, overlay ///
       title("Panel D. Median Total Wealth by Race (Ages 35 and Above)") ///
       ytitle("Median Total Wealth ($)") ///
       xtitle("Year") ///
       graphregion(color(white)) ///
       plotregion(margin(0 0 0 0)) ///
	   saving(Race_Wealth_35)
	   
gr combine Race_HSG_Wealth_25.gph Race_Wealth_25.gph Race_HSG_Wealth_35.gph Race_Wealth_35.gph

drop if year!=2007 & year!=2016
sort rac year
	   
** Calculating the dollar change in housing wealth
gen change_housing = wealth_housing - wealth_housing[_n-1] if year == 2016

** Calculating the dollar change in total wealth
gen change_total = wealth_total - wealth_total[_n-1] if year == 2016

** Calculating percentage change in housing wealth
gen pct_change_housing = ((wealth_housing - wealth_housing[_n-1]) / wealth_housing[_n-1]) * 100 if year == 2016

** Calculating percentage change in total wealth
gen pct_change_total = ((wealth_total - wealth_total[_n-1]) / wealth_total[_n-1]) * 100 if year == 2016

list rac change_housing pct_change_housing change_total pct_change_total if year == 2016, noobs 


clear

******************************************************************************************

log close

translate "C:\Users\shree\OneDrive\Documents\UK 2023\Chicago\TaskLog.smcl" "C:\Users\shree\OneDrive\Documents\UK 2023\Chicago\TaskLog.pdf"

