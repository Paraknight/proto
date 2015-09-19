require! {
  './scene.ls': { Scene }
  '../net/webrtc.ls': { PeerNetwork }
  '../gfx/renderer.ls': { Renderer }
}

export class Game
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


    renderer = new Renderer!

    window.request-animation-frame render = !->
      window.request-animation-frame render
      render.render!

    scene = new Scene
      ..sync = sync
      ..on \entityspawned !->
        it.sync = sync if it.synchronizable
      ..on \entitydespawned !->
