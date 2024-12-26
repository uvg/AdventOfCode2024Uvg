Class AOC2024.Day09 Extends AOC2024.Base
{

Parameter InputFile = "d09.txt";

// d ##class(AOC2024.Day09).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",data=recordsArr(1)
	set type=0,id=0,pos=0
	for i=1:1:$length(data) {
		set size=$extract(data,i)
		set info=$select(type=0:id,1:-1)
		for j=1:1:size {
			set arr(pos)=info
			set pos=pos+1
		}
		set type='type
		set:'type id=id+1
	}
	//if verbose zwrite "before:",arr
	set tail="",head=""
	for  {
		set tail=$order(arr(tail),-1)
		quit:'$length(tail)
		quit:head>=tail
		set id=arr(tail)
		continue:id<0
		for  {
			set head=$order(arr(head))
			quit:'$length(head)
			quit:head>=tail
			quit:arr(head)=-1
		}
		quit:head>=tail
		set arr(head)=id,arr(tail)=-1
	}
	set pos=0,total=0
	for  {
		set pos=$order(arr(pos)) quit:'$length(pos)
		set id=arr(pos) quit:id<0
		continue:id=0
		set total=id*pos+total
	}
	//if verbose zwrite "after:",arr
	set answer=total
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",data=recordsArr(1)
	set type=0,id=0,pos=0
	for i=1:1:$length(data) {
		set size=$extract(data,i)
		set info=$select(type=0:id,1:-1)
		set:'type arr2(id)=$listbuild(pos,pos+size-1)
		for j=1:1:size {
			set arr(pos)=info
			set pos=pos+1
		}
		set type='type
		set:'type id=id+1
	}
	//if verbose write !,"before:",! zwrite arr,id,arr2
	set id=""
	for  {
		set id=$order(arr2(id),-1) quit:'id
		set data=arr2(id)
		set startTail=$list(data,1),tail=$list(data,2)
		set idSize=tail-startTail+1
		if verbose write !,id,":",startTail," - ",tail," = ",idSize
		set head=""
		for  {
			set head=$order(arr(head))
			quit:'$length(head)
			//i id=9994,head=19 b
			quit:head>=startTail
			continue:arr(head)'=-1
			set headEnd=head,headSize=1
			while idSize>headSize {
				set headEnd=$order(arr(headEnd)) quit:'$length(headEnd)
				//quit:headEnd>startTail
				if arr(headEnd)'=-1 {
					set headEnd=headEnd-1
					set headSize=headEnd-head+1
					quit
				}
				set headSize=headSize+1
				//quit:headSize=idSize
			}
			//continue:'headSize
			continue:headSize'=idSize
			if verbose write " >>>> ",head," - ",headEnd
			for posTail=startTail:1:tail {
				set arr(head+posTail-startTail)=id,arr(posTail)=-1
			}
			quit
		}
	}
	set pos=0,total=0
	for  {
		set pos=$order(arr(pos)) quit:'$length(pos)
		set id=arr(pos)
		continue:id<1
		set total=id*pos+total
	}
	//if verbose write !,"after:",! zwrite arr
	set answer=total
	quit answer
}

}

