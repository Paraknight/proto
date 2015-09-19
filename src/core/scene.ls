require! {
  './entity.ls': { Entity, Synchronizable }:entity
}

export class Scene extends Entity implements Renderable, Tangible, Synchronizable, Persistent
  ->
    super null

    @renderables     = {}
    @tangibles       = {}
    @snychronizables = {}
    @persistents     = {}

  add-child: ->
    it = super ...
    return unless it?
    renderables[it.uid]     = it if it.renderables
    tangibles[it.uid]       = it if it.tangibles
    snychronizables[it.uid] = it if it.snychronizable
    persistents[it.uid]     = it if it.persistents
    @emit \entityspawned it
    it

  remove-child: ->
    it = super ...
    return unless it?
    delete renderables[it.uid]     if it.renderables
    delete tangibles[it.uid]       if it.tangibles
    delete snychronizables[it.uid] if it.snychronizable
    delete persistents[it.uid]     if it.persistents
    @emit \entitydespawned it
    it

  onsync = (event, data) !->
    return unless data.entity-uid?
    if data.entity-uid of @snychronizables
      @snychronizables[data.entity-uid].onsync event, data
      return

    if data.entity-uid is @uid
      switch event
      | \sync-all =>
        for ,syncable of @snychronizables then syncable.sync-all! unless syncable.is-slave
      | \despawn  => # TODO
      return

    if data.class? and data.class in entity
      new entity[data.class] data.entity-uid, @
        ..is-slave = true
        ..onsync event, data
        @add-child ..
