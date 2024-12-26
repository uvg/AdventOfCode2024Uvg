Class AOC2024.Day08 Extends AOC2024.Base
{

Parameter InputFile = "d08.txt";

// d ##class(AOC2024.Day08).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",width=$length(recordsArr(1)),height=$order(recordsArr(""),-1)
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		for x=1:1:width {
			set ltr=$extract(record,x)
			continue:ltr="."
			set arr(ltr)=$get(arr(ltr))_$listbuild($listbuild(x,line))
		}
	}
	set ltr="",counter=0
	for  {
		set ltr=$order(arr(ltr)) quit:'$length(ltr)
		set data=arr(ltr),len=$listlength(data)
		for i=1:1:(len-1) {
			set from=$list(data,i),fromX=$list(from,1),fromY=$list(from,2)
			for j=i+1:1:len {
				set to=$list(data,j),toX=$list(to,1),toY=$list(to,2)
				set dx=fromX-toX,dy=fromY-toY
				if verbose write !,"(",fromX,",",fromY,")",?10,"-> (",toX,",",toY,")",?25,":"
				set newX=fromX+dx,newY=fromY+dy
				if newX>=1,newX<=width,newY>=1,newY<=height,'$data(newArr(newX,newY)) {
					set counter=counter+1
					set newArr(newX,newY)=""
				}
				if verbose write "(",newX,",",newY,");"
				set newX=toX-dx,newY=toY-dy
				if newX>=1,newX<=width,newY>=1,newY<=height,'$data(newArr(newX,newY)) {
					set counter=counter+1
					set newArr(newX,newY)=""
				}
				if verbose write "(",newX,",",newY,")"
			}
		}
	}
	set answer=counter
	if verbose write ! zwrite newArr
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",width=$length(recordsArr(1)),height=$order(recordsArr(""),-1)
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		for x=1:1:width {
			set ltr=$extract(record,x)
			continue:ltr="."
			set arr(ltr)=$get(arr(ltr))_$listbuild($listbuild(x,line))
		}
	}
	set ltr="",counter=0
	for  {
		set ltr=$order(arr(ltr)) quit:'$length(ltr)
		set data=arr(ltr),len=$listlength(data)
		for i=1:1:(len-1) {
			set from=$list(data,i),fromX=$list(from,1),fromY=$list(from,2)
			for j=i+1:1:len {
				set to=$list(data,j),toX=$list(to,1),toY=$list(to,2)
				set dx=fromX-toX,dy=fromY-toY
				if verbose write !,"(",fromX,",",fromY,")",?10,"-> (",toX,",",toY,")",?25,": "
				if '$data(newArr(fromX,fromY)) {
					set counter=counter+1
					set newArr(fromX,fromY)=""
					if verbose write "(",fromX,",",fromY,");"
				}
				if '$data(newArr(toX,toY)) {
					set counter=counter+1
					set newArr(toX,toY)=""
					if verbose write "(",toX,",",toY,");"
				}
				for sign=-1,1 {
					for mul=1:1:width {
						set newX=fromX+(dx*mul*sign),newY=fromY+(dy*mul*sign)
						quit:newX<1  quit:newY<1
						quit:newX>width  quit:newY>height
						if '$data(newArr(newX,newY)) {
							set counter=counter+1
							set newArr(newX,newY)=""
							if verbose write "(",newX,",",newY,");"
						}
					}
				}
			}
		}
	}
	set answer=counter
	if verbose write ! zwrite newArr
	quit answer
}

}

