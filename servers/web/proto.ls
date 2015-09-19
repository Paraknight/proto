require! {
  '../../src/core/game.ls' : { Game }
}

game = new Game do
  sig-serv: 'amar.io:9987'
  default-room: \proto.test.cell_0_0_0
