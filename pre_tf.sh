#!/usr/bin/env bash

workdir=$(pwd)

#create_go_binary <bin file> <package zip name>
function create_go_binary {
    cd "$workdir" || return
    go mod init "$1"
    go mod tidy
    GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o "$workdir/$1"
    zip -u "$1".zip "$1"
}

create_go_binary spot-evict-event
