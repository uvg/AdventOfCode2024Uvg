Class AOC2024.Day13 Extends AOC2024.Base
{

Parameter InputFile = "d13.txt";

// d ##class(AOC2024.Day13).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	do ..GetData(.recordsArr,.arr)
	set answer="",total=0
	for i=1:1:arr {
		set data=arr(i)
		set solution=..Solve(data)
		set b1=$list(solution,1),b2=$list(solution,2)
		if (b1<0)||(b2<0)||(b1\1'=b1)||(b2\1'=b2) continue
		if verbose zwrite arr(i),solution
		set total=b1*3+b2+total
	}
	set answer=total
	quit answer
}

ClassMethod Solve(data As %String) As %String [ Private ]
{
	/*
A*X=B ===> A^(-1)*A*X=A^(-1)*B ===> I*X=A^(-1)*B ==> X=A^(-1)*B


ax+by=c
dx+ey=f

A= |a b|
   |d e|


X= |x|
   |y|

B= |c|
   |f|



A^(-1)= 1/(ae-bd)*| e -b|
                  |-d  a|


|x|=1/(ae-bd)*| e -b|*|c|
|y|           |-d  a| |f|



x=(1/(a*e-b*d)*e*c)+(1/(a*e-b*d)*-b*f)
y=(1/(a*e-b*d)*-d*c)+(1/(a*e-b*d)*a*f)
	*/

	//data=$listbuild(dx1,dy1,dx2,dy2,x,y)
	//
	//b1*dx1+b2*dx2=x
	//b1*dy1+b2*dy2=y
	//ax+by=c
	//dx+ey=f
	//a=dx1, b=dx2, c=x, d=dy1, e=dy2, f=y, x=b1, y=b2
	//
	//
	//x=(1/(a*e-b*d)*e*c)+(1/(a*e-b*d)*-b*f)
	//b1=(1/(dx1*dy2-dx2*dy1)*dy2*x)+(1/(dx1*dy2-dx2*dy1)*-dx2*y)
	//
	//y=(1/(a*e-b*d)*-d*c)+(1/(a*e-b*d)*a*f)
	//b2=(1/(dx1*dy2-dx2*dy1)*-dy1*x)+(1/(dx1*dy2-dx2*dy1)*dx1*y)
	set dx1=$list(data,1),dy1=$list(data,2),dx2=$list(data,3),dy2=$list(data,4),x=$list(data,5),y=$list(data,6)
	set det=(dx1*dy2)-(dx2*dy1)
	quit:'det $listbuild(-1,-1)  //no solution (parallels)
	set invDet=1/det
	set b1=+$fnumber((invDet*dy2*x)+(invDet*-dx2*y),"",6)
	set b2=+$fnumber((invDet*-dy1*x)+(invDet*dx1*y),"",6)
	quit $listbuild(b1,b2)
}

ClassMethod GetData(ByRef recordsArr, Output arr) [ Private ]
{
	set line="",type=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if type=0 {  //Button A: X+94, Y+34
			set dx1=+$piece(record,"+",2),dy1=+$piece(record,"+",3)
			set type=1
			continue
		}
		if type=1 {  //Button B: X+22, Y+67
			set dx2=+$piece(record,"+",2),dy2=+$piece(record,"+",3)
			set type=2
			continue
		}
		if type=2 {  //Prize: X=8400, Y=5400
			set x=+$piece(record,"=",2),y=+$piece(record,"=",3)
			set arr($increment(arr))=$listbuild(dx1,dy1,dx2,dy2,x,y)
			set type=3
			continue
		}
		if type=3 {
			set type=0
			continue
		}
	}
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	do ..GetData(.recordsArr,.arr)
	set answer="",total=0
	for i=1:1:arr {
		//data=$listbuild(dx1,dy1,dx2,dy2,x,y)
		set data=arr(i),$list(data,5)=$list(data,5)+10000000000000,$list(data,6)=$list(data,6)+10000000000000
		set solution=..Solve(data)
		set b1=$list(solution,1),b2=$list(solution,2)
		if (b1<0)||(b2<0)||(b1\1'=b1)||(b2\1'=b2) continue
		if verbose zwrite arr(i),solution
		set total=b1*3+b2+total
	}
	set answer=total
	quit answer
}

}

