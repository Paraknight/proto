require! {
  events: { EventEmitter }
  'node-uuid': uuid
}

export class Entity extends EventEmitter
  (@uid = uuid.v4!, @parent) ->
    @children = []

  add-child: ->
    return unless it?
    @children.push it
    @emit \childadded it
    it

  remove-child: ->
    for child, index in @children
      if child is it
        @children.splice index, 1
        @emit \childremoved it
        return it

export Renderable = {}
Object.define-property Renderable, \renderable value: true writable: false

export Tangible = {}
Object.define-property Tangible, \tangible value: true writable: false

export Synchronizable = {}
Object.define-property Synchronizable, \synchronizable value: true writable: false
Synchronizable.sync = (event, data) ->
Synchronizable.sync-all = ->
Synchronizable.on-sync = (event, data) ->

export Persistent = {}
Object.define-property Persistent, \persistent value: true writable: false






export class Ground extends Entity implements Renderable, Tangible, Synchronizable, Persistent
  (@uid, @parent) ->
    super ...
    @pos = x: 0 y: 0 z: 0

  sync-all: !->

  on-sync: (event, data) !->
    /*
    switch event
    | \spawn
    */



export class Ball extends Entity implements Renderable, Tangible, Synchronizable, Persistent
  (@uid, @parent, pos) ->
    super ...
    @pos = pos or x: 0 y: 0 z: 0
