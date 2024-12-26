Class AOC2024.Day25 Extends AOC2024.Base
{

Parameter InputFile = "d25.txt";

// d ##class(AOC2024.Day25).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",cnt=0,state=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if '$length(record) set cnt=0 continue
		if cnt=0 {
			set type=$select($length($translate(record,"#")):0,1:1)  //0 - key, 1 - lock
			set cnt=$increment(arr(type))
		}
		set arr(type,cnt,$increment(arr(type,cnt)))=record
	}
	set len=$length(recordsArr(1)),empty="",height=arr(0,1)
	for i=1:1:len set empty=empty_$listbuild("")
	for type=0,1 {
		set cnt=""
		for  {
			set cnt=$order(arr(type,cnt)) quit:'$length(cnt)
			set keyData=empty
			set line=1
			for  {
				set line=$order(arr(type,cnt,line)) quit:'$length(line)
				set data=arr(type,cnt,line)
				//write !,type,",",cnt,":",data
				for i=1:1:len {
					continue:$list(keyData,i)'=""
					set ltr=$extract(data,i)
					if type=0 continue:ltr'="#"
					if type=1 continue:ltr'="."
					set:type=0 $list(keyData,i)=height-line
					set:type=1 $list(keyData,i)=line-2
				}
			}
			//if type=0 break
			set:type=0 arrKey(cnt)=keyData
			set:type=1 arrLock(cnt)=keyData
		}
	}
	//zwrite arrKey,arrLock
	set lock="",maxSize=height-2,fits=0
	for  {
		set lock=$order(arrLock(lock)) quit:'$length(lock)
		set lockData=arrLock(lock)
		set key=""
		for  {
			set key=$order(arrKey(key)) quit:'$length(key)
			set keyData=arrKey(key),overlap=0
			f i=1:1:len {
				i $li(lockData,i)+$li(keyData,i)>maxSize s overlap=1 q
			}
			set:'overlap arrFit(lock,key)="",fits=fits+1
		}
	}
	if verbose zwrite arrFit
	set answer=fits
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	if verbose write !,"You made it to the last day"
	set answer="Finito la comedy"
	quit answer
}

}

