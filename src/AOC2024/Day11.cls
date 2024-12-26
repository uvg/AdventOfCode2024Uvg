Class AOC2024.Day11 Extends AOC2024.Base
{

Parameter InputFile = "d11.txt";

// d ##class(AOC2024.Day11).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",data=recordsArr(1)
	set stones=""
	for i=1:1:$length(data," ") {
		set stone=+$piece(data," ",i)
		set stones=stones_$listbuild(stone)
	}
	if verbose zwrite stones
	set totalSteps=25
	for step=1:1:totalSteps {
		set stones=..ChangeStones(stones)
		if verbose write !,step,".  ",$listlength(stones)
	}
	set answer=$listlength(stones)
	quit answer
}

ClassMethod ChangeStones(stones As %String) As %String [ Private ]
{
	set totalStones=$listlength(stones)
	set newStones=""
	for i=1:1:totalStones {
		set stone=$list(stones,i)
		if stone=0 {
			set newStones=newStones_$listbuild(1)
			continue
		}
		set len=$length(stone)
		if len#2=0 {
			set newStones=newStones_$listbuild(+$extract(stone,1,len/2),+$extract(stone,len/2+1,*))
			continue
		}
		set newStones=newStones_$listbuild(stone*2024)
	}
	quit newStones
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",data=recordsArr(1)
	set stones=""
	for i=1:1:$length(data," ") {
		set stone=+$piece(data," ",i)
		set stones(stone)=$get(stones(stone))+1
	}
	if verbose zwrite stones
	set totalSteps=75,total=0
	for step=1:1:totalSteps {
		do ..ChangeStones2(.stones)
		if verbose write !!,step,! zwrite stones
	}
	set stone=""
	for  {
		set stone=$order(stones(stone)) quit:'$length(stone)
		set total=total+stones(stone)
	}
	set answer=total
	quit answer
}

ClassMethod ChangeStones2(ByRef stones) [ Private ]
{
	merge newStones=stones
	set stone=""
	for  {
		set stone=$order(stones(stone)) quit:'$length(stone)
		set total=stones(stone)
		set newStones(stone)=newStones(stone)-total
		kill:'newStones(stone) newStones(stone)
		if stone=0 {
			set newStones(1)=$get(newStones(1))+total
			continue
		}
		set len=$length(stone)
		if len#2=0 {
			set tempStone=+$extract(stone,1,len/2)
			set newStones(tempStone)=$get(newStones(tempStone))+total
			set tempStone=+$extract(stone,len/2+1,*)
			set newStones(tempStone)=$get(newStones(tempStone))+total
			continue
		}
		set tempStone=stone*2024
		set newStones(tempStone)=$get(newStones(tempStone))+total
	}
	kill stones merge stones=newStones
	quit
}

}

