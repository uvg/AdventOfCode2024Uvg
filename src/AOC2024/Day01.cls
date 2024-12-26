Class AOC2024.Day01 Extends AOC2024.Base
{

Parameter InputFile = "d01.txt";

// d ##class(AOC2024.Day01).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set value1=$piece(record,"   ",1),value2=$piece(record,"   ",2)
		if $increment(arr1(value1)) set arr1(value1,line)=""
		if $increment(arr2(value2)) set arr2(value2,line)=""
	}
	set value1=$order(arr1("")),value2=$order(arr2("")),total=0,key1="",key2=""
	for  {
		set key1=$order(arr1(value1,key1))
		set key2=$order(arr2(value2,key2))
		if '$length(key1) {
			set value1=$order(arr1(value1)) quit:'$length(value1)
			set key1=$order(arr1(value1,""))
		}
		if '$length(key2) {
			set value2=$order(arr2(value2))
			set key2=$order(arr2(value2,""))
		}
		set total=total+$zabs(value1-value2)
		if verbose write !,value1,",",value2,?15,"--> ",total
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
		set value1=$piece(record,"   ",1),value2=$piece(record,"   ",2)
		if $increment(arr1(value1)) set arr1(value1,line)=""
		if $increment(arr2(value2)) set arr2(value2,line)=""
	}
	set value1="",total=0
	for  {
		set value1=$order(arr1(value1)) q:'$l(value1)
		set total=total+(value1*arr1(value1)*$get(arr2(value1)))
		if verbose write !,value1,"*",arr1(value1),"*",+$get(arr2(value1)),?15,"--> ",total
	}
	set answer=total
	quit answer
}

}

