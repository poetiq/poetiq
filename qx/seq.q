\d .seq

/ Number of digits
n: 4

/ Next sequence number
i: 1

/ Return x sequence numbers
allocate: {
	t: i + til x;
	i +: x;
	{`$ ssr [(neg n) $ string x; " "; "0"]} each t
	}

\d .

\

Allocate sequence numbers as n-digit symbols.