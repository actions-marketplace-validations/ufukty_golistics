# Golistics

Golistics is a linter to warn developer when a **"holistic"** method miss a field. Holistic methods are those methods that need to access all fields of the receiver to stay valid such as validators, comparators and serializers.

1. Require all receiver fields (exported + unexported)

   ```go
   //golistics:all
   func (r Receiver) Validate() map[string]error
   ```

1. Require only exported receiver fields

   ```go
   //golistics:exported
   func (r Receiver) String() string
   ```

Note that Golistics only count **direct** selector usage rooted at the receiver. Passing the receiver to another function (e.g. `json.Marshal(r)`) does NOT count as referencing fields.

## Install & Usage

Golistics can be used in both the development and CI environments.

### Developer machine

Install Golistics into a machine using Go tools:

```sh
go install go.ufukty.com/golistics@latest
```

Then validate the shell can find the installation directory by running `which golistics`.

Run Golistics on a Go module as:

```sh
go vet --vettool="$(which golistics)" ./...
```

### GitHub CI

Add the `ufukty/golistics` step into your workflow file.

```yml
jobs:
  <job name>:
    steps:
      - uses: actions/checkout@v6
      - uses: actions/setup-go@v6
        with: { go-version-file: go.mod, cache: true }
      - uses: ufukty/golistics@0.3.0
```

Note that the action assumes the CI is already checked out to the target ref and have the go setup established as below. It makes sense to enable caching at `actions/setup-go` as Golistics action performs `go install` at each run.

## Example

Take a look at the [testfile](pkg/analyzer/testdata/gss.go):

```go
type (
  Borders struct {
    Top, Right, Bottom, Left Border
  }
  Margin struct {
    Top, Right, Bottom, Left any
  }
  Dimensions struct {
    Height     any
    Width      any
    unexported any
  }
)

//golistics:exported
func (s Dimensions) Strings() []string {
  return nil
}

//golistics:all
func (s Borders) IsEqual(y Borders) bool {
  return false
}

//golistics:all
func (s Margin) IsEqual(y Margin) bool {
  return safeEq(s.Right, y.Right) &&
    safeEq(s.Bottom, y.Bottom) &&
    safeEq(s.Left, y.Left)
}
```

```sh
go vet --vettool="$(which golistics)" ./...
pkg/analyzer/testdata/gss.go:173:1: missing fields: Height, Width
pkg/analyzer/testdata/gss.go:241:1: missing fields: Bottom, Left, Right, Top
pkg/analyzer/testdata/gss.go:246:1: missing field: Top
```
