% Here are a bunch of facts describing the Simpson's family tree.
% Don't change them!

female(mona).
female(jackie).
female(marge).
female(patty).
female(selma).
female(lisa).
female(maggie).
female(ling).

male(abe).
male(clancy).
male(herb).
male(homer).
male(bart).

married_(abe,mona).
married_(clancy,jackie).
married_(homer,marge).

married(X,Y) :- married_(X,Y).
married(X,Y) :- married_(Y,X).

parent(abe,herb).
parent(abe,homer).
parent(mona,homer).

parent(clancy,marge).
parent(jackie,marge).
parent(clancy,patty).
parent(jackie,patty).
parent(clancy,selma).
parent(jackie,selma).

parent(homer,bart).
parent(marge,bart).
parent(homer,lisa).
parent(marge,lisa).
parent(homer,maggie).
parent(marge,maggie).

parent(selma,ling).



%%
% Part 1. Family relations
%%

% 1. Define a predicate `child/2` that inverts the parent relationship.
child(X,Y) :- parent(Y,X).

% 2. Define two predicates `isMother/1` and `isFather/1`.
isMother(X) :- parent(X,_), female(X).
isFather(X) :- parent(X,_), male(X).

% 3. Define a predicate `grandparent/2`.
grandparent(X,Y) :- parent(Z,Y), parent(X,Z).

% 4. Define a predicate `sibling/2`. Siblings share at least one parent.
sibling(X,Y) :- parent(Z,X), parent(Z,Y), Y \= X.

% 5. Define two predicates `brother/2` and `sister/2`.
brother(X,Y) :- parent(Z, X), parent(Z, Y), male(X), X\=Y.
sister(X,Y) :- parent(Z, X), parent(Z, Y), female(X), X\=Y.

% 6. Define a predicate `siblingInLaw/2`. A sibling-in-law is either married to
%    a sibling or the sibling of a spouse.
siblingInLaw(X, Y) :- sibling(X,Z), married(Z,Y) ; sibling(Z,Y), married(X,Z).

% 7. Define two predicates `aunt/2` and `uncle/2`. Your definitions of  these
%    predicates should include aunts and uncles by marriage.
aunt(Y,X) :- parent(P,X), sister(P,Y), Y\=P ; parent(P,X), sibling(P,S), married(S,Y), female(Y).
uncle(Y,X) :- parent(P,X), brother(P,Y), Y\=P ; parent(P,X), sibling(P,S), married(S,Y), male(Y).

% 8. Define the predicate `cousin/2`.
cousin(X,Y) :- aunt(A,X), child(Y,A) ; uncle(U,X), child(Y,U).

% 9. Define the predicate `ancestor/2`.
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z,Y).

% Extra credit: Define the predicate `related/2`.
related(X,Y) :- ancestor(X,Y); ancestor(Y,X); aunt(X,Y); aunt(Y,X); uncle(X,Y); uncle(Y,X); cousin(X,Y); siblingInLaw(X,Y); sibling(X,Y).


%%
% Part 2. Language implementation
%%

% 1. Define the predicate `cmd/3`, which describes the effect of executing a
%    command on the stack.
% cmd(command, stack1, stack2), command on stack1 produces stack2
% If we're appending nothing, return the list

bool(t).
bool(f).

literal(X) :- number(X).
literal(X) :- string(X).
literal(X) :- bool(X).

% `cmd/3`: the predicate cmd(C,S1,S2) means that executing command C with stack S1 produces stack S2.
cmd(E,S1,S2) :- literal(E), S2 = [E|S1]. % base case

% pop two numbers, add them together.
cmd(add,[E1,E2|S1],S2) :- Res is E1 + E2, S2 = [Res|S1].
% if the first number is less than the second, t, else f
cmd(lte,[E1,E2|S1],S2) :- (E1 =< E2 ->Y=t;Y=f), S2 = [Y|S1].
% if the popped value is t, then program 1, else 2
cmd(if(Then,_), [t|S1], S2) :- prog(Then, S1, S2).
cmd(if(_,Else), [f|S1], S2) :- prog(Else, S1, S2).

% Less than greater than Helper functions
is_lte(X, Y, t) :- X =< Y.
is_lte(X, Y, f) :- X > Y.

% 2. Define the predicate `prog/3`, which describes the effect of executing a
%    program on the stack.
% `prog/3`: prog(P,S1,S2) means that executing program P with stack S1 produces stack S2.
prog([], S, S).
prog([C|CS], S1, S2) :- cmd(C, S1, S_), prog(CS, S_, S2).


