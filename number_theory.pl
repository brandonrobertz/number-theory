% Number theory axioms
:- use_module(library(clpz)).

positive_integer(N) :-
    N #>= 0.

is_even(A) :-
    0 #= A mod 2.

is_odd(A) :-
    1 #= A mod 2.

% a divides b
% a | b iff there exists c where b = a*c
divides(A, B) :-
    positive_integer(A),
    positive_integer(B),
    B #= A * _.

% integer divmod, b | a
% for ints a, b and b > 0 we can always write a
% a = qb + r with 0 <= r < b
divmod(A, B, Q, R) :-
    positive_integer(A),
    positive_integer(B),
    B #=< A,
    R #=< A,
    R #>= 0,
    R #< B,
    A #= (B * Q) + R.

% gcd max(D) where D|A and D|B
gcd(A, B, D) :-
    A #> 0,
    B #> 0,
    D #> 0,
    D #=< A,
    D #=< B,
    A #= _ * D,
    B #= _ * D,
    once(labeling([max(D)], [D])).

% find the integer sqrt of N
integer_sqrt(N, I) :-
    positive_integer(I),
    positive_integer(N),
    I #< N,
    I1 #= I + 1,
    I * I #=< N,
    I1 * I1 #> N.

% increment A
inc(A, B) :-
    B #= A + 1.

% checks numbers N up to A until it finds a divisor
% terminates with true if prime else false
prime_(N, A) :-
    integer_sqrt(A, S),
    N #>= S
    -> true
    ; (
        N1 = N + 1,
        (
            divides(N, A)
            -> false, !
            ; prime_(N1, A)
        )
    ).

prime(2) :- !.
prime(3) :- !.
prime(A) :-
    A > 3,
    divides(2, A) -> false ; prime_(3,A).

% https://projecteuler.net/problem=757
% N = 1764, stealthy(A, B, C, D, N), labeling([min(D+C)], [A, B, C, D]).
% N = 36, A = 4, stealthy(A, B, C, D, N).
% Multiple solutions:
% bagof([A, B, C, D], (stealthy(A, B, C, D, 144), labeling([], [A, B, C, D])), S).
stealthy(A, B, C, D, N) :-
    is_even(N),
    N #> 0, A #> 1, B #> 1, C #> 1, D #> 1,
    % we've found thess to be true
    A #< B,
    C #=< D,
    D #< B,
    % only one can be odd ... this doesn't seem to make it faster though
    1 #= (A mod 2) + (B mod 2) + (C mod 2) + (D mod 2),
    % these are unproven, mathematically but seem to be true based on
    % some experimental bounds from further bifurcation analysis
    integer_sqrt(N, I),
    A #=< I,
    B #=< ((I + 1) * 2),
    C #=< ((I + 1) * 2),
    D #=< ((I + 1) * 2),
    % A #< B, A #< C, A #< D, B #> C, B #> D, D #>= C,
    N #= A * B,
    N #= C * D,
    A * B #= C * D,
    A + B #= C + D + 1.

% stealthy(4, 9, C, D).
