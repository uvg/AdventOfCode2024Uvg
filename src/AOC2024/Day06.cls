Class AOC2024.Day06 Extends AOC2024.Base
{

Parameter InputFile = "d06.txt";

// d ##class(AOC2024.Day06).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	set startPos=..FindStart(.recordsArr) //$listbuild(x,y,$lb(dx,dy))
	if verbose zwrite startPos
	set answer=..TotalDistinct(.recordsArr,$list(startPos,1),$list(startPos,2),$list($list(startPos,3),1),$list($list(startPos,3),2))
	quit answer
}

ClassMethod FindStart(ByRef recordsArr) As %String [ Private ]
{
	set line="",x=0,y=0,dir=""
	for  {
		set line=$order(recordsArr(line)) quit:'$length(line)
		set record=recordsArr(line)
		if record'["^",record'["v",record'["<",record'[">" continue
		set y=line
		set x=$find(record,"^") if x set dir=$listbuild(0,-1) quit
		set x=$find(record,"v") if x set dir=$listbuild(0,1) quit
		set x=$find(record,"<") if x set dir=$listbuild(-1,0) quit
		set x=$find(record,">") if x set dir=$listbuild(1,0) quit
	}
	quit $listbuild(x-1,y,dir)
}

ClassMethod TotalDistinct(ByRef grid, x As %Integer, y As %Integer, dx As %Integer, dy As %Integer) As %Integer [ Private ]
{
	set dirs=$listbuild($listbuild(-1,0),$listbuild(0,-1),$listbuild(1,0),$listbuild(0,1))
	set counter=1,width=$length(grid(1)),visited(x,y)=""
	for {
		set x=x+dx,y=y+dy
		if (x<1)||(x>width) quit
		if '$data(grid(y)) quit
		if $extract(grid(y),x)="#" {
			set findDirPos=$listfind(dirs,$listbuild(dx,dy))
			set nextDirPos=findDirPos+1 set:nextDirPos>$listlength(dirs) nextDirPos=1
			set dir=$list(dirs,nextDirPos)
			set x=x-dx,y=y-dy
			set dx=$list(dir,1),dy=$list(dir,2)
			continue
		}
		if $data(visited(x,y,dx,dy)) set counter=-1 quit  //loop
		if '$data(visited(x,y)) set visited(x,y,dx,dy)="",counter=counter+1
		//w !,x,",",y,",",dx,",",dy,",",counter
	}
	quit counter
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	set startPos=..FindStart(.recordsArr) //$listbuild(x,y,$lb(dx,dy))
	if verbose zwrite startPos
	set answer=..TotalDistinctNewObstruction(.recordsArr,$list(startPos,1),$list(startPos,2),$list($list(startPos,3),1),$list($list(startPos,3),2),verbose)
	quit answer
}

ClassMethod TotalDistinctNewObstruction(ByRef grid, startX As %Integer, startY As %Integer, dx As %Integer, dy As %Integer, verbose As %Boolean) As %Integer [ Private ]
{
	set width=$length(grid(1)),height=$order(grid(""),-1),counter=0
	for x=1:1:width {
		for y=1:1:height {
			if x=startX,y=startY continue
			if $extract(grid(y),x)="#" continue
			merge newGrid=grid set $extract(newGrid(y),x)="#"
			if ..TotalDistinct(.newGrid,startX,startY,dx,dy)=-1 {
				set counter=counter+1
				if verbose write !,counter,"=(",x,",",y,")"
			}
		}
	}
	quit counter
}

}

