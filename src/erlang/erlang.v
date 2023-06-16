module erlang

import bytes
import binary
import math
import math.big

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
		tag_small_integer_ext {
			val := reader.read_byte() or { return err }
			i0 += 1
			return i0, ErlInteger8(val)
		}
		tag_integer_ext {
			val := binary.read_i32(mut reader, binary.big_endian)!
			i0 += 4
			return i0, ErlInteger32(val)
		}
		tag_small_big_ext, tag_large_big_ext {
			mut j0 := 0

			match tag {
				tag_small_big_ext {
					val := reader.read_byte()!
					i0 += 1
					j0 = int(val)
				}
				tag_large_big_ext {
					val := binary.read_u32(mut reader, binary.big_endian)!
					i0 += 4
					j0 = int(val)
				}
				else {
					// error('invalid tag case')
				}
			}
			// i0 += j0
			sign := reader.read_byte()!
			i0 += 1
			mut digits := reader.read_until_offset(i64(i0 + j0))!
			{
				half := digits.len >> 1
				i_last := digits.len - 1
				for i1 := 0; i1 < half; i1++ {
					j1 := i_last - i1
					digits[i1], digits[j1] = digits[j1], digits[i1]
				}
			}
			bignum := big.integer_from_bytes(digits)
			if sign == 1 {
				bignum.neg()
			}
			return i0 + j0, ErlIntegerBig(bignum)
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

pub fn int_to_term(i int) Term {
	if 0 <= i && i <= 255 {
		return ErlInteger8(i8(i))
	} else if -2147483648 <= i && i <= 2147483647 {
		return ErlInteger32(int(i))
	} else {
		return ErlIntegerBig(big.integer_from_int(i))
	}
}

pub fn i64_to_term(i i64) Term {
	if i > 2147483647 {
		return ErlIntegerBig(big.integer_from_i64(i))
	} else {
		return int_to_term(int(i))
	}
}

fn term_to_binary(term Term) ![]u8 {
	return match term {
		ErlIntegerBig { integer_big_to_binary(term)! }
		ErlInteger32 { integer32_to_binary(term) }
		ErlInteger8 { integer8_to_binary(term) }
		else { error('not an integer') }
	}
}

pub fn integer8_to_binary(term ErlInteger8) []u8 {
	return [u8(tag_version), tag_small_integer_ext, term]
}

pub fn integer32_to_binary(term ErlInteger32) []u8 {
	mut buf := binary.write_int(term, binary.big_endian)
	buf.prepend(tag_integer_ext)
	buf.prepend(tag_version)
	return buf
}

pub fn integer_big_to_binary(term ErlIntegerBig) ![]u8 {
	mut sign := u8(0)
	if term.signum < 0 {
		sign = 1
	}
	mut value, _ := term.bytes()
	length := value.len
	mut buf := []u8{}
	if length < 1 << 8 - 1 {
		n0 := binary.write_u8(u8(length), binary.big_endian)
		buf.prepend(sign)
		buf.prepend(n0)
		buf.prepend(tag_small_big_ext)
	} else if i64(length) < 1 << 32 - 1 {
		n0 := binary.write_u32(u32(length), binary.big_endian)
		buf.prepend(sign)
		buf.prepend(n0)
		buf.prepend(tag_large_big_ext)
	} else {
		return error('u32 overflow')
	}
	buf.prepend(tag_version)
	half := length >> 1
	i_last := length - 1
	for i0 := 0; i0 < half; i0++ {
		j0 := i_last - i0
		value[i0], value[j0] = value[j0], value[i0]
	}
	buf.insert(buf.len, value)
	return buf
}

pub fn main() {
	integer := i64_to_term(i64(999999999999999999))
	bin := term_to_binary(integer) or {
		println(err.msg())
		return
	}
	a := binary_to_term(bin) or {
		println(err.msg())
		return
	}
	println(a)
}
