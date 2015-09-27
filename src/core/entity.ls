require! {
  events: { EventEmitter }
  'node-uuid': uuid
  'gl-matrix': { mat4 }
}

export class Entity extends EventEmitter
  (@uid = uuid.v4!) ->
    @transform = mat4.create!
    @children = []

  add-child: ->
    return unless it?
    @children.push it
    it.parent = @
    @emit \childadded it
    it

  remove-child: ->
    for child, index in @children
      if child is it
        @children.splice index, 1
        it.parent = null
        @emit \childremoved it
        return it

  tick: (delta) !-> for child in @children then child.tick gl


export class EntityRenderer
  (@entity) ->
  init: (gl) !-> for child in @entity.children then child.renderer?.init gl
  render: (gl, matrices) !-> for child in @entity.children then child.renderer?.render gl, matrices


export class EntityTicker
  (@entity) ->
  init: !-> for child in @entity.children then child.ticker?.init!
  tick: (delta) !-> for child in @entity.children then child.ticker?.tick delta


export Tangible = {}
Object.define-property Tangible, \tangible value: true writable: false enumerable: true

export Synchronizable = {}
Object.define-property Synchronizable, \synchronizable value: true writable: false enumerable: true
Synchronizable.sync = (event, data) ->
Synchronizable.sync-all = ->
Synchronizable.on-sync = (event, data) ->

export Persistent = {}
Object.define-property Persistent, \persistent value: true writable: false enumerable: true
