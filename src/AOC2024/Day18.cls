Class AOC2024.Day18 Extends AOC2024.Base
{

Parameter InputFile = "d18.txt";

// d ##class(AOC2024.Day18).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set maxY=70,lastRecord=$order(recordsArr(""),-1),maxRead=1024
	if lastRecord<100 set maxY=6,maxRead=12 //example
	do ..initGrid(.grid,.recordsArr,maxY,maxRead)
	if verbose write !!,"Before:",! do ..GridDisplay(.grid)
	set answer=..FindShortestPathPriorityQueue(.grid,1,0,maxY+1,maxY,,,.path,,)
	do ..setPathOnGrid(.grid,path)
	if verbose write !!,"After:",! do ..GridDisplay(.grid)
	quit answer
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

ClassMethod setPathOnGrid(ByRef grid, path As %String) [ Private ]
{
	set pathLen=$listlength(path)
	for i=1:1:pathLen {
		set pos=$list(path,i)
		set $extract(grid($list(pos,2)),$list(pos,1))="O"
	}
}

ClassMethod initGrid(ByRef grid, ByRef recordsArr, maxY As %Integer, lastRecord As %Integer) [ Private ]
{
	kill grid
	set line="",emptyData=$tr($justify("",maxY+1)," ",".")
	for  {
		set line=$order(recordsArr(line)) quit:'$length(line)  quit:line>lastRecord
		set data=recordsArr(line),x=+$piece(data,",",1),y=+$piece(data,",",2)
		set gridData=$get(grid(y)) set:'$length(gridData) gridData=emptyData
		set $extract(gridData,x+1)="#"
		set grid(y)=gridData
	}
}

ClassMethod FindShortestPathPriorityQueue(ByRef grid, fromX As %Integer, fromY As %Integer, toX As %Integer, toY As %Integer, steps As %Integer = 0, ByRef visited, path As %String = "", maxsteps As %Integer = 0, ByRef noVisitPlaces) [ Private ]
{
	//$$FindShortestPathPriorityQueue(.grid,2,1,8,4) from 2,1 to 8,4 with initial steps of 0 and no maxsteps boundry
	//grid(y)=data
	//I $e(data,x)="#" ==> can't visit there
	//There should be no holes in the grid so if y=5..10 then there should be grid(5),grid(6),grid(7),,,grid(10)
	set maxVal=999999
	set minSteps=maxVal
	if maxsteps,steps>maxsteps quit maxVal
	quit:$data(noVisitPlaces(fromX,fromY)) maxVal
	if fromX=toX,fromY=toY quit steps
	set dirs=$listbuild($listbuild(-1,0),$listbuild(0,-1),$listbuild(1,0),$listbuild(0,1)),totalDirs=$listlength(dirs)
	set Queue(steps,$listbuild(fromX,fromY))=path
	//zw Queue
	for  {
		set steps=$order(Queue("")) quit:'$length(steps)
		set value=$order(Queue(steps,"")),path=Queue(steps,value) kill Queue(steps,value)
		set fromX=$list(value,1),fromY=$list(value,2)
		if maxsteps,steps>maxsteps continue
		continue:$data(noVisitPlaces(fromX,fromY))
		set type=$extract($get(grid(fromY)),fromX)
		if type="#"||'$length(type) continue
		if $data(visited(fromX,fromY)),visited(fromX,fromY)<=steps {
			continue
		}
		set visited(fromX,fromY)=steps
		set visited(fromX,fromY,"path")=path
		if fromX=toX,fromY=toY {
			set:steps<minSteps minSteps=steps
			quit
		}
		for i=1:1:totalDirs {
			set dir=$list(dirs,i),dx=$list(dir,1),dy=$list(dir,2)
			set nextPos=$listbuild(fromX+dx,fromY+dy)
			set Queue(steps+1,nextPos)=path_$listbuild(nextPos)
		}
		//zw Queue
	}
	//w !,fromX,";",fromY,";",steps
	quit minSteps
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set maxY=70,lastRecord=$order(recordsArr(""),-1),minRead=1024
	if lastRecord<100 set maxY=6,minRead=12 //example
	if verbose do ..initGrid(.grid,.recordsArr,maxY,lastRecord)
	if verbose write !!,"Before:",! do ..GridDisplay(.grid)
	set maxRead=..getMinRead(.recordsArr,maxY,minRead,lastRecord,verbose)
	for i=maxRead-1:1:maxRead+1 {
		do ..initGrid(.grid,.recordsArr,maxY,maxRead)
		quit:..FindShortestPathPriorityQueue(.grid,1,0,maxY+1,maxY,,,.path,,)=999999
	}
	if verbose write !,i
	do ..setPathOnGrid(.grid,path)
	if verbose write !!,"After:",! do ..GridDisplay(.grid)

	set answer=recordsArr(i)
	quit answer
}

ClassMethod getMinRead(ByRef recordsArr, maxY As %Integer, minRead As %Integer, lastRecord As %Integer, verbose As %Boolean) [ Private ]
{
	set left=minRead,right=lastRecord,maxRead=""
	for  {
		quit:left>right
		set lastMaxRead=maxRead
		set maxRead=(left+right)\2
		quit:lastMaxRead=maxRead
		i verbose write !,maxRead,",",left,",",right
		do ..initGrid(.grid,.recordsArr,maxY,maxRead)
		set answer=..FindShortestPathPriorityQueue(.grid,1,0,maxY+1,maxY,,,.path,,)
		if answer=999999 {
			set right=maxRead
		} else {
			set left=maxRead
		}
	}
	quit maxRead
}

}

