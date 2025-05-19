
global directory "/Users/lukewisniewski/Desktop/Econ 80 Research Paper"
cd "$directory/Code_Outputs"

*******************************************************************************
**************************** SYNTHETIC CONTROLS *******************************
*******************************************************************************
global pop "msa_pop incomepc totincome"

ssc install synth, replace
clear
use temp_teamdata
* Seattle Supersonics --> Oklahoma City *
keep if team_id==221 | (mover==0&league==3&expansion==0&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct{
	synth `i' two_team `i' `i'(2004) `i'(2005) `i'(2006) `i'(2007), trunit(221) trperiod(2008) resultsperiod(1990/2019 2021 2022) fig
	graph export sea_thunder_`i'.jpg, replace
		synth `i' two_team `i' `i'(2004) `i'(2005) `i'(2006) `i'(2007), trunit(221) trperiod(2008) resultsperiod(1990/2019 2021 2022) keep(sea_thunder_`i') replace
}
synth ln_ticket_price two_team ln_ticket_price ln_ticket_price(2004) ln_ticket_price(2005) ln_ticket_price(2006) ln_ticket_price(2007), trunit(221) trperiod(2008) mspeperiod(1991/2007) resultsperiod(1991/2015 2017 2018 2020 2021) fig
	graph export sea_thunder_ln_ticket_price.jpg, replace
synth ln_ticket_price two_team ln_ticket_price ln_ticket_price(2004) ln_ticket_price(2005) ln_ticket_price(2006) ln_ticket_price(2007), trunit(221) trperiod(2008) mspeperiod(1991/2007) resultsperiod(1991/2015 2017 2018 2020 2021) keep(sea_thunder_ln_ticket_price) replace


clear
* Montreal Expos --> Washington D.C. *
use temp_teamdata
keep if team_id==130 | (mover==0&league==4&expansion==0&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct{
	synth `i' canada two_team `i' `i'(2001) `i'(2002) `i'(2003) `i'(2004), trunit(130) trperiod (2005) mspeperiod(1991/2004)resultsperiod(1991/2019 2021 2022) fig
	graph export mon_nats_`i'.jpg, replace
synth `i' canada two_team `i' `i'(2001) `i'(2002) `i'(2003) `i'(2004), trunit(130) trperiod (2005) mspeperiod(1991/2004) resultsperiod(1991/2019 2021 2022) keep(mon_nats_`i') replace
}
drop if team_id==126
synth ln_ticket_price canada two_team ln_ticket_price ln_ticket_price(2001) ln_ticket_price(2002) ln_ticket_price(2003) ln_ticket_price(2004), trunit(130) trperiod(2005) mspeperiod(1991/2004) resultsperiod(1991/2016 2018/2022) fig
graph export mon_nats_ln_ticket_price.jpg, replace
synth ln_ticket_price canada two_team ln_ticket_price ln_ticket_price(2001) ln_ticket_price(2002) ln_ticket_price(2003) ln_ticket_price(2004), trunit(130) trperiod(2005) mspeperiod(1991/2004) resultsperiod(1991/2016 2018/2022) keep(mon_nats_ln_ticket_price) replace

clear
* San Diego Chargers --> LA *
use temp_teamdata
keep if team_id==418 | (mover==0&league==1&expansion==0&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct ln_ticket_price{
	synth `i' `i' `i'(2013) `i'(2014) `i'(2015) `i'(2016), trunit(418) trperiod(2017) mspeperiod(1990 1995 2000 2005 2010 2015) resultsperiod(1990 1991 1993/2019 2021 2022) fig
	graph export sd_chargers_`i'.jpg, replace
		synth `i' `i' `i'(2013) `i'(2014) `i'(2015) `i'(2016), trunit(418) trperiod(2017) mspeperiod(1990 1995 2000 2005 2010 2015) resultsperiod(1990 1991 1993/2019 2021 2022) keep(sd_chargers_`i') replace
}

clear
* Quebec Nordiques --> Colorado *
use temp_teamdata
keep if team_id==308 | (mover==0&league==2&expansion==0&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct{
	synth `i' canada two_team `i' `i'(1991) `i'(1992) `i'(1993) `i'(1994), trunit(308) trperiod(1995) resultsperiod(1990/1995 1997 1999/2003 2005/2019 2021 2022) fig
	graph export queb_avalanche_`i'.jpg, replace
		synth `i' canada two_team `i' `i'(1991) `i'(1992) `i'(1993) `i'(1994), trunit(308) trperiod(1995) resultsperiod(1990/1995 1997 1999/2003 2005/2019 2021 2022) keep(queb_avalanche_`i') replace
}


clear
* Hartford Whalers --> Carolina *
use temp_teamdata
keep if team_id==306 | (mover==0&league==2&expansion==0&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct{
	synth `i' canada two_team `i' `i'(1993) `i'(1994) `i'(1995), trunit(306) trperiod(1997) mspeperiod(1990/1995) resultsperiod(1990/1995 1997 1999/2003 2005/2019 2021 2022) fig
	graph export hart_hurricanes_`i'.jpg, replace
		synth `i' canada two_team `i' `i'(1993) `i'(1994) `i'(1995), trunit(306) trperiod(1997) mspeperiod(1990/1995) resultsperiod(1990/1995 1997 1999/2003 2005/2019 2021 2022) keep(hart_hurricanes_`i') replace
}
synth ln_ticket_price canada two_team ln_ticket_price ln_ticket_price(1994) ln_ticket_price(1995) ln_ticket_price(1996), trunit(306) trperiod(1997) mspeperiod(1994/1996) resultsperiod(1994/2003 2005/2015 2019/2021) fig
synth ln_ticket_price canada two_team ln_ticket_price ln_ticket_price(1994) ln_ticket_price(1995) ln_ticket_price(1996), trunit(306) trperiod(1997) mspeperiod(1994/1996) resultsperiod(1994/2003 2005/2015 2019/2021) keep(hart_hurricanes_ln_ticket_price) replace

clear
* Minnesota North Stars --> Dallas *
use temp_teamdata
keep if team_id==310 | (mover==0&league==2&expansion==0&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct{
	synth `i' canada two_team `i' `i'(1990) `i'(1991) `i'(1992), trunit(310) trperiod(1993) resultsperiod(1990/1995 1997 1999/2003 2005/2019 2021 2022) fig
	graph export min_stars_`i'.jpg, replace
		synth `i' canada two_team `i' `i'(1990) `i'(1991) `i'(1992), trunit(310) trperiod(1993) resultsperiod(1990/1995 1997 1999/2003 2005/2019 2021 2022) keep(min_stars_`i') replace
}


clear
* Los Angeles Raiders --> Oakland *
use temp_teamdata
keep if team_id==417 | (mover==0&league==1&expansion==0&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct ln_ticket_price{
	synth `i' two_team `i' `i'(1991) `i'(1993) `i'(1994), trunit(417) trperiod(1995) resultsperiod(1990 1991 1993/2015) mspeperiod(1990 1991 1993 1994) fig
	graph export la_raiders_`i'.jpg, replace
		synth `i' two_team `i' `i'(1991) `i'(1993) `i'(1994), trunit(417) trperiod(1995) resultsperiod(1990 1991 1993/2015) mspeperiod(1990 1991 1993 1994) keep(la_raiders_`i') replace
}

clear
* Cleveland Browns --> Baltimore *
use temp_teamdata
keep if team_id==403 | (mover==0&league==1&expansion==0&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct ln_ticket_price{
	synth `i' two_team `i' `i'(1993) `i'(1994) `i'(1995), trunit(403) trperiod(1996) resultsperiod(1990 1991 1993/2019 2021 2022) mspeperiod(1990 1991 1993/1995) fig
	graph export clev_ravens_`i'.jpg, replace
	synth `i' two_team `i' `i'(1993) `i'(1994) `i'(1995), trunit(403) trperiod(1996) resultsperiod(1990 1991 1993/2019 2021 2022) mspeperiod(1990 1991 1993/1995) keep(clev_ravens_`i') replace
}

clear
* Winnipeg Jets --> Phoenix *
use temp_teamdata
keep if team_id == 302 | (mover==0&league==2&expansion==0&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct{
	synth `i' canada two_team `i' `i'(1992) `i'(1993) `i'(1994) `i'(1995), trunit(302) trperiod(1996) resultsperiod(1990/1995 1997 1999 2001 2003 2005/2019 2021 2022) fig
	graph export win_coyotes_`i'.jpg, replace
	synth `i' canada two_team `i' `i'(1992) `i'(1993) `i'(1994) `i'(1995), trunit(302) trperiod(1996) resultsperiod(1990/1995 1997 1999 2001 2003 2005/2019 2021 2022) keep(win_coyotes_`i') replace
}
synth ln_ticket_price canada ln_ticket_price ln_ticket_price(1994) ln_ticket_price(1995), trunit(302) trperiod(1996) mspeperiod(1994/1995) resultsperiod(1994/2003 2005/2015 2019/2021) fig
synth ln_ticket_price canada two_team ln_ticket_price ln_ticket_price(1994) ln_ticket_price(1995), trunit(302) trperiod(1996) mspeperiod(1994/1995) resultsperiod(1994/2003 2005/2015 2019/2021) keep(win_coyotes_ln_ticket_price) replace


clear
* Vancouver Grizzlies --> Memphis *
use temp_teamdata
keep if team_id==215 | (mover==0&league==3&team_id!=204&year>=1995&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct{
	synth `i' canada two_team `i' `i'(1997) `i'(1998) `i'(1999) `i'(2000), trunit(215) trperiod(2001) resultsperiod(1995/2019 2021 2022) fig
	graph export van_grizzlies_`i'.jpg, replace
	synth `i' canada two_team `i' `i'(1997) `i'(1998) `i'(1999) `i'(2000), trunit(215) trperiod(2001) resultsperiod(1995/2019 2021 2022) keep(van_grizzlies_`i') replace	
}
synth ln_ticket_price two_team ln_ticket_price ln_ticket_price(1997) ln_ticket_price(1998) ln_ticket_price(1999) ln_ticket_price(2000), trunit(215) trperiod(2001) mspeperiod(1995/2000) resultsperiod(1995/2015 2017 2018 2020 2021) fig
	graph export van_grizzlies_ln_ticket_price.jpg, replace
synth ln_ticket_price two_team ln_ticket_price ln_ticket_price(1997) ln_ticket_price(1998) ln_ticket_price(1999) ln_ticket_price(2000), trunit(215) trperiod(2001) mspeperiod(1995/2000) resultsperiod(1995/2015 2017 2018 2020 2021) keep(van_grizzlies_ln_ticket_price) replace

clear
* Charlotte Hornets --> New Orleans *
use temp_teamdata
keep if team_id==219 | (mover==0&league==3&expansion==0&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct{
	synth `i' two_team `i' `i'(1998) `i'(1999) `i'(2000) `i'(2001), trunit(219) trperiod(2002) resultsperiod(1990/2019 2021 2022) fig
	graph export cha_hornets_`i'.jpg, replace
	synth `i' two_team `i' `i'(1998) `i'(1999) `i'(2000) `i'(2001), trunit(219) trperiod(2002) resultsperiod(1990/2019 2021 2022) keep(cha_hornets_`i') replace		
}
synth ln_ticket_price two_team ln_ticket_price ln_ticket_price(1998) ln_ticket_price(1999) ln_ticket_price(2000) ln_ticket_price(2001), trunit(219) trperiod(2002) mspeperiod(1991/2001) resultsperiod(1991/2015 2017 2018 2020 2021) fig
	graph export cha_hornets_ln_ticket_price.jpg, replace
synth ln_ticket_price two_team ln_ticket_price ln_ticket_price(1998) ln_ticket_price(1999) ln_ticket_price(2000) ln_ticket_price(2001), trunit(219) trperiod(2002) mspeperiod(1991/2001) resultsperiod(1991/2015 2017 2018 2020 2021) keep(cha_hornets_ln_ticket_price) replace


clear
* Atlanta Thrashers --> Winnipeg *
use temp_teamdata
keep if team_id==332 | (mover==0&league==2&expansion==0&year>=1999&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct{
	synth `i' canada two_team `i' `i'(2007) `i'(2008) `i'(2009) `i'(2010), trunit(332) trperiod(2011) resultsperiod(1999/2003 2005/2019 2021 2022) fig
	graph export atl_jets_`i'.jpg, replace
	synth `i' canada two_team `i' `i'(2007) `i'(2008) `i'(2009) `i'(2010), trunit(332) trperiod(2011) resultsperiod(1999/2003 2005/2019 2021 2022) keep(atl_jets_`i') replace	
}
synth ln_ticket_price canada two_team ln_ticket_price ln_ticket_price(2007) ln_ticket_price(2008) ln_ticket_price(2009) ln_ticket_price(2010), trunit(332) trperiod(2011) mspeperiod(1999/2003 2005/2010) resultsperiod(1999/2003 2005/2015 2019/2021) fig
synth ln_ticket_price canada two_team ln_ticket_price ln_ticket_price(2007) ln_ticket_price(2008) ln_ticket_price(2009) ln_ticket_price(2010), trunit(332) trperiod(2011) mspeperiod(1999/2003 2005/2010) resultsperiod(1999/2003 2005/2015 2019/2021) keep(atl_jets_ln_ticket_price) replace


/*
clear
* San Francisco 49ers --> Santa Clara *
use temp_teamdata
keep if team_id==428 | (mover==0&league==1&expansion==0&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct ln_ticket_price{
	synth `i' two_team std_pct prev_pct `i' `i'(2010) `i'(2011) `i'(2012) `i'(2013), trunit(428) trperiod(2014) resultsperiod(1990 1991 1993/2019 2021 2022) mspeperiod(1990 1991 1993/2013)  fig
	graph export sf_49ers_`i'.jpg, replace
	synth `i' two_team std_pct prev_pct `i' `i'(2010) `i'(2011) `i'(2012) `i'(2013), trunit(428) trperiod(2014) resultsperiod(1990 1991 1993/2019 2021 2022) mspeperiod(1990 1991 1993/2013) keep(sf_49ers_`i') replace	
}
*/

* New Jersey Nets --> Brooklyn *
clear
use temp_teamdata
keep if team_id==203 | (mover==0&league==3&expansion==0&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct{
	synth `i' two_team `i' `i'(2008) `i'(2009) `i'(2010) `i'(2011), trunit(203) trperiod(2012) resultsperiod(1990/2019 2021 2022) fig
	graph export nj_nets_`i'.jpg, replace
		synth `i' two_team `i' `i'(2008) `i'(2009) `i'(2010) `i'(2011), trunit(203) trperiod(2012) resultsperiod(1990/2019 2021 2022) keep(nj_nets_`i') replace
}
synth ln_ticket_price two_team ln_ticket_price ln_ticket_price(2008) ln_ticket_price(2009) ln_ticket_price(2010) ln_ticket_price(2011), trunit(203) trperiod(2012) mspeperiod(1991/2011) resultsperiod(1991/2015 2017 2018 2020 2021) fig
	graph export nj_nets_ln_ticket_price.jpg, replace
synth ln_ticket_price two_team ln_ticket_price ln_ticket_price(2008) ln_ticket_price(2009) ln_ticket_price(2010) ln_ticket_price(2011), trunit(203) trperiod(2012) mspeperiod(1991/2011) resultsperiod(1991/2015 2017 2018 2020 2021) keep(nj_nets_ln_ticket_price) replace

clear
* Los Angeles Rams --> St. Louis *
use temp_teamdata
keep if team_id==419 | (mover==0&league==1&expansion==0&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct ln_ticket_price{
	synth `i' two_team `i' `i'(1991) `i'(1993) `i'(1994), trunit(419) trperiod(1995) resultsperiod(1990 1991 1993/2011) mspeperiod(1990 1991 1993 1994) fig
	graph export la_rams_`i'.jpg, replace
	synth `i' two_team `i' `i'(1991) `i'(1993) `i'(1994), trunit(419) trperiod(1995) resultsperiod(1990 1991 1993/2011) mspeperiod(1990 1991 1993 1994) keep(la_rams_`i') replace		
}


clear
* Houston Oilers --> Nashville *
use temp_teamdata
keep if team_id==431 | (mover==0&league==1&expansion==0&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct ln_ticket_price{
	synth `i' two_team `i' `i'(1993) `i'(1994) `i'(1995) `i'(1996), trunit(431) trperiod(1997) resultsperiod(1990 1991 1993/2019 2021 2022) mspeperiod(1990 1991 1993/1996)  fig
	graph export hou_titans_`i'.jpg, replace
	synth `i' two_team `i' `i'(1993) `i'(1994) `i'(1995) `i'(1996), trunit(431) trperiod(1997) resultsperiod(1990 1991 1993/2019 2021 2022) mspeperiod(1990 1991 1993/1996) keep(hou_titans_`i') replace		
}


clear
* St. Louis Rams --> LA *
use temp_teamdata
keep if (team_id==419&year>=2005) | (mover==0&league==1&expansion==0&year>=2005&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct ln_ticket_price{
	synth `i' two_team `i' `i'(2012) `i'(2013) `i'(2014) `i'(2015), trunit(419) trperiod(2016) mspeperiod(2005/2015) resultsperiod(2005/2019 2021 2022) fig
	graph export stl_rams_`i'.jpg, replace
	synth `i' two_team `i' `i'(2012) `i'(2013) `i'(2014) `i'(2015), trunit(419) trperiod(2016) mspeperiod(2005/2015) resultsperiod(2005/2019 2021 2022) keep(stl_rams_`i') replace		
}


clear
* Oakland Raiders --> Las Vegas *
use temp_teamdata
keep if (team_id==417&year>=2005) | (mover==0&league==1&expansion==0&year>=2005&new_stad==1)
tsset team_id year
foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct ln_ticket_price{
	synth `i' two_team `i' `i'(2016) `i'(2017) `i'(2018) `i'(2019), trunit(417) trperiod(2020) mspeperiod(2005/2019) resultsperiod(2005/2019 2021 2022) fig
	graph export oak_raiders_`i'.jpg, replace
	synth `i' two_team `i' `i'(2016)  `i'(2017) `i'(2018) `i'(2019), trunit(417) trperiod(2020) mspeperiod(2005/2019) resultsperiod(2005/2019 2021 2022) keep(oak_raiders_`i') replace
}

foreach i in min_stars queb_avalanche{
	clear
	gen _Co_Number=.
	gen _W_Weight=.
	gen _Y_treated=.
	gen _Y_synthetic=.
	gen _time=.
	save `i'_ln_ticket_price.dta, replace
}


foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct ln_ticket_price{
	use sea_thunder_`i'.dta, replace
	gen team_id=221
	gen relocation=2008
	save sea_thunder_`i'.dta, replace
	
	use mon_nats_`i'.dta, replace
	gen team_id=130
	gen relocation = 2005
	save mon_nats_`i'.dta, replace
	
	use sd_chargers_`i'.dta, replace
	gen team_id=418
	gen relocation = 2017
	save sd_chargers_`i'.dta, replace

	use queb_avalanche_`i'.dta, replace
gen team_id=308
gen relocation=1995
save queb_avalanche_`i'.dta, replace

use hart_hurricanes_`i'.dta, replace
gen team_id=306
gen relocation=1997
save hart_hurricanes_`i'.dta, replace

use min_stars_`i'.dta, replace
gen team_id=310
gen relocation=1993
save min_stars_`i'.dta, replace

use la_raiders_`i'.dta, replace
gen team_id=417
gen relocation=1995
save la_raiders_`i'.dta, replace

use clev_ravens_`i'.dta, replace
gen team_id=403
gen relocation=1996
save clev_ravens_`i'.dta, replace

use win_coyotes_`i'.dta, replace
gen team_id=302
gen relocation=1996
save win_coyotes_`i'.dta, replace

use van_grizzlies_`i'.dta, replace
gen team_id=215
gen relocation=2001
save van_grizzlies_`i'.dta, replace

use cha_hornets_`i'.dta, replace
gen team_id=219
gen relocation=2002
save cha_hornets_`i'.dta, replace

use atl_jets_`i'.dta, replace
gen team_id=332
gen relocation=2011
save atl_jets_`i'.dta, replace

/*
use sf_49ers_`i'.dta, replace
gen team_id=428
gen relocation=2014
save sf_49ers_`i'.dta, replace
*/

use nj_nets_`i'.dta, replace
gen team_id=203
gen relocation=2012
save nj_nets_`i'.dta, replace


use la_rams_`i'.dta, replace
gen team_id=419
gen relocation=1995
save la_rams_`i'.dta, replace

use hou_titans_`i'.dta, replace
gen team_id=431
gen relocation=1997
save hou_titans_`i'.dta, replace

use stl_rams_`i'.dta, replace
gen team_id=419
gen relocation=2016
save stl_rams_`i'.dta, replace

use oak_raiders_`i'.dta, replace
gen team_id=417
gen relocation=2020
save oak_raiders_`i'.dta, replace

}

foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct ln_ticket_price{
	use sea_thunder_`i'.dta, replace
	foreach j in mon_nats_`i' sd_chargers_`i' queb_avalanche_`i' hart_hurricanes_`i' min_stars_`i' la_raiders_`i' clev_ravens_`i' win_coyotes_`i' van_grizzlies_`i' cha_hornets_`i' atl_jets_`i' nj_nets_`i' la_rams_`i' hou_titans_`i' stl_rams_`i' oak_raiders_`i'{
		append using `j'
	}
	save synth_data_`i'.dta, replace
}

foreach i in ln_revenue ln_avg_attendance ln_revexpratio ln_salary std_pct ln_ticket_price{
	use sea_thunder_`i'.dta, replace
	foreach j in mon_nats_`i' sd_chargers_`i' van_grizzlies_`i' cha_hornets_`i' atl_jets_`i' nj_nets_`i' stl_rams_`i' oak_raiders_`i'{
		append using `j'
	}
	save synth_restricted_data_`i'.dta, replace
}

/*
use sea_thunder.dta, replace
gen team_id = 221
gen relocation = 2008
save sea_thunder.dta, replace

use mon_nats.dta, replace
gen team_id=130
gen relocation = 2005
save mon_nats.dta, replace

use sd_chargers.dta, replace
gen team_id=418
gen relocation = 2017
save sd_chargers.dta, replace

use queb_avalanche.dta, replace
gen team_id=308
gen relocation=1995
save queb_avalanche.dta, replace

use hart_hurricanes.dta, replace
gen team_id=306
gen relocation=1997
save hart_hurricanes.dta, replace

use min_stars.dta, replace
gen team_id=310
gen relocation=1993
save min_stars.dta, replace

use la_raiders.dta, replace
gen team_id=417
gen relocation=1995
save la_raiders.dta, replace

use clev_ravens.dta, replace
gen team_id=403
gen relocation=1996
save clev_ravens.dta, replace

use win_coyotes.dta, replace
gen team_id=302
gen relocation=1996
save win_coyotes.dta, replace

use van_grizzlies.dta, replace
gen team_id=215
gen relocation=2001
save van_grizzlies.dta, replace

use cha_hornets.dta, replace
gen team_id=219
gen relocation=2002
save cha_hornets.dta, replace

use atl_jets.dta, replace
gen team_id=332
gen relocation=2011
save atl_jets.dta, replace

use sf_49ers.dta, replace
gen team_id=428
gen relocation=2014
save sf_49ers.dta, replace

use la_rams.dta, replace
gen team_id=419
gen relocation=1995
save la_rams.dta, replace

use hou_titans.dta, replace
gen team_id=431
gen relocation=1997
save hou_titans.dta, replace

use stl_rams.dta, replace
gen team_id=419
gen relocation=2016
save stl_rams.dta, replace

use oak_raiders.dta, replace
gen team_id=417
gen relocation=2020
save oak_raiders.dta, replace

clear
use sea_thunder.dta, replace
foreach i in mon_nats sd_chargers queb_avalanche hart_hurricanes min_stars la_raiders clev_ravens win_coyotes van_grizzlies cha_hornets atl_jets sf_49ers la_rams hou_titans stl_rams oak_raiders{
	append using `i'
}
save synth_data.dta, replace

*/



