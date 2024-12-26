Class AOC2024.Day22 Extends AOC2024.Base
{

Parameter InputFile = "d22.txt";

// d ##class(AOC2024.Day22).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	//kill recordsArr set recordsArr(1)=123
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set secretNumber=recordsArr(line),origSecretNumber=secretNumber
		if $data(arr(secretNumber,9)) {
			set secretNumber=arr(secretNumber,9)
		} else {
			for i=1:1:2000 {
				set prevSecretNumber=secretNumber
				if $data(arr(secretNumber,1)) {
					set secretNumber=arr(prevSecretNumber,1)
				} else {
					set value=secretNumber*64
					set secretNumber=..prune(..mix(secretNumber,value))
					set arr(prevSecretNumber,1)=secretNumber
				}
				set prevSecretNumber=secretNumber
				if $data(arr(secretNumber,2)) {
					set secretNumber=arr(prevSecretNumber,2)
				} else {
					set value=secretNumber\32
					set secretNumber=..prune(..mix(secretNumber,value))
					set arr(prevSecretNumber,2)=secretNumber
				}
				set prevSecretNumber=secretNumber
				if $data(arr(secretNumber,3)) {
					set secretNumber=arr(prevSecretNumber,3)
				} else {
					set value=secretNumber*2048
					set secretNumber=..prune(..mix(secretNumber,value))
					set arr(prevSecretNumber,3)=secretNumber
				}
				//write !,secretNumber
			}
			set arr(origSecretNumber,9)=secretNumber
		}
		set total=total+secretNumber
		if verbose write !,origSecretNumber,"=",secretNumber
	}
	set answer=total
	quit answer
}

ClassMethod prune(value As %Integer) As %Integer [ Private ]
{
	quit value#16777216
}

ClassMethod mix(secretNumber As %Integer, value As %Integer) As %Integer [ Private ]
{
	quit ..XORDec(secretNumber,value)
}

ClassMethod XORDec(Val1 As %Integer, Val2 As %Integer) [ Private ]
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
	//kill recordsArr set recordsArr(1)=123
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set secretNumber=recordsArr(line),origSecretNumber=secretNumber,lastBananas=$extract(secretNumber,*)
		//for i=1:1:10 {
		for i=1:1:2000 {
			set prevSecretNumber=secretNumber
			if $data(arr(secretNumber,1)) {
				set secretNumber=arr(prevSecretNumber,1)
			} else {
				set value=secretNumber*64
				set secretNumber=..prune(..mix(secretNumber,value))
				set arr(prevSecretNumber,1)=secretNumber
			}
			set prevSecretNumber=secretNumber
			if $data(arr(secretNumber,2)) {
				set secretNumber=arr(prevSecretNumber,2)
			} else {
				set value=secretNumber\32
				set secretNumber=..prune(..mix(secretNumber,value))
				set arr(prevSecretNumber,2)=secretNumber
			}
			set prevSecretNumber=secretNumber
			if $data(arr(secretNumber,3)) {
				set secretNumber=arr(prevSecretNumber,3)
			} else {
				set value=secretNumber*2048
				set secretNumber=..prune(..mix(secretNumber,value))
				set arr(prevSecretNumber,3)=secretNumber
			}
			set bananas=+$extract(secretNumber,*),diff=bananas-lastBananas,lastBananas=bananas
			set arrBananas(origSecretNumber,i)=$listbuild(bananas,diff)
			//write !,$j(secretNumber,8),": ",bananas," (",diff,")"
		}
		set total=total+secretNumber
		//write !,secretNumber
		for i=4:1:2000 {
			set sequence="",bananas=$list(arrBananas(origSecretNumber,i),1)
			for j=i-3:1:i {
				set sequence=sequence_$listbuild($list(arrBananas(origSecretNumber,j),2))
			}
			set:'$data(arrSeqByLine(sequence,line)) arrSeqByLine(sequence,line)=bananas
		}
	}
	if verbose zwrite arrSeqByLine
	set seq="",max=0,best=""
	set seq=""
	for  {
		set seq=$order(arrSeqByLine(seq)) quit:'$length(seq)
		set line="",total=0
		for  {
			set line=$order(arrSeqByLine(seq,line)) quit:'$length(line)
			set total=total+arrSeqByLine(seq,line)
		}
		if total>max set max=total,best=seq
	}
	set answer=max
	quit answer
}

}

