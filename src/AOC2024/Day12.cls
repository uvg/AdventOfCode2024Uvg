Class AOC2024.Day12 Extends AOC2024.Base
{

Parameter InputFile = "d12.txt";

// d ##class(AOC2024.Day12).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",y="",total=0
	for {
		set y=$order(recordsArr(y)) quit:y=""
		set record=recordsArr(y)
		for x=1:1:$length(record) {
			continue:$data(visited(x,y))
			set ltr=$extract(record,x)
			kill region
			do ..GetRegion(.recordsArr,x,y,.visited,.region,ltr)
			set perimeter=..GetPerimeter(.recordsArr,.region,ltr),area=..GetArea(.region)
			set price=perimeter*area
			if verbose write !,ltr,"@(",x,",",y,"): ",area,"*",perimeter,"=",price
			set total=total+price
		}
	}
	set answer=total
	quit answer
}

ClassMethod GetRegion(ByRef grid, fromX As %Integer, fromY As %Integer, ByRef visited, Output regionGrid, ltr As %String) [ Private ]
{
	quit:$data(visited(fromX,fromY))
	quit:$extract($get(grid(fromY)),fromX)'=ltr
	set visited(fromX,fromY)="",regionGrid(fromX,fromY)=""
	do ..GetRegion(.grid,fromX+1,fromY,.visited,.regionGrid,ltr)
	do ..GetRegion(.grid,fromX-1,fromY,.visited,.regionGrid,ltr)
	do ..GetRegion(.grid,fromX,fromY+1,.visited,.regionGrid,ltr)
	do ..GetRegion(.grid,fromX,fromY-1,.visited,.regionGrid,ltr)
	quit
}

ClassMethod GetPerimeter(ByRef grid, ByRef regionGrid, ltr As %String) As %Integer [ Private ]
{
	set x="",count=0,dirs=$listbuild($listbuild(-1,0),$listbuild(1,0),$listbuild(0,-1),$listbuild(0,1))
	set totalDirs=$listlength(dirs)
	for  {
		set x=$order(regionGrid(x)) quit:'$length(x)
		set y=""
		for  {
			set y=$order(regionGrid(x,y)) quit:'$length(y)
			for i=1:1:totalDirs {
				set dir=$list(dirs,i)
				set val=$extract($get(grid(y+$list(dir,1))),x+$list(dir,2))
				set:val'=ltr count=count+1
			}
		}
	}
	quit count
}

ClassMethod GetArea(ByRef regionGrid) As %Integer [ Private ]
{
	set x="",count=0
	for  {
		set x=$order(regionGrid(x)) quit:'$length(x)
		set y=""
		for  {
			set y=$order(regionGrid(x,y)) quit:'$length(y)
			set count=count+1
		}
	}
	quit count
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",y="",total=0
	for {
		set y=$order(recordsArr(y)) quit:y=""
		set record=recordsArr(y)
		for x=1:1:$length(record) {
			continue:$data(visited(x,y))
			set ltr=$extract(record,x)
			kill region
			do ..GetRegion(.recordsArr,x,y,.visited,.region,ltr)
			set sides=..GetSides(.recordsArr,.region,ltr),area=..GetArea(.region)
			set price=sides*area
			if verbose write !,ltr,"@(",x,",",y,"): ",area,"*",sides,"=",price
			set total=total+price
		}
	}
	set answer=total
	quit answer
}

ClassMethod GetSides(ByRef grid, ByRef regionGrid, ltr As %String) As %Integer [ Private ]
{
	set dirs=$listbuild($listbuild(-1,0),$listbuild(1,0),$listbuild(0,-1),$listbuild(0,1))
	set diffs=$listbuild($listbuild(-.4,0),$listbuild(.4,0),$listbuild(0,-.4),$listbuild(0,.4))
	set totalDirs=$listlength(dirs)
	set x=""
	for  {
		set x=$order(regionGrid(x)) quit:'$length(x)
		set y=""
		for  {
			set y=$order(regionGrid(x,y)) quit:'$length(y)
			for i=1:1:totalDirs {
				set dir=$list(dirs,i),diff=$list(diffs,i)
				set val=$extract($get(grid(y+$list(dir,1))),x+$list(dir,2))
				set:val'=ltr fenceGrid(y+$list(diff,1),x+$list(diff,2))=""
			}
		}
	}
	//write !!! zwrite fenceGrid
	set y="",total=0
	for  {
		set y=$order(fenceGrid(y)) quit:'$length(y)
		set x=""
		for  {
			set x=$order(fenceGrid(y,x)) quit:'$length(x)
			continue:fenceGrid(y,x)
			set total=total+1
			set fenceGrid(y,x)=total
			if y\1'=y {
				for tx=x:1 {
					quit:'$data(fenceGrid(y,tx))
					set fenceGrid(y,tx)=total
				}
			} else {
				for ty=y:1 {
					quit:'$data(fenceGrid(ty,x))
					set fenceGrid(ty,x)=total
				}
			}
		}
	}
	//w !! zw fenceGrid
	quit total
}

}

