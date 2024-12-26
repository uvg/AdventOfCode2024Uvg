Class AOC2024.Day14 Extends AOC2024.Base
{

Parameter InputFile = "d14.txt";

// d ##class(AOC2024.Day14).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set x=+$piece(record,"=",2),y=+$piece(record,",",2),dx=+$piece(record,"=",3),dy=+$piece(record,",",3)
		set robots($increment(robots))=$listbuild(x,y,dx,dy)
	}
	set robot="",mul=100
	set width=11,height=7 //for tests
	set:robots>100 width=101,height=103
	for  {
		set robot=$order(robots(robot)) quit:'$length(robot)
		set data=robots(robot) //$listbuild(x,y,dx,dy)
		set x=$list(data,1),y=$list(data,2),dx=$list(data,3),dy=$list(data,4)
		if verbose write !,robot,":",?5,"(",x,",",y,")",?15,"delta=(",dx,",",dy,")"
		set x=dx*mul+x#width,y=dy*mul+y#height
		if verbose write ?30,"@(",x,",",y,")"
		set arr(x,y)=$get(arr(x,y))+1
	}
	set midY=height\2,midX=width\2
	for i=1:1:4 set q(i)=0
	set x=""
	for  {
		set x=$order(arr(x)) quit:'$length(x)
		continue:x=midX
		set y=""
		for  {
			set y=$order(arr(x,y)) quit:'$length(y)
			continue:y=midY
			if x<midX,y<midY set q=1
			if x<midX,y'<midY set q=2
			if x'<midX,y<midY set q=3
			if x'<midX,y'<midY set q=4
			set q(q)=q(q)+arr(x,y)
		}
	}
	set answer=q(1)*q(2)*q(3)*q(4)
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set x=+$piece(record,"=",2),y=+$piece(record,",",2),dx=+$piece(record,"=",3),dy=+$piece(record,",",3)
		set robots($increment(robots))=$listbuild(x,y,dx,dy)
	}
	set robot=""
	set width=11,height=7 //for tests
	set:robots>100 width=101,height=103
	for mul=1:1:10000 {
		kill arr,grid
		set robot=""
		for  {
			set robot=$order(robots(robot)) quit:'$length(robot)
			set data=robots(robot) //$listbuild(x,y,dx,dy)
			set x=$list(data,1),y=$list(data,2),dx=$list(data,3),dy=$list(data,4)
			set x=dx*mul+x#width,y=dy*mul+y#height
			set arr(y,x)="#"
		}
		do ..makeGrid(.arr,.grid,width,height)
		quit:..IsChristmasTreePicture(.grid)
	}
	if verbose do ..GridDisplay(.grid)
	set answer=mul
	quit mul
}

ClassMethod IsChristmasTreePicture(ByRef grid) As %Boolean [ Private ]
{
	set y=""
	for  {
		set y=$order(grid(y)) quit:'$length(y)
		return:grid(y)["##########" 1
	}
	quit 0
}

ClassMethod makeGrid(ByRef fromArr, Output toGrid, width As %Integer, height As %Integer) [ Private ]
{
	set emptyStr=$translate($justify("",width+1)," ",".")
	for y=0:1:height {
		if '$data(fromArr(y)) {
			set toGrid(y)=emptyStr
			continue
		}
		set data=""
		for x=0:1:width {
			set ltr=$get(fromArr(y,x))
			set:'$length(ltr) ltr="."
			set data=data_ltr
		}
		set toGrid(y)=data
	}
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

}

