Class AOC2024.Day10 Extends AOC2024.Base
{

Parameter InputFile = "d10.txt";

// d ##class(AOC2024.Day10).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	do ..GetStartPoints(.recordsArr,.startPointsArr)
	if verbose zwrite startPointsArr,recordsArr
	set counter="",total=0
	for  {
		set counter=$order(startPointsArr(counter)) quit:'$length(counter)
		set startPoint=startPointsArr(counter),x=$list(startPoint,1),y=$list(startPoint,2)
		set score=..GetScore(.recordsArr,x,y,0)
		if verbose write !,"(",x,",",y,") = ",score
		set total=total+score
	}
	set answer=total
	quit answer
}

ClassMethod GetStartPoints(ByRef grid, Output startPointsArr) [ Private ]
{
	set y="",width=$length(grid(1))
	for {
		set y=$order(grid(y)) quit:y=""
		set record=grid(y)
		continue:record'[0
		for x=1:1:width {
			continue:$extract(record,x)'=0
			set startPointsArr($increment(startPointsArr))=$listbuild(x,y)
		}
	}
}

ClassMethod GetScore(ByRef grid, fromX As %Integer, fromY As %Integer, value As %Integer, ByRef visited, getAll As %Boolean = 0) As %Integer [ Private ]
{
	if '$data(grid(fromY)) quit 0
	quit:$data(visited(fromX,fromY)) 0
	if $extract(grid(fromY),fromX)'=value quit 0
	set visited(fromX,fromY)=""
	if value=9 quit 1
	set score=0
	set dirs=$listbuild($listbuild(0,1),$listbuild(0,-1),$listbuild(1,0),$listbuild(-1,0))
	set totalDirs=$listlength(dirs)
	for i=1:1:totalDirs {
		set dir=$list(dirs,i),dx=$list(dir,1),dy=$list(dir,2)
		if getAll {
			kill tempVisited merge tempVisited=visited
			set score=score+..GetScore(.grid,fromX+dx,fromY+dy,value+1,.tempVisited,1)
		} else {
			set score=score+..GetScore(.grid,fromX+dx,fromY+dy,value+1,.visited,0)
		}
	}
	quit score
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	do ..GetStartPoints(.recordsArr,.startPointsArr)
	if verbose zwrite startPointsArr,recordsArr
	set counter="",total=0
	for  {
		set counter=$order(startPointsArr(counter)) quit:'$length(counter)
		set startPoint=startPointsArr(counter),x=$list(startPoint,1),y=$list(startPoint,2)
		set score=..GetScore(.recordsArr,x,y,0,,1)
		if verbose write !,"(",x,",",y,") = ",score
		set total=total+score
	}
	set answer=total
	quit answer
}

}

