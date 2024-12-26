Class AOC2024.Day17 Extends AOC2024.Base
{

Parameter InputFile = "d17.txt";

// d ##class(AOC2024.Day17).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set regA=+$piece(recordsArr(1),": ",2),regB=+$piece(recordsArr(2),": ",2),regC=+$piece(recordsArr(3),": ",2),instructions=$piece(recordsArr(5),": ",2),ip=0
	if verbose zwrite regA,regB,regC,instructions
	set answer="",output=""
	for  {
		set opcode=$piece(instructions,",",ip+1),operand=$piece(instructions,",",ip+2)
		quit:'$length(opcode)  quit:'$length(operand)
		if verbose write !,ip,"=",opcode,":",operand
		if opcode=0 do ..div(regA,regB,regC,operand,.regA)
		if opcode=1 do ..xor(.regB,operand)
		if opcode=2 do ..mod8(regA,regB,regC,operand,.regB)
		if opcode=3,regA set ip=operand continue
		if opcode=4 do ..xor(.regB,regC)
		if opcode=5 set output=output_..out(regA,regB,regC,operand)
		if opcode=6 do ..div(regA,regB,regC,operand,.regB)
		if opcode=7 do ..div(regA,regB,regC,operand,.regC)
		if verbose write ">>>","regA=",regA,", regB=",regB,", regC=",regC
		set ip=ip+2
	}
	set answer=..getOutput(output)
	quit answer
}

ClassMethod getOutput(string As %String) As %String [ Private ]
{
	set answer="",len=$length(string)
	for i=1:1:len set answer=answer_$extract(string,i)_","
	set $extract(answer,*)=""
	quit answer
}

ClassMethod combo(regA As %Integer, regB As %Integer, regC As %Integer, operand As %Integer) As %Integer [ Private ]
{
	quit $select(operand<4:operand,operand=4:regA,operand=5:regB,operand=6:regC)
}

ClassMethod div(regA As %Integer, regB As %Integer, regC As %Integer, operand As %Integer, Output regOut) As %Integer [ Private ]
{
	set value=..combo(regA,regB,regC,operand)
	set denominator=2**value
	set regOut=regA\denominator
}

ClassMethod xor(ByRef num1, num2 As %Integer) [ Private ]
{
	set num1=..XORDec(num1,num2)
}

ClassMethod out(regA As %Integer, regB As %Integer, regC As %Integer, operand As %Integer) As %Integer [ Private ]
{
	do ..mod8(regA,regB,regC,operand,.value)
	quit value
}

ClassMethod mod8(regA As %Integer, regB As %Integer, regC As %Integer, operand As %Integer, Output out) [ Private ]
{
	set value=..combo(regA,regB,regC,operand)
	set out=value#8
}

ClassMethod XORDec(Val1 As %Integer, Val2 As %Integer) As %Integer [ Private ]
{
	set fval1=$factor(Val1),fval2=$factor(Val2)
	quit ..FactorToDec($bitlogic(fval1^fval2))
}

ClassMethod FactorToDec(Factor As %String) As %Integer [ Private ]
{
	set ans=0,mul=1
	for i=1:1:$bitcount(Factor) {
		set:$bit(Factor,i) ans=ans+mul
		set mul=mul*2
	}
	quit ans
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set regA=+$piece(recordsArr(1),": ",2),regB=+$piece(recordsArr(2),": ",2),regC=+$piece(recordsArr(3),": ",2),instructions=$piece(recordsArr(5),": ",2),ip=0
	if verbose zwrite regA,regB,regC,instructions
	set answer=$list(..getRegA(0,regB,regC,instructions,$length(instructions,","),verbose),1)
	quit answer
}

ClassMethod getRegA(origRegA As %Integer, origRegB As %Integer, origRegC As %Integer, instructions As %String, pos As %Integer, verbose As %Boolean) As %String [ Private ]
{
	/*
	set fromA=$length(instructions,",")-1,fromA=8**fromA
	set toA=fromA*8
	for tmpRegA=fromA:1:toA {  //CRAZY - going up to 8**16 (which is much too much too much much too too too much)
	//changed to multiple of 8 much better but for some edge case still took too much (work for everything except for this tiny tiny little one, nahhhhh)
	//checking again - I assume the first one i find is ok, but noooo, so changing to check in recursive all the correct digits(0-7) and not stoping on the first one
	//changed to recursive to check all the possible answer so now it don't get stuck in a crazy loop on the last digit
	//now it's working
	*/
	quit:pos<1 $listbuild(origRegA,instructions)
	set tmpRegA=origRegA
	for i=0:1:7 {
		set regA=tmpRegA+i,regB=origRegB,regC=origRegC,ip=0
		set answer="",output=""
		for  {
			set opcode=$piece(instructions,",",ip+1),operand=$piece(instructions,",",ip+2)
			quit:'$length(opcode)  quit:'$length(operand)
			//write !,ip,"=",opcode,":",operand
			if opcode=0 do ..div(regA,regB,regC,operand,.regA)
			if opcode=1 do ..xor(.regB,operand)
			if opcode=2 do ..mod8(regA,regB,regC,operand,.regB)
			if opcode=3,regA set ip=operand continue
			if opcode=4 do ..xor(.regB,regC)
			if opcode=5 set output=output_..out(regA,regB,regC,operand)
			if opcode=6 do ..div(regA,regB,regC,operand,.regB)
			if opcode=7 do ..div(regA,regB,regC,operand,.regC)
			//write ">>>","regA=",regA,", regB=",regB,", regC=",regC
			set ip=ip+2
		}
		set answer=..getOutput(output)
		if verbose write !,tmpRegA+i,": answer=",answer," (instructions=",instructions_")"
		if answer=instructions return $listbuild(tmpRegA+i,instructions)
		continue:$piece(instructions,",",pos,*)'=answer
		if verbose write "@"
		set response=..getRegA((tmpRegA+i)*8,regB,regC,instructions,pos-1,verbose)
		set regA=$list(response,1),answer=$list(response,2)
		if answer=instructions {
			return $listbuild(regA,instructions)
		}
	}
	quit $listbuild("","")
}

}

