require! { 'gl-matrix': { vec3 } }

export gen-icosphere = (subdivisions = 0, radius = 1) ->
  g = 0.5 * (1 + Math.sqrt 5.0) # My precious!

  verts = []
    ..push [ -1,  g,  0 ]
    ..push [  1,  g,  0 ]
    ..push [ -1, -g,  0 ]
    ..push [  1, -g,  0 ]

    ..push [  0, -1,  g ]
    ..push [  0,  1,  g ]
    ..push [  0, -1, -g ]
    ..push [  0,  1, -g ]

    ..push [  g,  0, -1 ]
    ..push [  g,  0,  1 ]
    ..push [ -g,  0, -1 ]
    ..push [ -g,  0,  1 ]

  for vert in verts then vec3.normalize vert, vert

  tris = []
    ..push [  0, 11,  5 ]
    ..push [  0,  5,  1 ]
    ..push [  0,  1,  7 ]
    ..push [  0,  7, 10 ]
    ..push [  0, 10, 11 ]

    ..push [  1,  5,  9 ]
    ..push [  5, 11,  4 ]
    ..push [ 11, 10,  2 ]
    ..push [ 10,  7,  6 ]
    ..push [  7,  1,  8 ]

    ..push [  3,  9,  4 ]
    ..push [  3,  4,  2 ]
    ..push [  3,  2,  6 ]
    ..push [  3,  6,  8 ]
    ..push [  3,  8,  9 ]

    ..push [  4,  9,  5 ]
    ..push [  2,  4, 11 ]
    ..push [  6,  2, 10 ]
    ..push [  8,  6,  7 ]
    ..push [  9,  8,  1 ]

  cache = {}

  bisect = (id0, id1) ->
    return cache["#id0-#id1"] if "#id0-#id1" of cache
    out = [ 0, 0, 0 ]
    vec3.add out, verts[id0], verts[id1]
    vec3.scale out, out, 0.5
    vec3.normalize out, out
    verts.push out
    cache["#id0-#id1"] = verts.length - 1

  for til subdivisions
    out = []
    for tri in tris
      a = bisect tri[0], tri[1]
      b = bisect tri[1], tri[2]
      c = bisect tri[2], tri[0]
      out
        ..push [ tri[0], a, c ]
        ..push [ tri[1], b, a ]
        ..push [ tri[2], c, b ]
        ..push [      a, b, c ]
    tris = out

  for vert in verts then vec3.scale vert, vert, radius

  vertices: Array.prototype.concat.apply [], verts
  indices:  Array.prototype.concat.apply [], tris
