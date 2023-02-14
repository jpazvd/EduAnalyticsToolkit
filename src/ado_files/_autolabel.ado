*! version 0.1          < 9sept2022>         JPAzevedo

cap program drop _autolabel

    program define _autolabel, rclass sortpreserve

   		version 8.0
	
	    syntax varlist(numeric min=1) ///
            [if] [in] , inputs(string) [prefix(string) same format(string)]        

	qui { 

		if ("`prefix'" == "") {
			local prefix "_auto"
		}	
		if ("`format'" == "") {
			local format "%16.1fc"
		}
		
		local count1 = wordcount("`varlist'")
		local count2 = wordcount("`inputs'")
		
		* check that the numbers of inputs match
		
		if (`count1' != `count2') {
			if ("`same'" == "") {
				di as err "Option same needs to be selected if number of variables and number of inputs do not match." 
                exit 198
			}
			else if (`count1' < `count2') {
				di as err "Number of variables must be larger than number of inputs." 
                exit 198
			}
			else {
				local check1 = 1
			}
		}
		
		
		tempvar touse
		
		mark `touse' `in' `if'
			
		local v = 1
		foreach var in `varlist' {
			
			forvalues depvarseq = 1(1)`count2' {
				if (`v'==`depvarseq') {
					local depvar = word("`inputs'",`depvarseq')
					local lastdepvar `depvar'
				}
				if ("`depvar'" == "") & (`check1'==1) {
					local depvar `lastdepvar'
				}
			}
			
			levelsof `var'
			
			foreach catvar in `r(levels)' {
			
				sum `depvar' if `var' == `catvar' & `touse'
				local min = r(min)
				local fmtmin : display `format' `min'
				local fmtmin = trim(string(`fmtmin'))
				local max = r(max)
				local fmtmax : display `format' `max'
				local fmtmax = trim(string(`fmtmax'))
			
				local labdef "`fmtmin'-`fmtmax'"
			
				label define `prefix'`var' `catvar' "`labdef'", add modify
			}
			
			label values `var' `prefix'`var'
			
			local v = `v'+1		
			local depvar ""
		}
        
	}
	
	end
	
	