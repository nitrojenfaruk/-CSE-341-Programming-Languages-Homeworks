:- style_check(-singleton). 

% facts

roomID(z06, room1).
roomID(z10, room2).
roomID(z23, room3).
roomID(z11, room4).

roomCap(z06, 30).
roomCap(z10, 50).
roomCap(z23, 10).
roomCap(z11, 20).

roomOccup(z06, pl, 8).
roomOccup(z06, pl, 9).
roomOccup(z10, software, 10).
roomOccup(z10, software, 11).
roomOccup(z10, organization, 11).
roomOccup(z10, organization, 12).
roomOccup(z10, organization, 13).
roomOccup(z23, algo, 14).
roomOccup(z23, algo, 15).
roomOccup(z11, totalQuality, 15).

roomSpecial(z06, projector).
roomSpecial(z06, smartboard).
roomSpecial(z10, projector).
roomSpecial(z10, smartboard).
roomSpecial(z23, projector).
roomSpecial(z11, smartboard).

roomHandi(z06, handicappedAccess).

%%%

courseID(pl, 341).
courseID(software, 343).
courseID(organization, 331).
courseID(algo, 321).
courseID(totalQuality, 453).

courseIns(pl, yakup).
courseIns(software, habil).
courseIns(organization, alp).
courseIns(algo, didem).
courseIns(totalQuality, esin).

courseCap(pl, 30).
courseCap(software, 50).
courseCap(organization, 10).
courseCap(algo, 20).
courseCap(totalQuality, 40).

courseRoom(pl, z06).
courseRoom(software, z10).
courseRoom(organization, z10).
courseRoom(algo, z23).
courseRoom(totalQuality, z11).

courseTime(pl, 8).
courseTime(pl, 9).
courseTime(software, 10).
courseTime(software, 11).      
courseTime(organization, 11). 
courseTime(organization, 12).
courseTime(organization, 13).
courseTime(algo, 14).
courseTime(algo, 15).
courseTime(totalQuality, 15).

courseNeeds(pl, projector).
courseNeeds(pl, smartboard).
courseNeeds(software, smartboard).
courseNeeds(organization, projector).
courseNeeds(organization, smartboard).
courseNeeds(algo, projector).
courseNeeds(totalQuality, smartboard).

courseHandi(pl, handicappedAccess).

%%%

insID(yakup, 1).
insID(habil, 2).
insID(alp, 3).
insID(didem, 4).
insID(esin, 5).

insTaught(yakup, pl).
insTaught(habil, software).
insTaught(alp, organization).
insTaught(didem, algo).
insTaught(esin, totalQuality).

insPref(yakup, projector).
insPref(habil, smartboard).
insPref(alp, projector).
insPref(didem, projector).
insPref(esin, smartboard).

%%%%

stuID(sefa, 1801042657).
stuID(ahmet, 1701049829).
stuID(gorkem, 1601044856).
stuID(taha, 1901041012).
stuID(volkan, 1801049721).

stuAttend(sefa, pl).
stuAttend(sefa, software).
stuAttend(sefa, organization).
stuAttend(ahmet, pl).
stuAttend(ahmet, algo).
stuAttend(gorkem, algo).
stuAttend(gorkem, software).
stuAttend(gorkem, totalQuality).
stuAttend(taha, pl).
stuAttend(volkan, pl).
stuAttend(volkan, software).
stuAttend(volkan, organization).
stuAttend(volkan, algo).

stuHandi(taha, handicapped).


% rules

% Check whether there is any scheduling conflict.
conflict() :- 
	roomOccup(R, C1, T),  
	roomOccup(R, C2, T), 
	(C1 \== C2), 
	format('Conflict due to these courses: ~w, ~w \nRoom : ~w \nTime: ~w',[C1, C2, R, T]).


% Check which room can be assigned to a given class.
assignclass(C) :- 
	roomCap(R, CR), 
	courseCap(C, CC), 
	CR >= CC, 
	courseNeeds(C, N), 
	roomSpecial(R, S), 
	N == S,
	format('Class ~w can be assigned to ~w.',[C, R]).


% Check which room can be assigned to which classes.
assignroom() :- 
	roomCap(R, CR), 
	courseCap(C, CC),
	CR >= CC, 
	courseNeeds(C, N), 
	roomSpecial(R, S), 
	N == S,
	format('~w can be assigned to ~w.',[R, C]).


% Check whether a student can be enrolled to a given class.
enroll(S, C) :- 
	% Handicapped student
	stuHandi(S, handicapped), courseHandi(C, handicappedAccess),
	courseRoom(C, R), roomHandi(R, handicappedAccess), courseID(C, Y), not(stuAttend(S, C)) ;
	% Student
	not(stuHandi(S, handicapped)), courseID(C, Y), not(stuAttend(S, C)),
	format('~w can be assigned to ~w.',[S, C]).


% Check which classes a student can be assigned.
assignstudent(S) :- 
	% Handicapped student
	stuHandi(S, handicapped), courseHandi(X, handicappedAccess), 
	courseRoom(X, R), roomHandi(R, handicappedAccess), courseID(X, Y), not(stuAttend(S, X)) ;
	% Student
	not(stuHandi(S, handicapped)), courseID(X, Y), not(stuAttend(S, X)),
	format('~w can be assigned to ~w.',[S, X]).

