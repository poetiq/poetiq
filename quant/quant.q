\d .quant

/----------------------------------------------------------------------------------------------------------------------
/ Constants

pi:				acos -1
SQRT2PI:		sqrt 2 * pi
INVERSEPI:		reciprocal pi
INVERSESQRTPI:	reciprocal sqrt pi
INVERSESQRT2PI:	reciprocal sqrt 2 * pi
INVERSESQRT2:	reciprocal sqrt 2


/----------------------------------------------------------------------------------------------------------------------
/ Hyperbolic functions

sinh: {0.5 * (exp x) - exp neg x}
cosh: {0.5 * (exp x) + exp neg x}
tanh: {(e - 1) % (e: exp 2 * x) + 1}



/----------------------------------------------------------------------------------------------------------------------
/ Gamma function

LANCZOS: 0.99999999999980993 676.5203681218851 -1259.1392167224028 771.32342877765313 -176.61502916214059 12.507343278686905 -0.13857109526572012 9.9843695780195716e-6 1.5056327351493116e-7

gamma: {
	{$[
		x = 0; 0w;
		x < 0.5; pi % (sin pi * x) * gamma 1 - x;
		SQRT2PI * (t xexp x - 0.5) * (exp neg t: x + 6.5) * sum LANCZOS % 1, x + til 8
	]} each x
	}



/----------------------------------------------------------------------------------------------------------------------
/ Error function

/ Kummer function terms sufficient to give precision to seven decimal places in range [0, 3.5].
ERF: {(0.5 + x) % (1 + x) * 1.5 + x} til 42

erf:{{
		negate: x < 0;
		x: abs x;
		result: 0f;
		if [x > 0; result: 1 & (2 * x * INVERSESQRTPI) * 1 + sum prds (neg x * x) * ERF];
		$[negate; neg result; result]
	} each x
	}



/----------------------------------------------------------------------------------------------------------------------
/ Standardised probability distributions

cdf: () ! ()
cdf [`gauss]:		{{$[x < 0; 1 - cdf [`gauss; abs x]; 0.5 * 1 + erf x * INVERSESQRT2]} each x}
cdf [`laplace]:		{0.5 * 1 + (signum x) * 1 - exp neg abs x}
cdf [`logistic]:	{reciprocal 1 + exp neg x}
cdf [`student1]:	{0.5 + INVERSEPI * atan x}
cdf [`student2]:	{0.5 * 1 + x % sqrt 2 + x * x}

pdf: () ! ()
pdf [`gauss]:		{(exp neg 0.5 * x * x) * INVERSESQRT2PI}
pdf [`laplace]:		{0.5 * exp neg abs x}
pdf [`logistic]:	{e % d * d: 1 + e: exp neg x} 
pdf [`student1]:	{reciprocal pi * 1 + x * x}
pdf [`student2]:	{reciprocal (2 + x * x) xexp 1.5}



/----------------------------------------------------------------------------------------------------------------------
/ Miscellaneous

w: {x % sum x}

odds: {x % 1 - x}


\d .

/

2009.01.14 erf, gamma and cdf [`gauss] modified to allow x to be a list. Laplace distribution added.
