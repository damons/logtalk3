%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  This file is part of Logtalk <http://logtalk.org/>  
%  Copyright 2017 Sergio Castro <sergioc78@gmail.com> and  
%  Paulo Moura <pmoura@logtalk.org>
%  
%  Licensed under the Apache License, Version 2.0 (the "License");
%  you may not use this file except in compliance with the License.
%  You may obtain a copy of the License at
%  
%      http://www.apache.org/licenses/LICENSE-2.0
%  
%  Unless required by applicable law or agreed to in writing, software
%  distributed under the License is distributed on an "AS IS" BASIS,
%  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%  See the License for the specific language governing permissions and
%  limitations under the License.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- object(optional).

	:- info([
		version is 1.0,
		author is 'Paulo Moura',
		date is 2017/05/30,
		comment is 'Constructors for optional references. An optional reference repesents a term that may or may not be present. Optional references shoud be regarded as opaque terms and always used with the "optional(_)" object by passing the reference as a parameter.'
	]).

	:- public(empty/1).
	:- mode(empty(--nonvar), one).
	:- info(empty/1, [
		comment is 'Constructs an empty optional reference.',
		argnames is ['Reference']
	]).

	:- public(of/2).
	:- mode(of(@term, --nonvar), one).
	:- info(of/2, [
		comment is 'Constructs an optional reference from a term.',
		argnames is ['Term', 'Reference']
	]).

	empty(empty).

	of(Term, the(Term)).

:- end_object.


:- object(optional(_Reference)).

	:- info([
		version is 1.0,
		author is 'Paulo Moura',
		date is 2017/05/30,
		comment is 'Optional reference predicates. Require passing an optional reference constructed using the "optional" object as a parameter.',
		parnames is ['Reference']
	]).

	:- public(is_empty/0).
	:- mode(is_empty, zero_or_one).
	:- info(is_empty/0, [
		comment is 'True if the optional reference is empty.'
	]).

	:- public(is_present/0).
	:- mode(is_present, zero_or_one).
	:- info(is_present/0, [
		comment is 'True if the optional reference holds a term.'
	]).

	:- public(if_empty/1).
	:- meta_predicate(if_empty(0)).
	:- mode(if_empty(+callable), zero_or_more).
	:- info(if_empty/1, [
		comment is 'Calls a goal if the optional reference is empty. Succeeds otherwise.',
		argnames is ['Goal']
	]).

	:- public(if_present/1).
	:- meta_predicate(if_present(1)).
	:- mode(if_present(+callable), zero_or_more).
	:- info(if_present/1, [
		comment is 'Applies a closure with the optional reference value as additional argument if not empty. Succeeds otherwise.',
		argnames is ['Closure']
	]).

	:- public(filter/2).
	:- meta_predicate(filter(1, *)).
	:- mode(filter(+callable, --nonvar), one).
	:- info(filter/2, [
		comment is 'Returns the optional reference when it is non-empty and its value satisfies a closure. Otherwise returns an empty optional.',
		argnames is ['Closure', 'Reference']
	]).

	:- public(map/2).
	:- meta_predicate(map(2, *)).
	:- mode(map(+callable, --nonvar), one).
	:- info(map/2, [
		comment is 'When the the optional reference is non-empty and mapping a closure with the optional reference value and the new value as additional arguments is successful, returns an optional reference with the new value. Otherwise returns an empty optional.',
		argnames is ['Closure', 'NewReference']
	]).

	:- public(flat_map/2).
	:- meta_predicate(flat_map(2, *)).
	:- mode(flat_map(+callable, --nonvar), one).
	:- info(flat_map/2, [
		comment is 'When the the optional reference is non-empty and mapping a closure with the optional reference value and the new optional reference as additional arguments is successful, returns the new optional reference. Otherwise returns an empty optional.',
		argnames is ['Closure', 'NewReference']
	]).

	:- public(get/1).
	:- mode(get(--term), one).
	:- info(get/1, [
		comment is 'Returns the optional reference term if not empty. Throws a resource error otherwise.',
		argnames is ['Term']
	]).

	:- public(or_else/2).
	:- mode(or_else(--term, @term), one).
	:- info(or_else/2, [
		comment is 'Returns the optional reference term if not empty or the given default term if the optional is empty.',
		argnames is ['Term', 'Default']
	]).

	:- public(or_else_get/2).
	:- meta_predicate(or_else_get(1, *)).
	:- mode(or_else_get(--term, +callable), one).
	:- info(or_else_get/2, [
		comment is 'Returns the optional reference term if not empty or applies a closure to compute the term if the optional is empty.',
		argnames is ['Term', 'Closure']
	]).

	is_empty :-
		parameter(1, empty).

	is_present :-
		parameter(1, the(_)).

	if_empty(Goal) :-
		parameter(1, Reference),
		(	Reference == empty ->
			call(Goal)
		;	true
		).

	if_present(Closure) :-
		parameter(1, Reference),
		(	Reference == empty ->
			true
		;	Reference = the(Term),
			call(Closure, Term)
		).

	filter(Closure, NewReference) :-
		parameter(1, Reference),
		(	Reference = the(Term),
			call(Closure, Term) ->
			NewReference = Reference
		;	NewReference = empty
		).

	map(Closure, NewReference) :-
		parameter(1, Reference),
		(	Reference = the(Term),
			call(Closure, Term, NewTerm) ->
			NewReference = the(NewTerm)
		;	NewReference = empty
		).

	flat_map(Closure, NewReference) :-
		parameter(1, Reference),
		(	Reference = the(Term),
			call(Closure, Term, NewReference) ->
			true
		;	NewReference = empty
		).

	get(Term) :-
		parameter(1, Reference),
		(	Reference == empty ->
			self(Self),
			sender(Sender),
			throw(error(existence_error(optional_term,Reference), logtalk(Self::get(Term), Sender)))
		;	Reference = the(Term)
		).

	or_else(Term, Default) :-
		parameter(1, Reference),
		(	Reference == empty ->
			Term = Default
		;	Reference = the(Term)
		).

	or_else_get(Term, Closure) :-
		parameter(1, Reference),
		(	Reference == empty ->
			call(Closure, Term),
			!
		;	Reference = the(Term)
		).

:- end_object.
