package Math::RPN;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require AutoLoader;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	rpn
);
$VERSION = '1.02';


# Preloaded methods go here.

sub rpn
{
	my $convr=shift;
	my @stack=();
	my @ops=split(/,/, $convr);
	my $inbrace=0;
	my $bracexp="";
	foreach(@ops)
	{
		s/\s+//g;	# Eliminate unneeded spaces
		$_=uc($_);
		if ($_ eq "{")
		{
			if ($inbrace)
			{
				my $msg="Cannot nest braces expr ".
					"$convr at ".$_;
				logmsg('err', $msg);
				last;
			}
			$inbrace++;
			$bracexp="";
			next;
		}
		elsif ($_ eq "}")
		{
			unless ($inbrace)
			{
				my $msg="Cannot nest braces expr ".
					"$convr at ".$_;
				logmsg('err', $msg);
				last;
			}
			$inbrace--;
			$bracexp=~s/,$//;	# Strip trailing comma if any
			push(@stack, $bracexp);
			next;
		}
		if ($inbrace)
		{
			$bracexp.=$_.",";
			next;
		}

		if ($_ eq "+" || $_ eq "ADD")
		{
			if ($#stack < 1)
			{
				@stack=(undef);
				my $msg="Stack Underflow for expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			push(@stack, pop(@stack)+pop(@stack));
		}
		elsif ($_ eq "-" || $_ eq "SUB")
		{
			if ($#stack < 1)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			my $v1=pop(@stack);
			my $v2=pop(@stack);
			push(@stack, $v2-$v1);
		}
		elsif ($_ eq "\*" || $_ eq "MUL")
		{
			if ($#stack < 1)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			push(@stack, pop(@stack)*pop(@stack));
		}
		elsif ($_ eq "\/" || $_ eq "DIV")
		{
			if ($#stack < 1)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			my $v1=pop(@stack);
			my $v2=pop(@stack);
			push(@stack, $v2/$v1);
		}
		elsif ($_ eq "%" || $_ eq "MOD")
		{
			if ($#stack < 1)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			my $v1=pop(@stack);
			my $v2=pop(@stack);
			push(@stack, $v2%$v1);
		}
		elsif ($_ eq "POW")
		{
			if ($#stack < 1)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			my $v1=pop(@stack);
			my $v2=pop(@stack);
			push(@stack, $v2 ** $v1);
		}
		elsif ($_ eq "SQRT")
		{
                        if ($#stack < 0)
                        {
                                @stack=(undef);
                                my $msg="Stack Underflow for ".
                                        "expr $convr at ".
                                        $_;
                                logmsg('err', $msg);
                                last;
                        }
			push(@stack,sqrt(pop(@stack)));
		}
		elsif ($_ eq "SIN")
		{
                        if ($#stack < 0)
                        {
                                @stack=(undef);
                                my $msg="Stack Underflow for ".
                                        "expr $convr at ".
                                        $_;
                                logmsg('err', $msg);
                                last;
                        }
			push(@stack,sin(pop(@stack)));
		}
		elsif ($_ eq "COS")
		{
                        if ($#stack < 0)
                        {
                                @stack=(undef);
                                my $msg="Stack Underflow for ".
                                        "expr $convr at ".
                                        $_;
                                logmsg('err', $msg);
                                last;
                        }
			push(@stack,cos(pop(@stack)));
		}
		elsif ($_ eq "LOG")
		{
                        if ($#stack < 0)
                        {
                                @stack=(undef);
                                my $msg="Stack Underflow for ".
                                        "expr $convr at ".
                                        $_;
                                logmsg('err', $msg);
                                last;
                        }
			push(@stack,log(pop(@stack)));
		}
		elsif ($_ eq "EXP")
		{
                        if ($#stack < 0)
                        {
                                @stack=(undef);
                                my $msg="Stack Underflow for ".
                                        "expr $convr at ".
                                        $_;
                                logmsg('err', $msg);
                                last;
                        }
			push(@stack,exp(pop(@stack)));
		}

		elsif ($_ eq "<" || $_ eq "LT")
		{
			if ($#stack < 1)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			my $v1=pop(@stack);
			my $v2=pop(@stack);
			push(@stack, ($v2<$v1 ? 1 : 0));
		}
		elsif ($_ eq "<=" || $_ eq "LE")
		{
			if ($#stack < 1)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			my $v1=pop(@stack);
			my $v2=pop(@stack);
			push(@stack, ($v2<=$v1 ? 1 : 0));
		}
		elsif ($_ eq "=" || $_ eq "==" || $_ eq "EQ")
		{
			if ($#stack < 1)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			my $v1=pop(@stack);
			my $v2=pop(@stack);
			push(@stack, ($v2==$v1 ? 1 : 0));
		}
		elsif ($_ eq ">=" || $_ eq "GT")
		{
			if ($#stack < 1)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			my $v1=pop(@stack);
			my $v2=pop(@stack);
			push(@stack, ($v2>$v1 ? 1 : 0));
		}
		elsif ($_ eq ">" || $_ eq "GE")
		{
			if ($#stack < 1)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			my $v1=pop(@stack);
			my $v2=pop(@stack);
			push(@stack, ($v2>=$v1 ? 1 : 0));
		}
		elsif ($_ eq "!=" || $_ eq "NE")
		{
			if ($#stack < 1)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			my $v1=pop(@stack);
			my $v2=pop(@stack);
			push(@stack, ($v2!=$v1 ? 1 : 0));
		}
		elsif ($_ eq "IF")
		{
			if ($#stack < 2)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			my $el=pop(@stack);
			my $th=pop(@stack);
			my $co=pop(@stack);
			my $ve=($co ? $th : $el);
			if ($ve =~ /,/)
			{
				# Execute brace-enclosed expression
				@stack=rpn(join(",", @stack, $ve));
			}
			else
			{
				push(@stack, $ve);
			}
		}
		elsif ($_ eq "DUP")
		{
			if ($#stack < 0)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			my $v1 = pop(@stack);
			push(@stack, $v1, $v1);
		}
		elsif ($_ eq "EXCH")
		{
			if ($#stack < 1)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			my $v1 = pop(@stack);
			my $v2 = pop(@stack);
			push(@stack, $v1, $v2);
		}
		elsif ($_ eq "POP")
		{
			if ($#stack < 0)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			pop(@stack);
		}
		elsif ($_ eq "MIN")
		{
			if ($#stack < 1)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			my $v1 = pop(@stack);
			my $v2 = pop(@stack);
			push(@stack, ($v1<$v2 ? $v1 : $v2));
		}
		elsif ($_ eq "MAX")
		{
			if ($#stack < 1)
			{
				@stack=(undef);
				my $msg="Stack Underflow for ".
					"expr $convr at ".
					$_;
				logmsg('err', $msg);
				last;
			}
			my $v1 = pop(@stack);
			my $v2 = pop(@stack);
			push(@stack, ($v1>$v2 ? $v1 : $v2));
		}
		elsif ($_ eq "TIME")
		{
			push(@stack, time());
		}
		else
		{
			push(@stack, $_);
		}
	}
	if ($#stack < 0)
	{
		@stack=(undef);
		logmsg('err', "Stack underflow for expr ".
			"$convr, no value at end.");
	}
	elsif ($#stack > 0 && wantarray==0)
	{
		logmsg('warning', "Extra values left on stack for ".
			"expr $convr left ".
			join(",", @stack)." (right one used).");
	}
	if (wantarray)
	{
		return(@stack);
	}
	else
	{
		return(pop(@stack));
	}
}

sub logmsg
{
        my $severity;
        my $message;

        if (scalar(@_) > 1)
        {
                $severity=shift;
        }
        else
        {
                $severity="err";      # Default to LOG_ERR severity
        }

        $message=join("", @_);
        $message=~s/\r/\\r/g;
        $message=~s/\n/\\n/g;
        print STDERR "$0 $$: $severity: $message at ", scalar localtime, "\n";
}

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__

=head1 NAME

RPN - Perl extension for Reverse Polish Math Expression Evaluation

=head1 SYNOPSIS

  use Math::RPN;
  $value=rpn(expr);
  @array=rpn(expr);

=head1 DESCRIPTION

The rpn function will take a scalar which contains an RPN expression
as a set of comma delimited values and operators, and return the
result or stack, depending on context.  If the function is called
in an array context, it will return the entire remaining stack.
If it is called in a scalar context, it will return the top item
of the stack.  In a scalar context, if more than one value remains
on the stack, a warning will be sent to STDERR.

In the event of an error, an error message will be sent to STDERR,
and rpn will return undef.

The expression can contain any combination of values and operators.
Any value which is not an operator is assumed to be a value to be
pushed onto the stack.

An explanation of Reverse Polish Notation is beyond the scope of this
document, but it I will describe it briefly as a stack-based way
of writing mathematical expressions.  This has the advantage of
eliminating the need for parenthesis and simplifying parsing for
computers vs. normal algebraic notation at a slight cost in
the ability of humans to easily comprehend the expressions.

=head1 OPERATORS

The following operators are supported in the RPN evaluator:

       Operator        Operation
       +,ADD           [a][b]->[a+b]
       -,SUB           [a][b]->[a-b]
       *,MUL           [a][b]->[a*b]
       /,DIV           [a][b]->[a/b]
       %,MOD           [a][b]->[a%b]
       POW             [a][b]->[a^b]
       SQRT            [a]->[sqrt(a)]
       SIN             [a]->[sin(a)]
       COS             [a]->[cos(a)]
       LOG             [a]->[log(a)]
       EXP             [a]->[e^a]
       <,LT            [a][b]->(a<b ? [1] : [0])
       <=,LE           [a][b]->(a<=b ? [1] : [0])
       =,==,EQ         [a][b]->(a==b ? [1] : [0])
       >,GT            [a][b]->(a>b ? [1] : [0])
       >=,GE           [a][b]->(a>=b ? [1] : [0])
       !=,NE           [a][b]=>(a!=b ? [1] : [0])
       IF              [a][b][c]-> (a!=0 ? [b] : [c])
       DUP             [a]->[a][a]
       EXCH            [a][b]->[b][a]
       POP             [a][b]->[a]
       MIN             [a][b]->([a]<[b] ? [a] : [b])
       MAX             [a][b]->([a]>[b] ? [a] : [b])
       TIME            Pushes current time (seconds since midnight UTC 1970)

In addition, the IF operator supports special constructs for the "then" and
"else" clauses on the stack.  The construct allows an RPN expression to be
enclosed in curly braces ({expr}), which will cause the entire expression
to be pushed on to the stack unevaluated.  If this expression is to be
pushed onto the stack as a result of an IF, it is evaluated at that time.
This allows more flexibility in IF statements and provides some performance
benefits because any computations in the unused clause are not performed.

An example would look like so:

    1,{,5,3,+,10,*,},{,1,2,3,+,+,},IF

This example would result in the stack containing 80 at the end of the
evaluation.  First, the IF would be true because 1, so {,5,3,+,10,*,}
would be evaluated and the result placed on the stack.

=head1 EXAMPLES

The following are a few examples of RPN expressions for common tasks
and to help demonstrate the syntax used in the RPN evaluator...

    100,9,*,5,/,32,+	Convert 100 degrees C to 212 degrees F
			(100*9/5+32)

    5,3,LT,100,500,IF	Yields 500
			(5!<3=0,100,500,IF==500, the "else" clause)


=head1 AUTHOR

Owen DeLong, owen@delong.com

=head1 SEE ALSO

perl(1).

=cut
