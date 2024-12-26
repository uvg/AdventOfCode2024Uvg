Class AOC2024.Day23 Extends AOC2024.Base
{

Parameter InputFile = "d23.txt";

// d ##class(AOC2024.Day23).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set comp1=$piece(record,"-",1),comp2=$piece(record,"-",2)
		set arr(comp1,comp2)="",arr(comp2,comp1)=""
	}
	//zw arr
	set comp1=""
	for  {
		set comp1=$order(arr(comp1)) quit:'$length(comp1)
		set comp2=""
		for  {
			set comp2=$order(arr(comp1,comp2)) quit:'$length(comp2)
			set comp3=""
			for  {
				set comp3=$order(arr(comp2,comp3)) quit:'$length(comp3)
				continue:comp3=comp1
				if $data(arr(comp1,comp3)) set arr3(comp1,comp2,comp3)=""
			}
		}
	}
	set comp1=""
	for  {
		set comp1=$order(arr3(comp1)) quit:'$length(comp1)
		set comp2=""
		for  {
			set comp2=$order(arr3(comp1,comp2)) quit:'$length(comp2)
			set comp3=""
			for  {
				set comp3=$order(arr3(comp1,comp2,comp3)) quit:'$length(comp3)
				kill arr3(comp1,comp3,comp2)
				kill arr3(comp2,comp1,comp3)
				kill arr3(comp2,comp3,comp1)
				kill arr3(comp3,comp1,comp2)
				kill arr3(comp3,comp2,comp1)
			}
		}
	}
	//zw arr3
	set comp1="",total=0
	for  {
		set comp1=$order(arr3(comp1)) quit:'$length(comp1)
		set comp2=""
		for  {
			set comp2=$order(arr3(comp1,comp2)) quit:'$length(comp2)
			set comp3=""
			for  {
				set comp3=$order(arr3(comp1,comp2,comp3)) quit:'$length(comp3)
				if ($extract(comp1)="t")||($extract(comp2)="t")||($extract(comp3)="t") {
					set total=total+1
					if verbose zwrite arr3(comp1,comp2,comp3)
				}
			}
		}
	}
	set answer=total
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set comp1=$piece(record,"-",1),comp2=$piece(record,"-",2)
		set arr(comp1,comp2)="",arr(comp2,comp1)=""
	}
	//zw arr
	set comp1="",max=0
	for  {
		set comp1=$order(arr(comp1)) quit:'$length(comp1)
		//b:comp1="td"
		set total=..GetMaxLen(.arr,comp1,.arrTempCandidates)
		continue:total'>max
		set max=total
		kill arrCandidates
		merge arrCandidates=arrTempCandidates
	}
	if verbose zwrite max,arrCandidates
	set comp="",password=""
	for  {
		set comp=$order(arrCandidates(comp)) quit:'$length(comp)
		set password=password_","_comp
		//zwrite arr(comp)
	}
	set answer=$extract(password,2,*)
	quit answer
}

ClassMethod GetMaxLen(ByRef arr, comp1 As %String, Output arrCandidates) [ Private ]
{
	kill arrCandidates
	set max=0
	set comp2=""
	for  {
		set comp2=$order(arr(comp1,comp2)) quit:'$length(comp2)
		merge arrTemp=arr
		for  {
			set noChange=1
			set comp3=""
			for  {
				set comp3=$order(arrTemp(comp1,comp3)) quit:'$length(comp3)
				continue:comp3=comp2
				continue:$data(arrTemp(comp2,comp3))
				set noChange=0
				kill arrTemp(comp1,comp3)
				quit
			}
			quit:noChange
		}
		set total=1,comp=""
		for  {
			set comp=$order(arrTemp(comp1,comp)) quit:'$length(comp)
			set total=total+1
		}
		continue:total'>max
		kill arrTempCandidates
		set arrTempCandidates(comp1)=""
		merge arrTempCandidates=arrTemp(comp1)
		continue:'..allConnected(.arr,.arrTempCandidates)
		set max=total
		kill arrCandidates
		merge arrCandidates=arrTempCandidates
		//zw max,arrCandidates
	}
	quit max
}

ClassMethod allConnected(ByRef arrAllConn, ByRef arrConn) As %Boolean [ Private ]
{
	set comp1=""
	for  {
		set comp1=$order(arrConn(comp1)) quit:'$length(comp1)
		set comp2=comp1
		for  {
			set comp2=$order(arrConn(comp2)) quit:'$length(comp2)
			if '$data(arrAllConn(comp1,comp2)) return 0
		}
	}
	quit 1
}

}

