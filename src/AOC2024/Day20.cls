Class AOC2024.Day20 Extends AOC2024.Base
{

Parameter InputFile = "d20.txt";

// d ##class(AOC2024.Day20).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",(fromX,fromY,toX,toY)=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if record["S" set fromX=$find(record,"S")-1,fromY=line
		if record["E" set toX=$find(record,"E")-1,toY=line
		if fromX,toX quit
	}
	//zwrite fromX,fromY,toX,toY
	//set $extract(recordsArr(2),9,10)=".."
	//set $extract(recordsArr(8),11,12)=".."
	//set $extract(recordsArr(9),9)=".",$extract(recordsArr(10),9)=".."
	//set $extract(recordsArr(8),6,7)=".."
	set pathLenWithoutCheat=..FindShortestPathPriorityQueue(.recordsArr,fromX,fromY,toX,toY,,,.pathStartToEnd)
	if verbose zwrite pathLenWithoutCheat //,pathStartToEnd
	set minCheatValue=100
	set:$order(recordsArr(""),-1)<100 minCheatValue=1 //test
	do ..getcheatPosArr(.recordsArr,$listbuild($listbuild(fromX,fromY))_pathStartToEnd,minCheatValue,.cheatPosArr)
	set answer=..getTotalCheats(.cheatPosArr,minCheatValue)
	quit answer
}

ClassMethod getcheatPosArr(ByRef grid, pathStartToEnd As %String, minDiff As %Integer, Output cheatPosArr) [ Private ]
{
	set dirs=$listbuild($listbuild(-1,0),$listbuild(0,-1),$listbuild(1,0),$listbuild(0,1)),totalDirs=$listlength(dirs)
	set pathLen=$listlength(pathStartToEnd)
	for i=1:1:pathLen {
		set pos=$list(pathStartToEnd,i)
		set x=$list(pos,1),y=$list(pos,2)
		for dirPos=1:1:totalDirs {
			set dir=$list(dirs,dirPos),dx=$list(dir,1),dy=$list(dir,2)
			set nextX=x+dx,nextY=y+dy
			continue:$extract($get(grid(nextY)),nextX)'="#"
			set nextNextX=nextX+dx,nextNextY=nextY+dy
			set distFromStart=$listfind(pathStartToEnd,$listbuild(nextNextX,nextNextY))
			continue:'distFromStart
			set diff=distFromStart-i-2
			continue:diff<minDiff  //not enough
			set cheatPosArr(diff,$listbuild(nextNextX,nextNextY))=""
			//set distFromEnd=pathLen-distFromStart
			//zw $listbuild(nextNextX,nextNextY),distFromStart,distFromEnd
		}
	}
	//zw cheatPosArr
	quit
}

ClassMethod getTotalCheats(ByRef cheatPosArr, minCheatValue As %Integer) As %Integer [ Private ]
{
	set cheatValue=minCheatValue-1,total=0
	for  {
		set cheatValue=$order(cheatPosArr(cheatValue)) quit:'$length(cheatValue)
		set cheatPos=""
		for  {
			set cheatPos=$order(cheatPosArr(cheatValue,cheatPos)) quit:'$length(cheatPos)
			set total=total+1		
		}
	}
	quit total
}

ClassMethod FindShortestPathPriorityQueue(ByRef grid, fromX As %Integer, fromY As %Integer, toX As %Integer, toY As %Integer, steps As %Integer = 0, ByRef visited, path As %String = "", maxsteps As %Integer = 0, ByRef noVisitPlaces, value As %Integer = 0, maxValue As %Integer = 0, dir As %String = "", valueOnStep As %Integer = 1, valueOnDirChange As %Integer = 0) [ Private ]
{
	//$$FindShortestPathPriorityQueue(.grid,2,1,8,4) from 2,1 to 8,4 with initial steps of 0 and no maxsteps boundry
	//grid(y)=data
	//I $e(data,x)="#" ==> can't visit there
	//There should be no holes in the grid so if y=5..10 then there should be grid(5),grid(6),grid(7),,,grid(10)
	set maxNum=9999999
	set minValue=maxNum
	if maxsteps,steps>maxsteps quit maxNum
	if maxValue,value>maxValue quit maxNum
	quit:$data(noVisitPlaces(fromX,fromY)) maxNum
	if fromX=toX,fromY=toY quit value
	set dirs=$listbuild($listbuild(-1,0),$listbuild(0,-1),$listbuild(1,0),$listbuild(0,1)),totalDirs=$listlength(dirs)
	set:'$length(dir) dir=$list(dirs,1)
	set cnt=0
	set cnt=cnt+1,Queue(value,cnt)=$listbuild(fromX,fromY,steps,dir,path)
	for  {
		set value=$order(Queue("")) quit:'$length(value)
		set key=$order(Queue(value,"")),data=Queue(value,key) kill Queue(value,key)
		set fromX=$list(data,1),fromY=$list(data,2),steps=$list(data,3),dir=$list(data,4),path=$list(data,5)
		if maxsteps,steps>maxsteps continue
		if maxValue,value>maxValue continue
		continue:$data(noVisitPlaces(fromX,fromY))
		set type=$extract($get(grid(fromY)),fromX)
		if type="#"||'$length(type) continue
		if $data(visited(fromX,fromY)),visited(fromX,fromY)<=value {
			continue
		}
		set visited(fromX,fromY)=steps
		set visited(fromX,fromY,"path")=path
		set visited(fromX,fromY)=value
		set visited(fromX,fromY,"path")=path
		if fromX=toX,fromY=toY {
			set:value<minValue minValue=value
			quit
		}
		set dirPos=$listfind(dirs,dir)
		for nextDirPos=1:1:totalDirs {
			set nextDir=$list(dirs,nextDirPos)
			set nextValue=value+valueOnStep
			if nextDir'=dir {
				set nextValue=nextValue+valueOnDirChange
				if $zabs(dirPos-nextDirPos)=2 set nextValue=nextValue+valueOnDirChange
			}
			set nextDirDx=$list(nextDir,1),nextDirDy=$list(nextDir,2)
			continue:$extract($get(grid(fromY+nextDirDy)),fromX+nextDirDx)="#"
			set dataOnPath=$listbuild(fromX+nextDirDx,fromY+nextDirDy) //,steps+1,nextDir,nextValue
			set cnt=cnt+1,Queue(nextValue,cnt)=$listbuild(fromX+nextDirDx,fromY+nextDirDy,steps+1,nextDir,path_$listbuild(dataOnPath))
		}
	}
	//w !,fromX,";",fromY,";",steps
	quit minValue
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",(fromX,fromY,toX,toY)=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if record["S" set fromX=$find(record,"S")-1,fromY=line
		if record["E" set toX=$find(record,"E")-1,toY=line
		if fromX,toX quit
	}
	//zwrite fromX,fromY,toX,toY
	//set $extract(recordsArr(2),9,10)=".."
	//set $extract(recordsArr(8),11,12)=".."
	//set $extract(recordsArr(9),9)=".",$extract(recordsArr(10),9)=".."
	//set $extract(recordsArr(8),6,7)=".."
	set pathLenWithoutCheat=..FindShortestPathPriorityQueue(.recordsArr,fromX,fromY,toX,toY,,,.pathStartToEnd)
	if verbose zwrite pathLenWithoutCheat //,pathStartToEnd
	set minCheatValue=100
	set:$order(recordsArr(""),-1)<100 minCheatValue=50 //test
	do ..getcheatPosArr2(.recordsArr,$listbuild($listbuild(fromX,fromY))_pathStartToEnd,minCheatValue,.cheatPosArr)
	set answer=..getTotalCheats(.cheatPosArr,minCheatValue)
	quit answer
}

ClassMethod getcheatPosArr2(ByRef grid, pathStartToEnd As %String, minDiff As %Integer, Output cheatPosArr) [ Private ]
{
	set dirs=$listbuild($listbuild(-1,0),$listbuild(0,-1),$listbuild(1,0),$listbuild(0,1)),totalDirs=$listlength(dirs)
	set pathLen=$listlength(pathStartToEnd)
	for i=1:1:pathLen {
		set path(i)=$list(pathStartToEnd,i)
	}
	//zw path
	set dist=""
	for  {
		set dist=$order(path(dist)) quit:'$length(dist)
		set pos1=path(dist)
		set x1=$list(pos1,1),y1=$list(pos1,2)
		set nextDist=dist+minDiff-1
		for  {
			set nextDist=$order(path(nextDist)) quit:'$length(nextDist)
			set pos2=path(nextDist)
			set x2=$list(pos2,1),y2=$list(pos2,2)
			set diff=$zabs(x1-x2)+$zabs(y1-y2)
			if diff,diff<=20 set cheatPosArr(nextDist-dist-diff,$listbuild(pos1,pos2))=""
		}
	}
	quit
}

}

