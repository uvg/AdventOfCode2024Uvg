Class AOC2024.Day19 Extends AOC2024.Base
{

Parameter InputFile = "d19.txt";

// d ##class(AOC2024.Day19).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set data=recordsArr(1),len=$length(data,", "),maxLen=0
	for i=1:1:len {
		set availablePattern=$piece(data,", ",i),availablePatternLen=$length(availablePattern)
		set arr($reverse(availablePattern))=""
		set:availablePatternLen>maxLen maxLen=availablePatternLen
	}
	//write !,maxLen
	set answer="",line=2,total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set isPatternPossible=..IsPatternPossible($reverse(record),maxLen,.arr)
		set total=total+isPatternPossible
		if verbose write !,record,"=",isPatternPossible
	}
	set answer=total
	quit answer
}

ClassMethod IsPatternPossible(pattern As %String, maxPatternSize As %Integer, ByRef arrAvailablePatterns, findAll As %Boolean = 0, ByRef knownPatterns) [ Private ]
{
	set len=$length(pattern) quit:'len 1
	set from=len
	set:maxPatternSize<from from=maxPatternSize
	//w !,pattern
	set total=0
	for i=from:-1:1 {
		continue:'$data(arrAvailablePatterns($extract(pattern,1,i)))
		set right=$extract(pattern,i+1,*)
		if $length(right),$data(knownPatterns(right)) {
			set possiblePatterns=knownPatterns(right)
		} else {
			set possiblePatterns=..IsPatternPossible(right,maxPatternSize,.arrAvailablePatterns,findAll,.knownPatterns)
			set:$length(right) knownPatterns(right)=possiblePatterns
		}
		continue:'possiblePatterns
		if 'findAll return 1
		set total=total+possiblePatterns
	}
	quit total
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set data=recordsArr(1),len=$length(data,", "),maxLen=0
	for i=1:1:len {
		set availablePattern=$piece(data,", ",i),availablePatternLen=$length(availablePattern)
		set arr($reverse(availablePattern))=""
		set:availablePatternLen>maxLen maxLen=availablePatternLen
	}
	//write !,maxLen
	set answer="",line=2,total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set isPatternPossible=..IsPatternPossible($reverse(record),maxLen,.arr,1)
		set total=total+isPatternPossible
		if verbose write !,record,"=",isPatternPossible
	}
	set answer=total
	quit answer
}

}

