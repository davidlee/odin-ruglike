alias r := run
alias b := build
alias d := build-strict
alias t := test

run:
    odin run src -target:darwin_amd64

build: 
    odin build src -target:darwin_amd64

build-strict:
    odin build src -vet -warnings-as-errors -target:darwin_amd64 -debug
    
test: 
    odin test src -target:darwin_amd64
