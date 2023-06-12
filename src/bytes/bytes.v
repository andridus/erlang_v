module bytes

// Unlike a Buffer, a Reader is a read-only and supports seeking.
// The zero value for Reader operates like a Reader of an empty slice.
pub struct Reader {
	s []u8
mut:
	i         i64
	prev_rune int
}

// Len returns the number of bytes of the unread portion of the slice
pub fn (r &Reader) length() int {
	if r.i >= i64(r.s.len) {
		return 0
	}
	return int(i64(r.s.len) - r.i)
}

pub fn (mut r Reader) read_byte() !u8 {
	r.prev_rune = -1
	if r.i >= i64(r.s.len) {
		return error('EOF')
	}
	b := r.s[r.i]
	r.i++
	return b
}

pub fn (mut r Reader) read_bytes(len int) ![]u8 {
	mut bin := []u8{len: len}
	for _ in 0 .. len {
		bin << r.read_byte()!
	}
	return bin
}

pub fn new_reader(b []u8) Reader {
	return Reader{b, 0, -1}
}
