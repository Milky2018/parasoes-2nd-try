help:
  @help

init:
  tic80 --cli --fs ./assets --cmd 'new wasm & save game.tic'

run:
  tic80 --skip --fs ./assets --cmd 'load game.tic & import binary game.wasm & run'

patch:
  tic80 --cli --fs ./assets --cmd 'load game.tic & import binary game.wasm & save'

export:
  tic80 --cli --fs ./assets --cmd 'load game.tic & export html game'

edit:
  tic80 --skip --fs ./assets --cmd 'load game.tic & edit'

build:
  moon build --target wasm --release

copy:
  cp _build/wasm/release/build/parasoes.wasm ./assets/game.wasm

build-copy: build copy

build-run: build-copy run

size: build-copy
  du -h ./assets/game.wasm
  