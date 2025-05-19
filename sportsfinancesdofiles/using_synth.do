clear
set more off
capture log close

*Figures A3 and A4

cd "/Users/lukewisniewski/Desktop/Econ 80 Research Paper/Code_Outputs"
set scheme plotplain

foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct ln_ticket_price{
	use synth_data_`i'.dta, replace
	capture gen year_from_relocation = _time - relocation
	replace year_from_relocation = -5 if (_time - relocation <=-5)
	replace year_from_relocation = 10 if (_time - relocation >=10)
	
	capture gen real_dif = _Y_treated - _Y_synthetic
	drop if _time==.
	save temp_synth_data_`i'.dta, replace
	capture egen mean_dif = mean(real_dif) if(real_dif!=.), by(year_from_relocation)
	label var year_from_relocation "Time"
	label var mean_dif "Average Difference"
	capture gen ci_lower = .
	capture gen ci_upper = .

	
	levelsof year_from_relocation, local(years)
	foreach j of local years{
		ci mean real_dif if year_from_relocation==`j', level(90)
		replace ci_lower = r(lb) if year_from_relocation==`j'
		replace ci_upper = r(ub) if year_from_relocation==`j'
	}
	twoway (scatter mean_dif year_from_relocation) (rcap ci_lower ci_upper year_from_relocation, legend(label(2 "90% CI"))), xline(-1) yline(0)
	graph export synth_avg_`i'.jpg, replace
}


* Now doing the restricted sample
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct ln_ticket_price{
	use synth_restricted_data_`i'.dta, replace
	capture gen year_from_relocation = _time - relocation
	replace year_from_relocation = -5 if (_time - relocation <=-5)
	replace year_from_relocation = 10 if (_time - relocation >=10)
	
	capture gen real_dif = _Y_treated - _Y_synthetic
	drop if _time==.
	save temp_synth_restricted_data_`i'.dta, replace
	capture egen mean_dif = mean(real_dif) if(real_dif!=.), by(year_from_relocation)
	label var year_from_relocation "Time"
	label var mean_dif "Average Difference"
	capture gen ci_lower = .
	capture gen ci_upper = .

	
	levelsof year_from_relocation, local(years)
	foreach j of local years{
		ci mean real_dif if year_from_relocation==`j', level(90)
		replace ci_lower = r(lb) if year_from_relocation==`j'
		replace ci_upper = r(ub) if year_from_relocation==`j'
	}
	twoway (scatter mean_dif year_from_relocation) (rcap ci_lower ci_upper year_from_relocation, legend(label(2 "90% CI"))), xline(-1) yline(0)
	graph export synth_avg_restricted_`i'.jpg, replace
}



