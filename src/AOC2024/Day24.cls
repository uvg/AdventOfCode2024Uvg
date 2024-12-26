Class AOC2024.Day24 Extends AOC2024.Base
{

Parameter InputFile = "d24.txt";

// d ##class(AOC2024.Day24).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",state=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if '$length(record) set state=1 continue
		if state=0 {
			set input=$piece(record,": ",1),output=$piece(record,": ",2)
			set arrWires(input)=$lb("","","",output)
		} else {
			set in1=$piece(record," ",1),type=$piece(record," ",2),in2=$piece(record," ",3),out=$piece(record," ",5)
			set arrWires(out)=$listbuild(in1,in2,type,"")
		}
	}
	set wire=""
	for  {
		set findAll=1
		for  {
			set wire=$order(arrWires(wire)) quit:'$length(wire)
			set data=arrWires(wire) continue:$length($list(data,4))
			set findAll=0
			set in1=$list(data,1),in2=$list(data,2),type=$list(data,3)
			set value1=$list(arrWires(in1),4),value2=$list(arrWires(in2),4)
			if '$length(value1)||'$length(value2) continue
			set value=$select(type="AND":value1&&value2,type="OR":value1||value2,1:value1'=value2)
			set $list(data,4)=value,arrWires(wire)=data
		}
		quit:findAll
	}
	set wire="z",bits=""
	for  {
		set wire=$order(arrWires(wire)) quit:'$length(wire)
		set bits=$list(arrWires(wire),4)_bits
	}
	if verbose zwrite bits
	set answer=..BinToDec(bits)
	quit answer
}

ClassMethod BinToDec(Val As %Integer) As %Integer [ Private ]
{
	quit:'Val 0
	set Mul=1,Ans=0
	for i=1:1:$length(Val) {
		set:$extract(Val,*-i+1) Ans=Ans+Mul
		set Mul=Mul*2
	}
	quit Ans
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",state=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if '$length(record) set state=1 continue
		if state=0 {
			set input=$piece(record,": ",1),output=$piece(record,": ",2)
			set arrWires(input)=$listbuild("","","","")
		} else {
			set in1=$piece(record," ",1),type=$piece(record," ",2),in2=$piece(record," ",3),out=$piece(record," ",5)
			set arrWires(out)=$listbuild(in1,in2,type,"")
		}
	}
	merge origArrWires=arrWires
	do ..createCorrectConnections(.arrWires,.changes)
	if verbose zwrite changes
	set badWires="",wire=""
	for  {
		set wire=$order(changes(wire)) quit:'$length(wire)
		set badWires=badWires_","_wire
	}
	set $extract(badWires)=""
	//zw badWires
	set answer=badWires
	quit answer
}

ClassMethod createCorrectConnections(ByRef arrWires, Output changes) [ Private ]
{
	set newWires($increment(newWires))=$listbuild("x00","y00","XOR","") //lsb
	set prevC=$increment(newWires),newWires(prevC)=$listbuild("x00","y00","AND","") //lsc
	set lastBit=$extract($order(arrWires(""),-1),2,3)
	for i=1:1:lastBit-1 {
		set prev=i-1 set:prev<10 prev=0_prev
		set curr=i set:curr<10 curr=0_curr
		set andC=$increment(newWires),newWires(andC)=$listbuild("x"_curr,"y"_curr,"AND","")
		set xorC=$increment(newWires),newWires(xorC)=$listbuild("x"_curr,"y"_curr,"XOR","")
		set p1=$increment(newWires),newWires(p1)=$listbuild(xorC,prevC,"AND","")
		set newWires($increment(newWires))=$listbuild(xorC,prevC,"XOR","")
		set prevC=$increment(newWires),newWires(prevC)=$listbuild(andC,p1,"OR","")
	}
	
	//change all x&y, x^y from wire count to wire name
	set i=""
	for  {
		set i=$order(newWires(i)) quit:'$length(i)
		set data1=newWires(i),data2=$listbuild($list(data1,2),$list(data1,1),$list(data1,3),"")
		continue:$e($li(data1,1))'="x"
		set wire=""
		for  {
			set wire=$order(arrWires(wire)) quit:'$length(wire)
			set data=arrWires(wire)
			if data'=data1,data'=data2 continue
			set goodNewWires(wire)=arrWires(wire) kill newWires(i)
			set tempWire=""
			for  {
				set tempWire=$order(newWires(tempWire)) quit:'$length(tempWire)
				set data=newWires(tempWire)
				if $list(data,1)=i set $list(data,1)=wire
				if $list(data,2)=i set $list(data,2)=wire
				set newWires(tempWire)=data
			}
		}
	}
	for  {
		set swSomeChange=0
		//zw newWires,goodNewWires
		for  {
			//w !!!!!,$i(temppppp)
			set swChange=0,i=""
			for  {
				set i=$order(newWires(i)) quit:'$length(i)
				set data1=newWires(i),data2=$listbuild($list(data1,2),$list(data1,1),$list(data1,3),"")
				set wire=""
				for  {
					set wire=$order(arrWires(wire)) quit:'$length(wire)
					set data=arrWires(wire)
					if data'=data1,data'=data2 continue
					set goodNewWires(wire)=arrWires(wire) kill newWires(i)
					set tempWire="",swChange=1,swSomeChange=1
					for  {
						set tempWire=$order(newWires(tempWire)) quit:'$length(tempWire)
						set data=newWires(tempWire)
						if $list(data,1)=i set $list(data,1)=wire
						if $list(data,2)=i set $list(data,2)=wire
						set newWires(tempWire)=data
					}
					quit
				}
			}
			quit:'swChange
		}
		//look for exchange
		for  {
			set i="",swChange=0
			for  {
				set i=$order(newWires(i)) quit:'$length(i)
				continue:$data(changed(i))
				set data=newWires(i),wire1=$list(data,1),wire2=$list(data,2)
				continue:wire1||wire2  //errors are the ones we find both connections but couldn't find on puzzle input
				set type=$list(data,3)
				//continue:type="OR"  //only xor, and
				set wire="",from="",to=""
				for  {
					set wire=$order(arrWires(wire)) quit:'$length(wire)	
					set wireData=arrWires(wire)
					if $list(wireData,3)=type,$list(wireData,1)=wire1 set from=wire2,to=$list(wireData,2)
					if $list(wireData,3)=type,$list(wireData,2)=wire1 set from=wire2,to=$list(wireData,1)
					if $list(wireData,3)=type,$list(wireData,1)=wire2 set from=wire1,to=$list(wireData,2)
					if $list(wireData,3)=type,$list(wireData,2)=wire2 set from=wire1,to=$list(wireData,1)
					quit:$length(from)
				}
				continue:'$length(from)
				set changes(from)="",changes(to)=""
				set j="",swChange=0
				for  {
					set j=$order(newWires(j)) quit:'$length(j)
					set data=newWires(j),beforeData=data
					if $list(data,1)'=from,$list(data,2)'=from,$list(data,1)'=to,$list(data,2)'=to continue
					if $list(data,1)=from {
						set $list(data,1)=to
					} elseif $list(data,1)=to {
						set $list(data,1)=from
					} elseif $list(data,2)=from {
						set $list(data,2)=to
					} elseif $list(data,2)=to {
						set $list(data,2)=from
					}
					set newWires(j)=data,swChange=1,changed(j)="",swSomeChange=1
				}
				quit:swChange
			}
			quit:'swChange
		}
		quit:'swSomeChange
	}
	//zwrite changes,newWires,goodNewWires
}

}

