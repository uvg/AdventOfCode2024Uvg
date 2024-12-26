Class AOC2024.Day02 Extends AOC2024.Base
{

Parameter InputFile = "d02.txt";

// d ##class(AOC2024.Day02).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",counter=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set dir=0,safe=1,numbers=$length(record," ")
		set last=$piece(record," ",1)
		for i=2:1:numbers {
			set curr=$piece(record," ",i)
			set diff=curr-last
			set dir=$select(dir:dir,diff<0:-1,1:1)
			if ((diff<0)&&(dir=1))||((diff>0)&&(dir=-1)) {
				set safe=0
				quit
			}
			if ($zabs(diff)<1)||($zabs(diff)>3) {
				set safe=0
				quit
			}
			set last=curr
		}
		if safe set counter=counter+1
		if verbose write !,record,?20," ---> ",safe
	}
	set answer=counter
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",counter=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line),numbers=$length(record," ")
		set safe=0
		for pc=0:1:numbers {
			set newRecord=record
			if pc set $piece(newRecord," ",pc)="",newRecord=$zstrip(newRecord,"<=>W")
			set safe=..IsSafe(newRecord)
			quit:safe
		}
		if safe set counter=counter+1
		if verbose write !,record,?20," ---> ",safe
	}
	set answer=counter
	quit answer
}

ClassMethod IsSafe(record) As %Boolean [ Private ]
{
	set dir=0,safe=1,numbers=$length(record," ")
	set last=$piece(record," ",1)
	for i=2:1:numbers {
		set curr=$piece(record," ",i)
		set diff=curr-last
		set dir=$select(dir:dir,diff<0:-1,1:1)
		if ((diff<0)&&(dir=1))||((diff>0)&&(dir=-1)) {
			set safe=0
			quit
		}
		if ($zabs(diff)<1)||($zabs(diff)>3) {
			set safe=0
			quit
		}
		set last=curr
	}
	quit safe
}

}

