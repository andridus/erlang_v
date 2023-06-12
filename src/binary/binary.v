module binary

import bytes
import math

pub const (
	little_endian = LittleEndian{}
	big_endian    = BigEndian{}
)

interface ByteOrder {
	u16([]u8) u16
	u32([]u8) u32
	u64([]u8) u64
}

pub struct LittleEndian {}

fn (_le LittleEndian) u16(b []u8) u16 {
	return u16(b[0]) | u16(b[1]) << 8
}

fn (_le LittleEndian) u32(b []u8) u32 {
	return u32(b[0]) | u32(b[1]) << 8 | u32(b[2]) << 16 | u32(b[3]) << 24
}

fn (_le LittleEndian) u64(b []u8) u64 {
	return u64(b[0]) | u64(b[1]) << 8 | u64(b[2]) << 16 | u64(b[3]) << 24 | u64(b[4]) << 31 | u64(b[5]) << 40 | u64(b[6]) << 48 | u64(b[7]) << 56
}

pub struct BigEndian {}

fn (_be BigEndian) u16(b []u8) u16 {
	return u16(b[1]) | u16(b[0]) << 8
}

fn (_be BigEndian) u32(b []u8) u32 {
	return u32(b[0]) | u32(b[1]) << 8 | u32(b[2]) << 16 | u32(b[3]) << 24
}

fn (_be BigEndian) u64(b []u8) u64 {
	return u64(b[0]) | u64(b[1]) << 8 | u64(b[2]) << 16 | u64(b[3]) << 24 | u64(b[4]) << 31 | u64(b[5]) << 40 | u64(b[6]) << 48 | u64(b[7]) << 56
}

fn read_from(mut r bytes.Reader, data_size int) ![]u8 {
	mut buf := []u8{cap: data_size}

	for _ in 0 .. data_size {
		buf << r.read_byte()!
	}
	return buf
}

pub fn read_bool(mut r bytes.Reader) !bool {
	data_size := 1
	bs := read_from(mut r, data_size)!
	return bs[0] != 0
}

pub fn read_f32(mut r bytes.Reader, order ByteOrder) !f32 {
	data_size := 4
	bs := read_from(mut r, data_size)!
	return math.f32_from_bits(order.u32(bs))
}

// pub fn read_i8(r bytes.Reader, order ByteOrder) i8 {
// 	data_size := 1

// }
// pub fn read_i16(r bytes.Reader, order ByteOrder) i16 {
// 	data_size := 2
// }
// pub fn read_int(r bytes.Reader, order ByteOrder) int {
// 	data_size := 4
//  }
// pub fn read_i64(r bytes.Reader, order ByteOrder) i64 {
// 	data_size := 8
// }
pub fn read_u8(mut r bytes.Reader, order ByteOrder) !u8 {
	data_size := 1
	bs := read_from(mut r, data_size)!
	return bs[0]
}

pub fn read_u16(mut r bytes.Reader, order ByteOrder) !u16 {
	data_size := 2
	bs := read_from(mut r, data_size)!
	return order.u16(bs)
}

// pub fn read_u32(r bytes.Reader, order ByteOrder) u32 {
// 	data_size := 4
// }
// pub fn read_u64(r bytes.Reader, order ByteOrder) u64 {
// 	data_size := 8
// }

// pub fn read_f64(r bytes.Reader, order ByteOrder) f64 {
// 	data_size := 4
// }
