Class AOC2024.Day16 Extends AOC2024.Base
{

Parameter InputFile = "d16.txt";

// d ##class(AOC2024.Day16).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set pos=..GetStartPos(.recordsArr)
	if verbose write !!,"before:"
	if verbose do ..GridDisplay(.recordsArr)
	set startPos=$list(pos,1),endPos=$list(pos,2),currDir=$listbuild(1,0)
	set answer=..FindShortestPathPriorityQueue(.recordsArr,$list(startPos,1),$list(startPos,2),$list(endPos,1),$list(endPos,2),,,.path,,,,,currDir,1,1000)
	do ..SetPathOnGrid(.recordsArr,path)
	if verbose write !!,"after:"
	if verbose do ..GridDisplay(.recordsArr)
	quit answer
}

ClassMethod SetPathOnGrid(ByRef grid, path As %String, extLtr As %String = "") [ Private ]
{
	set pathLen=$listlength(path)
	for i=1:1:pathLen {
		set data=$list(path,i)
		set x=$list(data,1),y=$list(data,2),dir=$listget(data,4)
		set ltr=$select($length(extLtr):extLtr,$list(dir,1)=-1:"<",$list(dir,1)=1:">",$list(dir,2)=-1:"^",$list(dir,2)=1:"v")
		set $extract(grid(y),x)=ltr
	}
}

ClassMethod FindShortestPathPriorityQueue(ByRef grid, fromX As %Integer, fromY As %Integer, toX As %Integer, toY As %Integer, steps As %Integer = 0, ByRef visited, path As %String = "", maxsteps As %Integer = 0, ByRef noVisitPlaces, value As %Integer = 0, maxValue As %Integer = 0, dir As %String = "", valueOnStep As %Integer = 1, valueOnDirChange As %Integer = 1)
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
			set cnt=cnt+1,Queue(nextValue,cnt)=$listbuild(fromX+nextDirDx,fromY+nextDirDy,steps+1,nextDir,path_$listbuild($listbuild(fromX+nextDirDx,fromY+nextDirDy,steps+1,nextDir,nextValue)))
		}
	}
	quit minValue
}

ClassMethod FindShortestPathQueue(ByRef grid, fromX As %Integer, fromY As %Integer, toX As %Integer, toY As %Integer, steps As %Integer = 0, ByRef visited, path As %String = "", maxsteps As %Integer = 0, ByRef noVisitPlaces, value As %Integer = 0, maxValue As %Integer = 0, dir As %String = "", valueOnStep As %Integer = 1, valueOnDirChange As %Integer = 1, Output bestPaths) [ Private ]
{
	//$$FindShortestPathQueue(.grid,2,1,8,4) from 2,1 to 8,4 with initial steps of 0 and no maxsteps boundry
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
	//k ^||Queue
	set maxValueDiff=valueOnDirChange
	set:valueOnStep>maxValueDiff maxValueDiff=valueOnStep
	set last=0
	set last=last+1,Queue(last)=$listbuild(steps,fromX,fromY,path,dir,value)
	for  {
		set key=$order(Queue("")) quit:key=""
		set data=Queue(key)
		//kill visited merge visited=^||Queue(key,"visited")
		kill Queue(key) //,^||Queue(key)
		set steps=$list(data,1),fromX=$list(data,2),fromY=$list(data,3),path=$list(data,4),dir=$list(data,5),value=$list(data,6)
		if maxsteps,steps>maxsteps continue
		if maxValue,value>maxValue continue
		continue:$data(noVisitPlaces(fromX,fromY))
		set type=$extract($get(grid(fromY)),fromX)
		if type="#"||'$length(type) continue
		if $data(visited(fromX,fromY)),visited(fromX,fromY)+maxValueDiff<value {
			continue
		}
		//if $listfind(path,$listbuild(fromX,fromY)) continue //already visited
		set path=path_$listbuild($listbuild(fromX,fromY))
		set visited(fromX,fromY)=value
		set visited(fromX,fromY,"path")=path
		if fromX=toX,fromY=toY {
			if value<=minValue {
				set minValue=value,bestPaths(value,$increment(bestPaths(value)))=path
				//zw Queue
			}
			continue
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
			set last=last+1,Queue(last)=$listbuild(steps+1,fromX+nextDirDx,fromY+nextDirDy,path,nextDir,nextValue)
			//merge ^||Queue(last,"visited")=visited
			//zw visited h .001
		}
	}
	quit minValue
}

ClassMethod GetStartPos(ByRef grid) As %String [ Private ]
{
	set y="",width=$length(grid(1)),startPos="",endPos=""
	for  {
		set y=$order(grid(y)) quit:'$length(y)
		set data=grid(y)
		for x=1:1:width {
			if $extract(data,x)="S" set startPos=$listbuild(x,y)
			if $extract(data,x)="E" set endPos=$listbuild(x,y)
		}
	}
	quit $listbuild(startPos,endPos)
}

ClassMethod GridDisplay(ByRef grid) [ Private ]
{
	//grid(y)=data
	set y=""
	for  {
		set y=$order(grid(y)) quit:y=""
		write !,grid(y)
	}
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set pos=..GetStartPos(.recordsArr)
	if verbose write !!,"before:"
	if verbose do ..GridDisplay(.recordsArr)
	set startPos=$list(pos,1),endPos=$list(pos,2),currDir=$listbuild(1,0)
	set value=..FindShortestPathPriorityQueue(.recordsArr,$list(startPos,1),$list(startPos,2),$list(endPos,1),$list(endPos,2),,,.path,1000000,,0,,currDir,1,1000)
	do ..FindShortestPathQueue(.recordsArr,$list(startPos,1),$list(startPos,2),$list(endPos,1),$list(endPos,2),,,,,,,value,currDir,1,1000,.bestPaths)
	set answer=..SetAllPathsOnGrid(.recordsArr,.bestPaths,value)
	if verbose write !!,"after:"
	if verbose do ..GridDisplay(.recordsArr)
	quit answer
}

ClassMethod SetAllPathsOnGrid(ByRef grid, ByRef bestPaths, value As %Integer) As %Integer [ Private ]
{
	set cnt=""
	for  {
		set cnt=$order(bestPaths(value,cnt)) quit:'$length(cnt)
		set path=bestPaths(value,cnt)
		do ..SetPathOnGrid(.grid,path,"O")
	}
	set total=0,y=""
	for  {
		set y=$order(grid(y)) quit:'$length(y)
		set data=grid(y)
		set total=total+$length(grid(y),"O")-1
	}
	quit total
}

}

