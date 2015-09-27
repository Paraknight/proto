require! {
  'core/scene.ls': { Scene }
  'net/webrtc.ls': { PeerNetwork }
  'gfx/renderer.ls': { WebGLRenderer }
}

export class Game
  const TICK_INTERVAL_MS = 1000ms / 60 # i.e. 60 TPS

  (config = {}) ->

    # TODO: Support both reliable and unreliable DataChannels
    peer-net = new PeerNetwork config.sig-serv
      ..on \connection (peer) !->
        console.log "Client: Peer #{peer.uid} connected"

        peer.on \message !->
          return unless it.event? and it.data?
          it.data.peer-uid = peer.uid
          scene.on-sync it.event, it.data

        peer.send \greeting "Hi from #{peer-net.own-uid}!"

      ..on \uid (uid) !->
        @signal \join config.default-room

      ..on \disconnection (peer) !->
        console.log "Client: Peer #{peer.uid} disconnected"
        # TODO: Deal with all the entities that this peer was master of

    sync = (event, data) !->
      data.entity-uid = @uid
      data.class = @@display-name
      # TODO: Differentiate between broadcast and roomcast
      for ,peer of peer-net.peers
        peer.send event, data

    @scene = new Scene
      ..sync = sync
      ..on \entityspawned !->
        it.sync = sync if it.synchronizable
        it.ticker?.init!
        it.renderer?.init renderer.gl
      ..on \entitydespawned !->


    self = @
    window.set-timeout tick = do ->
      time = Date.now!
      !->
        # FIXME: Chrome throttles the interval down to 1s on inactive tabs.
        window.set-timeout tick, TICK_INTERVAL_MS
        now = Date.now!
        self.scene.ticker.tick now - time
        time := now
    , TICK_INTERVAL_MS


    renderer = new WebGLRenderer @

    fly-cam = new (require 'core/entities/flycam.ls' .FlyCamera)!

    renderer
      ..camera = fly-cam.camera
      ..init!

    window.request-animation-frame render = !->
      window.request-animation-frame render
      renderer.render!


    @scene.add-child fly-cam
    #@scene.add-child new (require 'core/entities/square.ls' .Square)!
    @scene.add-child new (require 'core/entities/planet.ls' .Planet)!
