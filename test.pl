# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..18\n"; }
END {print "not ok 1\n" unless $loaded;}
use Math::RPN;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.


#
# Tests are structured as a list.  Even numbered elements in the
# list are the expected result for the test expression contained
# in the next element in the list (odd numbered elements).
#
# Tests are numbered as n/2+2 where n is the list element number of the
# expected result in the list. (or int(n/2)+2 if n is the element number
# of the test, itself).
#
@tests=(
#               [8]    [8][5] [40] [20] [2]     [64] [8]
	"8","5,3,+,  8,3,-     ,*,  2,/, 3,%, 6, POW, SQRT",
#	Get the SIN of 90 degrees (First convert 90 degrees to radians)
	"1","45,2,*,2,3.1415926,*,360,/,*,SIN",
#	Get the COS of 90 degrees
	"2.67948965850286e-08","45,2,*,2,3.1415926,*,360,/,*,COS",
#	Test LOG and EXP
	"100","100,LOG,EXP",
#	Test Comparisons and simple IF
	"500","3,5,LT,500,0,IF",
	"300","4,4,LE,300,0,IF",
	"350","3,4,LE,350,0,IF",
	"400","5,3,LE,0,400,IF",
	"600","3,5,GT,0,600,IF",
	"700","5,3,GT,700,0,IF",
	"800","5,5,GE,800,0,IF",
	"900","6,3,NE,900,0,IF",
	"950","6,6,NE,0,950,IF",
#	Test Stack Manipulations
#	     (18/6-> 3 3 5->3 5->15 15 3->15 5->5 15->5 5 3->5 15->15)
	"15","6,18,EXCH,DIV,DUP,5,MAX,MUL,DUP,3,DIV,EXCH,POP,DUP,3,MUL,MAX",
#	Test time
	"now","TIME",
#
#	Complex IF (if with brace constructs)
	"6000","5,3,GT,{,10,20,30,*,*,},{,1,2,3,*,*,},IF",
	"6","5,3,LT,{,10,20,30,*,*,},{,1,2,3,*,*,},IF"
);

my $testno=2;
my $testok=1;
my $testbad=0;
while (@tests)
{
	my $expect=shift(@tests);
	my $expr=shift(@tests);
	my $result=rpn($expr);
	if ($expect eq "now")
	{
		$expect=time();
	}
	if ($result eq $expect)
	{
		print "ok $testno\n";
		$testok++;
	}
	else
	{
		print "notok $testno\n";
		$testbad++;
	}
	$testno++;
}
$testno--;

print "$testok out of $testno succeeded ($testbad bad), ", $testok/$testno*100,"% OK.\n";

