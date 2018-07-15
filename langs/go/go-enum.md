# enum

```go
type State int

const (
	_ State = iota
	pending
	rejected
	resolved
)

type Promise struct {
	state	State
	v 		interface{}
}
```
