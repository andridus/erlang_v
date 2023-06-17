# Erlang External Term Format on V
Provides an Erlang External Term Format for V.

erlang doc: http://erlang.org/doc/apps/erts/erl_ext_dist.html.

## Motivation
The library is core of Lx lang to compiles code to BeamVM, futhermore will be possible to create compatible macros within.

## The Library Erlang Terms

- ErlAtom
- ErlAtomCacheRef
- ErlAtomUTF8
- ErlBinary
- ErlBoolean
- ErlFloat
- ErlFunction
- ErlInteger32
- ErlInteger8
- ErlIntegerBig
- ErlList
- ErlMap
- ErlNil
- ErlPid
- ErlPort
- ErlReference
- ErlString
- ErlTuple

## The main functions
 - binary_to_term( []u8 ) Term
 - term_to_binary( Term ) []u8
 - int_to_term( int ) Term
 - i64_to_term( i64 ) Term
 - atom_to_binary( ErlAtom ) []u8
 - string_to_binary( string ) []u8
 - float_to_binary( f64 ) []u8
 - old_float_to_binary( f64 ) []u8 // compatibily purposes
 - integer8_to_binary( i8 ) []u8
 - integer32_to_binary( int ) []u8
 - integer_big__to_binary( math.big.Integer ) []u8
 - nil_to_binary() []u8

## Execute tests
Execute the follow command
`$ v test .`