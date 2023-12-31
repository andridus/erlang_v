module erlang

import math.big
// tag values here http://www.erlang.org/doc/apps/erts/erl_ext_dist.html

const (
	tag_version             = 131 // OK
	tag_compressed_zlib     = 80
	tag_new_float_ext       = 70 // OK
	tag_bit_binary_ext      = 77 // OK
	tag_atom_cache_ref      = 78
	tag_new_pid_ext         = 88
	tag_new_port_ext        = 89
	tag_newer_reference_ext = 90
	tag_small_integer_ext   = 97 // OK
	tag_integer_ext         = 98 // OK
	tag_float_ext           = 99 // OK
	tag_atom_ext            = 100 // OK
	tag_reference_ext       = 101
	tag_port_ext            = 102
	tag_pid_ext             = 103
	tag_small_tuple_ext     = 104
	tag_large_tuple_ext     = 105
	tag_nil_ext             = 106 // OK
	tag_string_ext          = 107 // OK
	tag_list_ext            = 108
	tag_binary_ext          = 109 // OK
	tag_small_big_ext       = 110 // OK
	tag_large_big_ext       = 111 // OK
	tag_new_fun_ext         = 112
	tag_export_ext          = 113
	tag_new_reference_ext   = 114
	tag_small_atom_ext      = 115 // OK
	tag_map_ext             = 116
	tag_fun_ext             = 117
	tag_atom_utf8_ext       = 118 // OK
	tag_small_atom_utf8_ext = 119 // OK
	tag_v4_port_ext         = 120
	tag_local_ext           = 121
)

type Term = ErlAtom
	| ErlAtomCacheRef
	| ErlAtomUTF8
	| ErlBinary
	| ErlBoolean
	| ErlFloat
	| ErlFunction
	| ErlInteger32
	| ErlInteger8
	| ErlIntegerBig
	| ErlList
	| ErlMap
	| ErlNil
	| ErlPid
	| ErlPort
	| ErlReference
	| ErlString
	| ErlTuple

type Errors = InputError | OutputError | ParseError

type MaybeTerm = Error | Term

// native
struct ErlNil {}

type ErlBoolean = bool
type ErlFloat = f64
type ErlInteger8 = i8
type ErlInteger32 = int
type ErlIntegerBig = big.Integer

// SMALL_ATOM_EXT or ATOM_EXT
type ErlAtom = string

// ATOM_CACHE_REF
type ErlAtomCacheRef = u8

// SMALL_ATOM_UTF8 or ATOM_UTF8_EXT
type ErlAtomUTF8 = string

// BIT_STRING_EXT
type ErlString = string

// BIT_BIANRY_EXT or BINARY_EXT
struct ErlBinary {
pub:
	value []u8
	bits  u8
}

// NIL_EXT or LIST_EXT
struct ErlList {
pub:
	value    []u8
	improper bool
}

// MAP_EXT
type ErlMap = map[string]Term

// NEW_PID_eXT or PID_EXT
struct ErlPid {
	node_tag u8
	node     []u8
	id       u8
	serial   u8
	creation u8
}

// NEW_PORT_EXT or PORT_EXT
struct ErlPort {
	node_tag u8
	node     []u8
	id       []u8
	creation []u8
}

// NEWER_REFERENCE_EXT, REFERENCE_EXT or NEW_REFERENCE_EXT
struct ErlReference {
	node_tag u8
	node     []u8
	id       []u8
	creation []u8
}

// EXPORT_EXT, FUN_EXT or NEW_FUN_EXT
struct ErlFunction {
	tag   u8
	value []u8
}

// SMALL_TUPLE_EXT or LARGE_TUPLE_EXT
type ErlTuple = []Term

// Error structs
struct InputError {
	message string
}

fn new_input_error(message string) InputError {
	return InputError{message}
}

fn (e InputError) msg() string {
	return e.message
}

// Output Error
struct OutputError {
	message string
}

fn new_output_error(message string) OutputError {
	return OutputError{message}
}

fn (e OutputError) msg() string {
	return e.message
}

// Parser Error
struct ParseError {
	message string
}

fn new_parser_error(message string) ParseError {
	return ParseError{message}
}

fn (e ParseError) msg() string {
	return e.message
}
