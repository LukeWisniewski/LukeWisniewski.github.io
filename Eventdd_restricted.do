clear
set more off
capture log close

global directory "/Users/lukewisniewski/Desktop/Econ 80 Research Paper"
*******************************************************************************
************************ ELIMINATING NON-STADIA INVESTORS *********************
**************************** restricted sample model **************************
*******************************************************************************
cd "$directory"
use "$directory/Dta_Files/complete_data.dta", replace
cd "$directory/Code_Outputs"
set scheme plotplain
global team_controls "msa_pop incomepc totincome i.canada i.two_team"

global keeplist_dd "lead* lag*"

log using eventdd_restricted, text replace

keep if mover==1 | new_stad==1
replace new_stad=0 if mover==1
replace move_stad=. if new_stad==0
drop if year>=2023
ssc install eventdd, replace
ssc install matsort, replace
save temp_teamdata, replace

xtset team_id year
****************************** Revenue Growth *********************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_revenue i.year, timevar(move_year) method(fe) graph_op(ytitle("Average Revenue Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin_std.tex, replace word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revenue i.year $team_controls, timevar(move_year) method(fe) graph_op(ytitle("Average Revenue Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export rel_rev_std.jpg, replace
outreg2 using fin_std.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_revenue i.year, timevar(move_stad) method(fe) graph_op(ytitle("Average Revenue Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin_std.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revenue i.year $team_controls, timevar(move_stad) method(fe) graph_op(ytitle("Average Revenue Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export stad_rev_std.jpg, replace
outreg2 using fin_std.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

***************************** Attendance Growth *******************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_avg_attendance i.year, timevar(move_year) method(fe) graph_op(ytitle("Average Attendance Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fan_std.tex, replace word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_avg_attendance i.year $team_controls, timevar(move_year) method(fe) graph_op(ytitle("Average Attendance Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export rel_attendance_std.jpg, replace
outreg2 using fan_std.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_avg_attendance i.year, timevar(move_stad) method(fe) graph_op(ytitle("Average Attendance Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fan_std.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_avg_attendance i.year $team_controls, timevar(move_stad) method(fe) graph_op(ytitle("Average Attendance Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export stad_attendance_std.jpg, replace
outreg2 using fan_std.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

*********************** Revenue over Expenditure Growth ***********************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_revexpratio i.year, timevar(move_year) method(fe) graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin_std.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revexpratio i.year $team_controls, timevar(move_year) method(fe) graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export rel_revex_std.jpg, replace
outreg2 using fin_std.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_revexpratio i.year, timevar(move_stad) method(fe) graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin_std.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_revexpratio i.year $team_controls, timevar(move_stad) method(fe) graph_op(ytitle("Average Revenue to Expenditure Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export stad_revex_std.jpg, replace
outreg2 using fin_std.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

****************************** Salary Growth **********************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd ln_salary i.year, timevar(move_year) method(fe) graph_op(ytitle("Average Salary Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin_std.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_salary i.year $team_controls, timevar(move_year) method(fe) graph_op(ytitle("Average Salary Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export rel_salary_std.jpg, replace
outreg2 using fin_std.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

* New Stadia Franchises *
save temp_teamdata, replace
eventdd ln_salary i.year, timevar(move_stad) method(fe) graph_op(ytitle("Average Salary Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fin_std.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd ln_salary i.year $team_controls, timevar(move_stad) method(fe) graph_op(ytitle("Average Salary Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export stad_salary_std.jpg, replace
outreg2 using fin_std.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}


*************************** Win Percentage Growth ****************************
* Relocating Franchises *
save temp_teamdata, replace
eventdd std_pct i.year, timevar(move_year) method(fe) graph_op(ytitle("Average Win Percentage Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fan_std.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd std_pct i.year $team_controls, timevar(move_year) method(fe) graph_op(ytitle("Average Win Percentage Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export rel_pct_std.jpg, replace
outreg2 using fan_std.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}


* New Stadia Franchises *
save temp_teamdata, replace
eventdd std_pct i.year, timevar(move_stad) method(fe) graph_op(ytitle("Average Win Percentage Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
outreg2 using fan_std.tex, append word label keep($keeplist_dd)
foreach i in $keeplist_dd{
	drop `i'
}
save temp_teamdata, replace
eventdd std_pct i.year $team_controls, timevar(move_stad) method(fe) graph_op(ytitle("Average Win Percentage Growth") xlabel(-5(1)10)) leads(5) lags(10) accum keepdummies
graph export stad_pct_std.jpg, replace
outreg2 using fan_std.tex, append word label keep($keeplist_dd) addtext(City Controls, YES)
foreach i in $keeplist_dd{
	drop `i'
}

log close
