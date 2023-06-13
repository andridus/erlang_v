module erlang

import bytes
import binary

pub fn binary_to_term(data []byte) !Term {
	size := data.len
	if size <= 1 {
		return error('Null Input')
	}
	mut reader := bytes.new_reader(data)
	version := reader.read_byte() or { return err }
	if version != tag_version {
		return error('invalid version')
	}
	i, term := do_binary_to_term(1, mut reader) or { return err }
	if i != size {
		return error('unparsed data')
	}
	return term
}

fn do_binary_to_term(i int, mut reader bytes.Reader) !(int, Term) {
	tag := reader.read_byte() or { return err }
	mut i0 := i + 1

	match tag {
		tag_atom_ext, tag_atom_utf8_ext {
			val := binary.read_u16(mut reader, binary.big_endian)!
			j := int(val)
			i0 += 2

			mut value := []u8{cap: j}

			if j > 0 {
				value = reader.read_bytes(j)!
			}

			pos := i0 + int(j)
			str := value.bytestr()
			match str {
				'true' {
					return pos, ErlBoolean(true)
				}
				'false' {
					return pos, ErlBoolean(false)
				}
				'undefined' {
					return pos, ErlNil(0)
				}
				else {
					match tag {
						tag_atom_ext {
							return pos, ErlAtomUTF8(str)
						}
						tag_atom_utf8_ext {
							return pos, ErlAtom(str)
						}
						else {
							return error('Invalid tag clause')
						}
					}
				}
			}
		}
		tag_small_atom_ext, tag_small_atom_utf8_ext {
			val := binary.read_u8(mut reader, binary.big_endian)!
			j := int(val)
			i0 += 1
			mut value := []u8{len: j}

			if j > 0 {
				value = reader.read_bytes(j)!
			}
			pos := i0 + int(j)
			str := value.bytestr()
			match str {
				'true' {
					return pos, ErlBoolean(true)
				}
				'false' {
					return pos, ErlBoolean(false)
				}
				'undefined' {
					return pos, ErlNil(0)
				}
				else {
					match tag {
						tag_atom_ext {
							return pos, ErlAtomUTF8(str)
						}
						tag_atom_utf8_ext {
							return pos, ErlAtom(str)
						}
						else {
							return error('Invalid tag clause')
						}
					}
				}
			}
		}
		// tag_new_float_ext {
		// 	val := binary.read_f32(mut reader, binary.little_endian)!
		// 	return i + 8, ErlFloat32(val)
		// }
		else {
			return error('Invalid TAG')
		}
	}
}

pub fn main() {
	mut arr := 'meuatomogigantissimoquenaocabeem255caracteresmeuatomogigantissimoquenaocabeem255caracteresmeuatomogigantissimoquenaocabeem255caracteresmeuatomogigantissimoquenaocabeem255caracteresmeuatomogigantissimoquenaocabeem255caracteresmeuatomogigantissimoquenaocdas'.bytes()
	arr.prepend([u8(131), 100, 0, 255])
	a := binary_to_term(arr) or {
		println(err.msg())
		return
	}
	println(a)
}
