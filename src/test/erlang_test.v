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
	atom := erlang.ErlAtom('my_atom')
	bin := erlang.term_to_binary(atom)!
	a := erlang.Term(atom)
	b := erlang.binary_to_term(bin)!
	assert a == b
}

fn test_decode_binary_to_term_big_atom() {
	atom := erlang.ErlAtom('loremipsumdolorsitamet,consecteturadipiscingelit.Namsedrutrumaugue.Namatmollisquam.Sedrhoncusquamacnuncmollis,etdapibusantevenenatisloremipsumdolorsitamet,consecteturadipiscingelit.Namsedrutrumaugue.Namatmollisquam.Sedrhoncusquamacnuncmollis,etdapibusante')
	bin := erlang.atom_to_binary(atom)!
	a := erlang.Term(atom)
	b := erlang.binary_to_term(bin)!
	assert a == b
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
	bin := erlang.term_to_binary(integer)!
	assert erlang.Term(erlang.ErlIntegerBig(big.integer_from_i64(inum))) == erlang.binary_to_term(bin)!
}

fn test_decode_binary_to_term_float() {
	float := erlang.ErlFloat(1.6)
	bin := erlang.term_to_binary(float)!
	assert erlang.Term(erlang.ErlFloat(1.6)) == erlang.binary_to_term(bin)!
}

fn test_decode_binary_to_old_term_float() {
	bin := erlang.old_float_to_binary(f64(1.6))
	assert erlang.Term(erlang.ErlFloat(1.6)) == erlang.binary_to_term(bin)!
}

fn test_decode_binary_to_term_string() {
	atom := erlang.ErlString('Minha String')
	bin := erlang.term_to_binary(atom)!
	a := erlang.Term(atom)
	b := erlang.binary_to_term(bin)!
	assert a == b
}
