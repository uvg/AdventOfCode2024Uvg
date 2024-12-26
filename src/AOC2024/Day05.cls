Class AOC2024.Day05 Extends AOC2024.Base
{

Parameter InputFile = "d05.txt";

// d ##class(AOC2024.Day05).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		quit:record'?2n1"|"2n
		set before=$piece(record,"|",1),after=$piece(record,"|",2)
		set arr(after,before)=""
	}
	for  {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line),isOk=1,len=$length(record,",")
		for i=len:-1:2 {
			set after=$piece(record,",",i)
			for j=i-1:-1:1 {
				set before=$piece(record,",",j)
				continue:'$data(arr(before,after))
				set isOk=0
				quit
			}
			quit:'isOk
		}
		set:isOk total=total+$piece(record,",",len+1/2)
		if verbose write !,record
	}
	set answer=total
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		quit:record'?2n1"|"2n
		set before=$piece(record,"|",1),after=$piece(record,"|",2)
		set arr(after,before)=""
	}
	for  {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line),isOk=1,len=$length(record,",")
		for i=len:-1:2 {
			set after=$piece(record,",",i)
			for j=i-1:-1:1 {
				set before=$piece(record,",",j)
				continue:'$data(arr(before,after))
				set isOk=0
				quit
			}
			quit:'isOk
		}
		continue:isOk
		if verbose write !!,record
		set newRecord=..FixRecord(record,.arr)
		if verbose write !,newRecord
		set total=total+$piece(newRecord,",",len+1/2)
	}
	set answer=total
	quit answer
}

ClassMethod FixRecord(record As %String, ByRef arr) As %String [ Private ]
{
	set num=+$piece(record,",",1),newArr($increment(newArr))=$listbuild(num,"","")
	for i=2:1:$length(record,",") {
		set num=+$piece(record,",",i)
		do ..UpdateArr(num,.newArr,.arr,1)
	}
	set newRecord=..GetNewRecord(.newArr,1)
	quit newRecord
}

ClassMethod GetNewRecord(ByRef newArr, node As %Integer) As %String [ Private ]
{
	quit:'$length(node) ""
	set data=newArr(node)
	set num=$list(data,1)
	set left=..GetNewRecord(.newArr,$list(data,2))
	set right=..GetNewRecord(.newArr,$list(data,3))
	set record=left_","_num_","_right
	if $extract(record)="," set $extract(record)=""
	if $extract(record,*)="," set $extract(record,*)=""
	quit record
}

ClassMethod UpdateArr(num As %Integer, ByRef newArr, ByRef arr, key As %Integer) [ Private ]
{
	set data=newArr(key)
	set tempNum=$list(data,1)
	if $data(arr(tempNum,num)) { //go left
		set nextNode=$list(data,2)
		if '$length(nextNode) {
			set newArr($increment(newArr))=$listbuild(num,"","")
			set nextNode=newArr,$list(data,2)=nextNode,newArr(key)=data
		} else {
			do ..UpdateArr(num,.newArr,.arr,nextNode)
		}
	} else { //go right
		set nextNode=$list(data,3)
		if '$length(nextNode) {
			set newArr($increment(newArr))=$listbuild(num,"","")
			set nextNode=newArr,$list(data,3)=nextNode,newArr(key)=data
		} else {
			do ..UpdateArr(num,.newArr,.arr,nextNode)
		}
	}
}

}

