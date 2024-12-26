Class AOC2024.Day04 Extends AOC2024.Base
{

Parameter InputFile = "d04.txt";

// d ##class(AOC2024.Day04).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0,width=$length(recordsArr(1)),height=$order(recordsArr(""),-1)
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line),start=0
		for {
			set start=$find(record,"X",start)
			quit:'start
			set total=total+..FindXMAS(start-1,line,.recordsArr)
		}
	}
	set answer=total
	quit answer
}

ClassMethod FindXMAS(x As %Integer, y As %Integer, ByRef recordsArr) As %Integer [ Private ]
{
	set total=0,str="MAS",strLen=$length(str)
	set dirX=$listbuild(-1,-1,0,1,1,1,0,-1)
	set dirY=$listbuild(0,-1,-1,-1,0,1,1,1)
	set dirLen=$listlength(dirX)
	for dirType=1:1:dirLen {
		set diffX=$list(dirX,dirType)
		set diffY=$list(dirY,dirType)
		set newX=x,newY=y,found=1
		for i=1:1:strLen {
			set newX=newX+diffX,newY=newY+diffY
			set record=$get(recordsArr(newY))
			if $extract(record,newX)'=$extract(str,i) {
				set found=0
				quit
			}
		}
		set:found total=total+1
	}
	quit total
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0,width=$length(recordsArr(1)),height=$order(recordsArr(""),-1)
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line),start=0
		for {
			set start=$find(record,"A",start)
			quit:'start
			set total=total+..FindXMAS2(start-1,line,.recordsArr)
		}
	}
	set answer=total
	quit answer
}

ClassMethod FindXMAS2(x As %Integer, y As %Integer, ByRef recordsArr) As %Boolean [ Private ]
{
	set tl=$extract($get(recordsArr(y-1)),x-1),tr=$extract($get(recordsArr(y-1)),x+1)
	set bl=$extract($get(recordsArr(y+1)),x-1),br=$extract($get(recordsArr(y+1)),x+1)
	if tl="M",br="S" {
		if tr="M",bl="S" quit 1
		if tr="S",bl="M" quit 1
	}
	if br="M",tl="S" {
		if tr="M",bl="S" quit 1
		if tr="S",bl="M" quit 1
	}
	quit 0
}

}

