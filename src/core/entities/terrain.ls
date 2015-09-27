require! {
  '../entity.ls': { Entity }
}

export class FlatGround extends Entity
  (@uid, @parent) ->
    super ...
    @pos = x: 0 y: 0 z: 0

  sync-all: !->

  on-sync: (event, data) !->
    /*
    switch event
    | \spawn
    */
