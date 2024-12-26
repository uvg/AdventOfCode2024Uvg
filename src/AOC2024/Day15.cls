Class AOC2024.Day15 Extends AOC2024.Base
{

Parameter InputFile = "d15.txt";

// d ##class(AOC2024.Day15).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer=""
	set info=..GetInfo(.recordsArr,.warehouseGrid,verbose)
	do ..MoveRobot(info,.warehouseGrid,verbose)
	set answer=..GetGPSCoordinatesSum(.warehouseGrid)
	quit answer
}

ClassMethod GetGPSCoordinatesSum(ByRef warehouseGrid) As %Integer [ Private ]
{
	set total=0,width=$length(warehouseGrid(1))
	set y=""
	for  {
		set y=$order(warehouseGrid(y)) quit:'$length(y)
		set data=warehouseGrid(y)
		for x=1:1:width {
			set ltr=$extract(data,x)
			if ltr'="O",ltr'="[" continue
			set total=(y-1)*100+x-1+total
		}
	}
	quit total
}

ClassMethod MoveRobot(info As %String, ByRef warehouseGrid, verbose As %Boolean) [ Private ]
{
	//info=$lb(robotInfo,width,height)
	//robotInfo=$lb(robotPosX,robotPosY,robotInstructions)
	set robotInfo=$list(info,1),width=$list(info,2),height=$list(info,3)
	set robotPosX=$list(robotInfo,1),robotPosY=$list(robotInfo,2),robotInstructions=$list(robotInfo,3)
	//zw width,height,robotPosX,robotPosY,robotInstructions,warehouseGrid
	if verbose write !!,"Initial state:"
	if verbose do ..GridDisplay(.warehouseGrid)
	for i=1:1:$length(robotInstructions) {
		set instruction=$extract(robotInstructions,i)
		//W !!,"Move #",i,?10,instruction,":"
		do ..MoveRobotSingleStep(.robotPosX,.robotPosY,instruction,.warehouseGrid)
		//do GridDisplay^YUVGZAOCUTIL(.warehouseGrid)
	}
	if verbose write !!,"Final state:"
	if verbose do ..GridDisplay(.warehouseGrid)
}

ClassMethod MoveRobotSingleStep(ByRef robotPosX, ByRef robotPosY, instruction As %String, ByRef warehouseGrid) [ Private ]
{
	set dir=$case(instruction,"<":$listbuild(-1,0),">":$listbuild(1,0),"^":$listbuild(0,-1),"v":$listbuild(0,1))
	set dx=$list(dir,1),dy=$list(dir,2)
	//w !!!! zw dir
	set newRobotX=robotPosX+dx,newRobotY=robotPosY+dy
	set ltr=$extract(warehouseGrid(newRobotY),newRobotX)
	if ltr="#" quit
	if "O[]"[ltr,'..MoveBoxes(newRobotX,newRobotY,dx,dy,.warehouseGrid) quit
	set $extract(warehouseGrid(newRobotY),newRobotX)="@"
	set $extract(warehouseGrid(robotPosY),robotPosX)="."
	set robotPosX=newRobotX,robotPosY=newRobotY
	do ..ValidateBoxes(.warehouseGrid)
}

ClassMethod ValidateBoxes(ByRef warehouseGrid) [ Private ]
{
	set y="",width=$length(warehouseGrid(1)),isOk=1
	for  {
		set y=$order(warehouseGrid(y)) quit:'$length(y)
		set data=warehouseGrid(y)
		for i=1:1:width {
			if $extract(warehouseGrid(y),i)="[",$extract(warehouseGrid(y),i+1)'="]" s isOk=0 q
			if $extract(warehouseGrid(y),i)="]",$extract(warehouseGrid(y),i-1)'="[" s isOk=0 q
		}
}
	quit:isOk
	do ..GridDisplay(.warehouseGrid)
	K A S A=A //INTENDED BUG
}

ClassMethod MoveBoxes(boxPosX As %Integer, boxPosY As %Integer, dx As %Integer, dy As %Integer, ByRef warehouseGrid) As %Boolean [ Private ]
{
	set fromLtr=$extract(warehouseGrid(boxPosY),boxPosX)
	if "[]"[fromLtr,dy quit ..MoveBoxesUpDown(boxPosX,boxPosY,dy,.warehouseGrid)  //part 2 up/down
	set newBoxPosX=boxPosX+dx,newBoxPosY=boxPosY+dy
	set toLtr=$extract(warehouseGrid(newBoxPosY),newBoxPosX)
	if toLtr="#" quit 0
	if toLtr="." {
		set $extract(warehouseGrid(newBoxPosY),newBoxPosX)=fromLtr
		set $extract(warehouseGrid(boxPosY),boxPosX)="."
		quit 1
	}
	quit:'..MoveBoxes(newBoxPosX,newBoxPosY,dx,dy,.warehouseGrid) 0
	set $extract(warehouseGrid(newBoxPosY),newBoxPosX)=fromLtr
	set $extract(warehouseGrid(boxPosY),boxPosX)="."
	quit 1
}

ClassMethod MoveBoxesUpDown(boxPosX As %Integer, boxPosY As %Integer, dy As %Integer, ByRef warehouseGrid) [ Private ]
{
	set newBoxPosX=boxPosX,newBoxPosY=boxPosY+dy
	set fromLtr1=$extract(warehouseGrid(boxPosY),boxPosX),toLtr1=$extract(warehouseGrid(newBoxPosY),newBoxPosX)
	if fromLtr1="[" {
		set fromLtr2="]",toLtr2=$extract(warehouseGrid(newBoxPosY),newBoxPosX+1)
	} else {
		set fromLtr1="[",fromLtr2="]",toLtr2=toLtr1,toLtr1=$extract(warehouseGrid(newBoxPosY),newBoxPosX-1)
		set boxPosX=boxPosX-1,newBoxPosX=newBoxPosX-1
	}
	if (toLtr1_toLtr2)["#" quit 0
	if (toLtr1_toLtr2)=".." {
		set $extract(warehouseGrid(newBoxPosY),newBoxPosX)="["
		set $extract(warehouseGrid(newBoxPosY),newBoxPosX+1)="]"
		set $extract(warehouseGrid(boxPosY),boxPosX)="."
		set $extract(warehouseGrid(boxPosY),boxPosX+1)="."
		quit 1
	}
	merge tempWarehouseGrid=warehouseGrid
	if toLtr1="]",'..MoveBoxesUpDown(newBoxPosX-1,newBoxPosY,dy,.warehouseGrid) {
		merge warehouseGrid=tempWarehouseGrid
		quit 0
	}
	if toLtr1="[",'..MoveBoxesUpDown(newBoxPosX,newBoxPosY,dy,.warehouseGrid) {
		merge warehouseGrid=tempWarehouseGrid
		quit 0
	}
	if toLtr2="[",'..MoveBoxesUpDown(newBoxPosX+1,newBoxPosY,dy,.warehouseGrid) {
		merge warehouseGrid=tempWarehouseGrid
		quit 0
	}
	set $extract(warehouseGrid(newBoxPosY),newBoxPosX)="["
	set $extract(warehouseGrid(newBoxPosY),newBoxPosX+1)="]"
	set $extract(warehouseGrid(boxPosY),boxPosX)="."
	set $extract(warehouseGrid(boxPosY),boxPosX+1)="."
	quit 1
}

ClassMethod GetInfo(ByRef recordsArr, Output warehouseGrid, part As %Integer = 1, verbose As %Boolean) [ Private ]
{
	//return:
	//        $lb(robotInfo,width,height)
	//where robotInfo=$lb(robotPosX,robotPosY,robotInstructions)
	set type=0,(robotInstructions,robotPosX,robotPosY,width,height)=""
	set line=""
	for  {
		set line=$order(recordsArr(line)) quit:'$length(line)
		set data=recordsArr(line)
		if type=0,'$length(data) set height=line-1,type=1 continue
		if type=0 {
			set warehouseGrid(line)=data
			if data["@" set robotPosY=line
			continue
		}
		if type=1 set robotInstructions=robotInstructions_data
	}
	if part=2 {
		if verbose write !,"Before resize:"
		if verbose do ..GridDisplay(.warehouseGrid)
		do ..ResizeWarehouse(.warehouseGrid)
		if verbose write !!,"After resize:"
		if verbose do ..GridDisplay(.warehouseGrid)
	}
	set width=$length(warehouseGrid(1)),robotPosX=$find(warehouseGrid(robotPosY),"@")-1
	set robotInfo=$listbuild(robotPosX,robotPosY,robotInstructions)
	quit $listbuild(robotInfo,width,height)
}

ClassMethod ResizeWarehouse(ByRef warehouseGrid) [ Private ]
{
	set y="",width=$length(warehouseGrid(1))
	for  {
		set y=$order(warehouseGrid(y)) quit:'$length(y)
		set data=warehouseGrid(y),newData=""
		for x=1:1:width {
			set ltr=$extract(data,x)
			set newLtr=$case(ltr,"#":"##",".":"..","O":"[]","@":"@.")
			set newData=newData_newLtr
		}
		set warehouseGrid(y)=newData
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

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer=""
	set info=..GetInfo(.recordsArr,.warehouseGrid,2,verbose)
	do ..MoveRobot(info,.warehouseGrid,verbose)
	set answer=..GetGPSCoordinatesSum(.warehouseGrid)
	quit answer
}

}

