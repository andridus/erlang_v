module main

import erlang
import math.big

// decode binary string to term
fn decode(b string) !erlang.Term {
	return erlang.binary_to_term(b.bytes())
}

//// ---- Start tests
/// Check Atom Term
fn test_atom() {
	atom1 := erlang.ErlAtomUTF8('test')
	atom2 := erlang.ErlAtom('test')
	assert atom1.str() == atom2
}

fn test_decode_binary_to_term_atom() {
	atom := erlang.ErlAtom("my_atom")
	bin := erlang.term_to_binary(atom)!
	assert erlang.Term(erlang.ErlAtom("my_atom")) == erlang.binary_to_term(bin)!
}
fn test_decode_binary_to_term_big_atom() {
	atom := erlang.string_to_atom("loremipsumdolorsitamet,consecteturadipiscingelit.Namsedrutrumaugue.Namatmollisquam.Sedrhoncusquamacnuncmollis,etdapibusantevenenatisloremipsumdolorsitamet,consecteturadipiscingelit.Namsedrutrumaugue.Namatmollisquam.Sedrhoncusquamacnuncmollis,etdapibusante")
	bin := erlang.term_to_binary(atom)!
	assert erlang.Term(erlang.ErlAtom("loremipsumdolorsitamet,consecteturadipiscingelit.Namsedrutrumaugue.Namatmollisquam.Sedrhoncusquamacnuncmollis,etdapibusantevenenatisloremipsumdolorsitamet,consecteturadipiscingelit.Namsedrutrumaugue.Namatmollisquam.Sedrhoncusquamacnuncmollis,etdapibusante")) == erlang.binary_to_term(bin)!
}

fn test_decode_binary_to_term_integer() {
	integer := erlang.int_to_term(123)
	bin := erlang.term_to_binary(integer)!
	assert erlang.Term(erlang.ErlInteger8(123)) == erlang.binary_to_term(bin)!
}

fn test_decode_binary_to_small_big_integer() {
	inum := i64(999999999999999999)
	integer := erlang.i64_to_term(inum)
	bin := erlang.term_to_binary(integer)!
	assert erlang.Term(erlang.ErlIntegerBig(big.integer_from_i64(inum))) == erlang.binary_to_term(bin)!
}

fn test_decode_binary_to_large_big_integer() {
	inum := i64(99999999999)
	integer := erlang.i64_to_term(inum)
	println(integer)
	bin := erlang.term_to_binary(integer)!
	assert erlang.Term(erlang.ErlIntegerBig(big.integer_from_i64(inum))) == erlang.binary_to_term(bin)!
}
