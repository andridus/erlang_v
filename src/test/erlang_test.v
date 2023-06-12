module main

import erlang

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
	erlang.Term(erlang.ErlAtom('test')) = decode('\x83\x64\x00\x04test')!
}

// fn test_decode_binary_to_term_big_atom() {
// 	erlang.Term(erlang.ErlAtom("meuatomogigantissimoquenaocabeem255caracteresmeuatomogigantissimoquenaocabeem255caracteresmeuatomogigantissimoquenaocabeem255caracteresmeuatomogigantissimoquenaocabeem255caracteresmeuatomogigantissimoquenaocabeem255caracteresmeuatomogigantissimoquenaocab")) = decode("\x83\x64\x00\x04meuatomogigantissimoquenaocabeem255caracteresmeuatomogigantissimoquenaocabeem255caracteresmeuatomogigantissimoquenaocabeem255caracteresmeuatomogigantissimoquenaocabeem255caracteresmeuatomogigantissimoquenaocabeem255caracteresmeuatomogigantissimoquenaocab")!
// }
