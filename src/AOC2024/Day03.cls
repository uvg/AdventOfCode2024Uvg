Class AOC2024.Day03 Extends AOC2024.Base
{

Parameter InputFile = "d03.txt";

// d ##class(AOC2024.Day03).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		continue:record'?.e1"mul("1.3n1","1.3n1")".e
		set totalMul=$length(record,"mul(")
		for i=1:1:totalMul {
			set value=$piece($piece(record,"mul(",i),")")
			continue:value'?1.3n1","1.3n
			set val1=$piece(value,",",1),val2=$piece(value,",",2)
			set total=val1*val2+total
			if verbose write !,val1,"*",val2,?15," ---> ",total
		}
	}
	set answer=total
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0,do=1
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		continue:record'?.e1"mul("1.3n1","1.3n1")".e
		set len=$length(record)
		for i=1:1:len {
			if $extract(record,i,i+3)="do()" {
				set do=1,i=i+3
				continue
			}
			if $extract(record,i,i+6)="don't()" {
				set do=0,i=i+6
				continue
			}
			continue:'do
			continue:$extract(record,i,i+3)'="mul("
			set value=$extract(record,i,i+11)
			set value=$piece(value,"mul(",2)
			continue:value'?1.3n1","1.3n1")".e
			set val1=+$piece(value,",",1),val2=+$piece(value,",",2)
			set total=val1*val2+total
			if verbose write !,val1,"*",val2,?10,"---> ",total
		}
	}
	set answer=total
	quit answer
}

}

