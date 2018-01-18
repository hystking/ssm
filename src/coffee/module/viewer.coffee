THREE = require "three"

TAU = Math.PI * 2

SHARI_SIZE =
  x: 1
  y: 1
  z: 2

NETA_SIZE =
  x: 1.2
  y: .4
  z: 2.2

SARA_SIZE =
  radius: 3

getCamera = (canvas) ->
  new THREE.PerspectiveCamera 75, canvas.offsetWidth / canvas.offsetHeight, .1, 1000

getSushi = (neta, shari) ->
  sushi = new THREE.Object3D
  sushi.add neta
  sushi.add shari
  neta.position.set 0, SHARI_SIZE.y*.5, 0
  return sushi

module.exports = class Viewer
  constructor: ({canvas, netaCanvas, shariCanvas, saraCanvas}) ->
    @renderer = new THREE.WebGLRenderer {canvas, alpha: yes}
    @scene = new THREE.Scene
    @camera = getCamera canvas

    # props
    @cameraOrbitRadius = 5
    @cameraOrbitAltitude = 2
    @cameraLookAtTarget = new THREE.Vector3 0, 0, 0

    # scene

    sunLight = new THREE.DirectionalLight 0xffffff, .1
    sunLight.position.set 1, 2, 3
    @scene.add sunLight

    ambientLight = new THREE.AmbientLight 0xeeeeee
    @scene.add ambientLight

    shariTexture = new THREE.Texture shariCanvas
    shariTexture.needsUpdate = yes
    shariGeometry = new THREE.BoxGeometry SHARI_SIZE.x, SHARI_SIZE.y, SHARI_SIZE.z
    shariMaterial = new THREE.MeshPhongMaterial
      map: shariTexture
      shading: THREE.FlatShading
      shininess: 0
    shari1 = new THREE.Mesh shariGeometry, shariMaterial
    shari2 = shari1.clone()

    netaTexture = new THREE.Texture netaCanvas
    netaTexture.needsUpdate = yes
    netaGeometry = new THREE.BoxGeometry NETA_SIZE.x, NETA_SIZE.y, NETA_SIZE.z
    netaMaterial = new THREE.MeshPhongMaterial
      map: netaTexture
      shading: THREE.FlatShading
      shininess: 0
    neta1 = new THREE.Mesh netaGeometry, netaMaterial
    neta2 = neta1.clone()

    saraTexture = new THREE.Texture saraCanvas
    saraTexture.needsUpdate = yes
    saraGeometry = new THREE.CircleGeometry SARA_SIZE.radius
    saraMaterial = new THREE.MeshPhongMaterial
      map: saraTexture
      shading: THREE.FlatShading
      shininess: 0
    sara = new THREE.Mesh saraGeometry, saraMaterial
    sara.rotation.set -TAU/4, 0, 0
    sara.position.set 0, -SHARI_SIZE.y/2, 0
    @scene.add sara

    sushi1 = getSushi neta1, shari1
    sushi2 = getSushi neta2, shari2
    sushi1.position.set .7, 0, 0
    sushi2.position.set -.7, 0, 0
    @scene.add sushi1
    @scene.add sushi2
    
  update: (time) ->
    angle = time * TAU * .25
    @camera.position.set(
      @cameraOrbitRadius * Math.cos angle
      @cameraOrbitAltitude
      @cameraOrbitRadius * Math.sin angle
    )
    @camera.lookAt @cameraLookAtTarget

  render: ->
    @renderer.render @scene, @camera
