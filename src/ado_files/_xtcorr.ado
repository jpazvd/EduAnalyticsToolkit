*! version 0.1          < 11Oct2022>         JPAzevedo

cap program drop _xtcorr

    program define _xtcorr, rclass sortpreserve
		
   		version 17.0
	
	    syntax varlist(numeric min=1) ///
            [if] [in] , by(string) [correlate pwcorr ]   

		preserve
		
			tempvar seq
			
			gen `seq' = _n
			
			keep `varlist' `seq' `string'
			
			reshape wide `varlist' , i(`seq') j(`string')
			
			correlate `varlist'*
		
		restore
		
		
end