% facts

flight(canakkale, erzincan, 6).

flight(erzincan, canakkale, 6).
flight(erzincan, antalya, 3).

flight(antalya, erzincan, 3).
flight(antalya, izmir, 2).
flight(antalya, diyarbakir, 4).

flight(diyarbakir, antalya, 4).
flight(diyarbakir, ankara, 8).

flight(izmir, antalya, 2).
flight(izmir, istanbul, 2).
flight(izmir, ankara, 6).

flight(istanbul, izmir, 2).
flight(istanbul, ankara, 1).
flight(istanbul, rize, 4).

flight(rize, istanbul, 4).
flight(rize, ankara, 5).

flight(ankara, izmir, 6).
flight(ankara, istanbul, 1).
flight(ankara, rize, 5).
flight(ankara, diyarbakir, 8).
flight(ankara, van, 4).

flight(van, ankara, 4).
flight(van, gaziantep, 3).


% rules

route(X, Y, C) :- connected(X, Y, C, []).
connected(X, Y, C, List) :- 
	flight(X, Z, C1), 
	not(member(Z, List)),   % Don't visit same place
	(
		(Y = Z, C is C1) ; 	% Direct flight (X -> Y)
		(connected(Z, Y, C2, [X | List]), C is C1 + C2)		% Recursive call for new departure place
	).   
