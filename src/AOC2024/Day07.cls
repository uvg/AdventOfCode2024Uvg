Class AOC2024.Day07 Extends AOC2024.Base
{

Parameter InputFile = "d07.txt";

// d ##class(AOC2024.Day07).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0 //,maxlen=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set result=+$piece(record,": ",1),numbers=$piece(record,": ",2)
		set data="",len=$length(numbers," ")
		for i=1:1:len {
			set number=+$piece(numbers," ",i)
			set data=data_$listbuild(number)
		}
		if ..IsOk(result,data,verbose) {
			set total=total+result
			//if verbose zwrite record
		}
	}
	set answer=total
	quit answer
}

ClassMethod IsOk(result As %Integer, numbers As %String, verbose As %Boolean) As %Boolean [ Private, PublicList = answer ]
{
	new answer
	set totalNumbers=$listlength(numbers)
	set numOfOptions=2**(totalNumbers-1)-1
	for i=0:1:numOfOptions {
		set options=..DecToBin(i)
		for j=1:1 quit:$length(options)>=(totalNumbers-1)  set options=0_options
		set options=$extract(options,*-totalNumbers+2,*)
		set options=$translate(options,"01","+*")
		set equation=""
		for j=1:1:totalNumbers {
			set equation=equation_$list(numbers,j)_$extract(options,j)
		}
		xecute "set answer="_equation
		if answer=result {
			if verbose write !,result,"=",equation
			return 1
		}
	}
	quit 0
}

ClassMethod DecToBin(Val As %Integer) As %String [ Private ]
{
	quit:'Val "0000"
	quit ..HexToBin(..DecToHex(Val))
}

ClassMethod DecToHex(Val As %Integer) As %String [ Private ]
{
	quit:'Val 0
	quit $zhex(+Val)
}

ClassMethod HexToBin(Val As %String) As %String [ Private ]
{
	quit:'$length(Val) "0000"
	set ans=""
	for i=1:1:$length(Val) {
		set part=$extract(Val,i)
		set char=$case(part,0:"0000",1:"0001",2:"0010",3:"0011",4:"0100",5:"0101",6:"0110",7:"0111",8:1000,9:1001,"A":1010,"B":1011,"C":1100,"D":1101,"E":1110,"F":1111)
		set ans=ans_char
	}
	quit ans
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0 //,maxlen=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set result=+$piece(record,": ",1),numbers=$piece(record,": ",2)
		set data="",len=$length(numbers," ")
		for i=1:1:len {
			set number=+$piece(numbers," ",i)
			set data=data_$listbuild(number)
		}
		if ..IsOk2(result,data,verbose) {
			set total=total+result
		}
	}
	set answer=total
	quit answer
}

ClassMethod IsOk2(result As %Integer, numbers As %String, verbose As %Boolean) As %Boolean [ Private, PublicList = answer ]
{
	new answer
	set totalNumbers=$listlength(numbers)
	set numOfOptions=3**(totalNumbers-1)-1
	for i=0:1:numOfOptions {
		set options=..DecToBase(i,3)
		for j=1:1 quit:$length(options)>=(totalNumbers-1)  set options=0_options
		set options=$extract(options,*-totalNumbers+2,*)
		set options=$translate(options,"012","+*_")
		set equation=""
		for j=1:1:totalNumbers {
			set equation=equation_$list(numbers,j)_$extract(options,j)
		}
		xecute "set answer=("_equation_")"
		if answer=result {
			if verbose write !,result,"=",$replace(equation,"_","||")
			return 1
		}
	}
	quit 0
}

ClassMethod DecToBase(Val As %Integer, Base As %Integer) As %Integer [ Private ]
{
	quit:'Val 0
	quit:Base<2 0
	set answer=""
	for  quit:'Val  set digit=Val#Base,answer=digit_answer,Val=Val\Base
	quit answer
}

}

