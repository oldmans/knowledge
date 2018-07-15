# FAQ

## JSON

## `string` vs `[]byte`

* [golang string和[]byte的对比](https://sheepbao.github.io/post/golang_byte_slice_and_string/)

1. `string` 和 `[]byte` 区别



2. `string` 和 `[]byte` 转换

`string` -> `[]byte` : `[]byte(string)`

```go
// src/runtime/slice.go
func stringtoslicebyte(buf *tmpBuf, s string) []byte {
	var b []byte
	if buf != nil && len(s) <= len(buf) {
		*buf = tmpBuf{}
		b = buf[:len(s)]
	} else {
		b = rawbyteslice(len(s))
	}
	copy(b, s)
	return b
}

func rawstring(size int) (s string, b []byte) {
	p := mallocgc(uintptr(size), nil, false)

	stringStructOf(&s).str = p
	stringStructOf(&s).len = size

	*(*slice)(unsafe.Pointer(&b)) = slice{p, size, size}

	return
}
```

`[]byte` -> `string` : `string([]byte)`

```go
func slicebytetostring(buf *tmpBuf, b []byte) string {
	l := len(b)
	if l == 0 {
		// Turns out to be a relatively common case.
		// Consider that you want to parse out data between parens in "foo()bar",
		// you find the indices and convert the subslice to string.
		return ""
	}
	if raceenabled && l > 0 {
		racereadrangepc(unsafe.Pointer(&b[0]),
			uintptr(l),
			getcallerpc(unsafe.Pointer(&buf)),
			funcPC(slicebytetostring))
	}
	if msanenabled && l > 0 {
		msanread(unsafe.Pointer(&b[0]), uintptr(l))
	}
	s, c := rawstringtmp(buf, l)
	copy(c, b)
	return s
}

func rawstringtmp(buf *tmpBuf, l int) (s string, b []byte) {
	if buf != nil && l <= len(buf) {
		b = buf[:l]
		s = slicebytetostringtmp(b)
	} else {
		s, b = rawstring(l)
	}
	return
}
```

3. 取舍

* string可以直接比较，而[]byte不可以，所以[]byte不可以当map的key值。
* 因为无法修改string中的某个字符，需要粒度小到操作一个字符时，用[]byte。
* string值不可为nil，所以如果你想要通过返回nil表达额外的含义，就用[]byte。
* []byte切片这么灵活，想要用切片的特性就用[]byte。
* 需要大量字符串处理的时候用[]byte，性能好很多。
