@tool
extends EditorScenePostImport

func _post_import(scene):
	# Add physics bodies to all mesh instances in the scene
	_add_physics_to_meshes(scene, scene)
	return scene

func _add_physics_to_meshes(node: Node, root_scene: Node):
	# Process all children recursively
	for child in node.get_children():
		_add_physics_to_meshes(child, root_scene)
	
	# Check if this node is a MeshInstance3D
	if node is MeshInstance3D:
		var mesh_instance = node as MeshInstance3D
		
		# Skip if mesh is null
		if mesh_instance.mesh == null:
			return
		
		# Check if this MeshInstance3D already has a StaticBody3D parent or child
		if _has_physics_body(mesh_instance):
			return
		
		# Create StaticBody3D
		var static_body = StaticBody3D.new()
		static_body.name = mesh_instance.name + "_StaticBody"
		
		# Create CollisionShape3D
		var collision_shape = CollisionShape3D.new()
		collision_shape.name = mesh_instance.name + "_CollisionShape"
		
		# Generate collision shape from mesh
		var shape = _generate_collision_shape(mesh_instance.mesh)
		if shape != null:
			collision_shape.shape = shape
			
			# Add CollisionShape3D to StaticBody3D
			static_body.add_child(collision_shape)
			
			# Add StaticBody3D as a child of the MeshInstance3D
			mesh_instance.add_child(static_body)
			
			# Set owners after nodes are in the tree
			static_body.owner = root_scene
			collision_shape.owner = root_scene
			
			# No need to set transform since it's a child of the mesh instance
			# The collision will inherit the mesh's transform automatically
			
			print("Added physics body to: ", mesh_instance.name)

func _has_physics_body(mesh_instance: MeshInstance3D) -> bool:
	# Check if any child is already a physics body
	for child in mesh_instance.get_children():
		if child is RigidBody3D or child is StaticBody3D or child is CharacterBody3D:
			return true
	
	return false

func _generate_collision_shape(mesh: Mesh) -> Shape3D:
	# Try to create a trimesh collision shape (most accurate for static bodies)
	if mesh != null:
		# Create trimesh shape for complex geometry
		var trimesh_shape = mesh.create_trimesh_shape()
		if trimesh_shape != null:
			return trimesh_shape
		
		# Fallback to convex shape if trimesh fails
		var convex_shape = mesh.create_convex_shape()
		if convex_shape != null:
			return convex_shape
	
	return null
