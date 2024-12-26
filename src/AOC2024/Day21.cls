Class AOC2024.Day21 Extends AOC2024.Base
{

Parameter InputFile = "d21.txt";

// d ##class(AOC2024.Day21).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	do ..initKeypads(.gridNumeric,.gridDirectional,.posNumeric,.posDirectional)
	do ..pressMemory(.gridNumeric,.gridDirectional,.posNumeric,.posDirectional,.pressMem)
	//zw pressMem
	set answer="",total=0,line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set minPress=..getMinPressByMem(2,record,.pressMem)
		set total=record*minPress+total
		if verbose write !,record,"=",minPress
	}
	set answer=total
	quit answer
}

ClassMethod pressMemory(ByRef gridNumeric, ByRef gridDirectional, ByRef posNumeric, ByRef posDirectional, Output pressMem) [ Private ]
{
	for from="A",0:1:9 {
		for to="A",0:1:9 {
			continue:from=to
			set code=from_to
			do ..getMinPressPath(.gridNumeric,.posNumeric,code,.pressMem)
		}
	}
	for from="A","<",">","^","v" {
		for to="A","<",">","^","v" {
			continue:from=to
			set code=from_to
			do ..getMinPressPath(.gridDirectional,.posDirectional,code,.pressMem)
		}
	}
	do ..convertMemPathToPress(.pressMem)
}

ClassMethod convertMemPathToPress(ByRef pressMem) [ Private ]
{
	set from=""
	for  {
		set from=$order(pressMem(from)) quit:'$length(from)
		set to=""
		for  {
			set to=$order(pressMem(from,to)) quit:'$length(to)
			set best=$order(pressMem(from,to,""))
			set path=""
			for  {
				set path=$order(pressMem(from,to,best,path)) quit:'$length(path)
				set pressMem(from,to,best,path)=..convertPathToPress(path)
			}
		}
	}
}

ClassMethod getMinPressPath(ByRef grid, ByRef pos, code As %String, ByRef memArr) [ Private ]
{
	set len=$length(code),from=$extract(code),path=""
	for i=2:1:len {
		set to=$extract(code,i)
		//zw from,to
		continue:$data(memArr(from,to))
		/*if $length($get(memArr(from,to))) {
			set path=path_memArr(from,to)
		} else {*/
			set posFrom=pos(from),posTo=pos(to)
			set fromX=$list(posFrom,1),fromY=$list(posFrom,2),toX=$list(posTo,1),toY=$list(posTo,2)
			set tempPath="" kill bestPaths
			do FindShortestPathPriorityQueue(.grid,fromX,fromY,toX,toY,,,.tempPath,,,,,,,,.bestPaths)
			//zw from,to,bestPaths
			merge memArr(from,to)=bestPaths
			/*
			set tempPath=tempPath_$listbuild("A")
			//set memArr(from,to)=tempPath
			set path=path_tempPath
		}*/
		set from=to
	}
	quit ..convertPathToPress(path)
}

ClassMethod convertPathToPress(path As %String) As %String [ Private ]
{
	set len=$listlength(path),press=""
	for i=1:1:len {
		set info=$list(path,i)
		set ltr=$select(info="A":"A",1:$case($list(info,3),$listbuild(-1,0):"<",$listbuild(1,0):">",$listbuild(0,-1):"^",$listbuild(0,1):"v"))
		set press=press_ltr
	}
	quit press
}

ClassMethod FindShortestPathPriorityQueue(ByRef grid, fromX As %Integer, fromY As %Integer, toX As %Integer, toY As %Integer, steps As %Integer = 0, ByRef visited, path As %String = "", maxsteps As %Integer = 0, ByRef noVisitPlaces, value As %Integer = 0, maxValue As %Integer = 0, dir As %String = "", valueOnStep As %Integer = 1, valueOnDirChange As %Integer = 0, ByRef bestPaths) [ Private ]
{
	//FindShortestPathPriorityQueue(.grid,2,1,8,4) from 2,1 to 8,4 with initial steps of 0 and no maxsteps boundry
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
		if $data(visited(fromX,fromY)),visited(fromX,fromY)<value {
			continue
		}
		set visited(fromX,fromY)=value
		//set visited(fromX,fromY,"path")=path
		
		if fromX=toX,fromY=toY {
			if value<=minValue {
				set minValue=value
				set bestPaths(minValue,path)=""
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
			set dataOnPath=$listbuild(fromX+nextDirDx,fromY+nextDirDy,nextDir) //,steps+1,nextDir,nextValue)
			set cnt=cnt+1,Queue(nextValue,cnt)=$listbuild(fromX+nextDirDx,fromY+nextDirDy,steps+1,nextDir,path_$listbuild(dataOnPath))
		}
	}
	//zw bestPaths
	//w !,fromX,";",fromY,";",steps
	quit minValue
}

ClassMethod initKeypads(Output gridNumeric, Output gridDirectional, Output posNumeric, Output posDirectional) [ Private ]
{
	set gridNumeric(1)="789"
	set gridNumeric(2)="456"
	set gridNumeric(3)="123"
	set gridNumeric(4)="#0A"
	set gridDirectional(1)="#^A"
	set gridDirectional(2)="<v>"
	set y=""
	for  {
		set y=$order(gridNumeric(y)) quit:'$length(y)
		set data=gridNumeric(y)
		for x=1:1:$length(data) {
			set ltr=$extract(data,x)
			set posNumeric(ltr)=$listbuild(x,y)
		}
		set gridNumeric(y)=$select(y'=4:"...",1:"#..")
	}
	set y=""
	for  {
		set y=$order(gridDirectional(y)) quit:'$length(y)
		set data=gridDirectional(y)
		for x=1:1:$length(data) {
			set ltr=$extract(data,x)
			set posDirectional(ltr)=$listbuild(x,y)
		}
		set gridDirectional(y)=$select(y'=1:"...",1:"#..")
	}
}

ClassMethod getMinPressByMem(depth As %Integer, code As %String, ByRef pressMem, ByRef mem) [ Private ]
{
	set total=0
	set code="A"_code
	//w !,depth,"=",code
	set len=$length(code)
	for i=1:1:len-1 {
		set from=$extract(code,i),to=$extract(code,i+1)
		if from=to {
			set total=total+1 //press on the same button so pressing "A" again and again and again
			continue
		}
		//w !,from,to
		set best=$order(pressMem(from,to,""))
		if depth=0 {
			set total=total+best+1 //another one for "A"
		} else {
			if $data(mem(depth,from,to)) {
				set min=mem(depth,from,to)
			} else {
				set path="",min=99999999999999999
				for  {
					set path=$order(pressMem(from,to,best,path)) quit:'$length(path)
					set press=pressMem(from,to,best,path)
					set pathLen=..getMinPressByMem(depth-1,press_"A",.pressMem,.mem)
					if pathLen<min set min=pathLen
				}
			}
			set mem(depth,from,to)=min
			set total=total+min
		}
	}
	quit total
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	do ..initKeypads(.gridNumeric,.gridDirectional,.posNumeric,.posDirectional)
	do ..pressMemory(.gridNumeric,.gridDirectional,.posNumeric,.posDirectional,.pressMem)
	//zw pressMem
	set answer="",total=0,line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set minPress=..getMinPressByMem(25,record,.pressMem)
		set total=record*minPress+total
		if verbose write !,record,"=",minPress
	}
	set answer=total
	quit answer
}

}

