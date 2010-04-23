require 'java'

module Java3D
  include_package "javax.media.j3d"
  include_package "com.sun.j3d.utils.geometry"
  include_package "com.sun.j3d.utils.universe"
end

module Swing
  include_package "java.awt"
  include_package "javax.swing"
end

module Math
  include_package "java.lang.Math"
end

class ThreeDimensionalCube
  include Java3D
  include Swing
  include Math

  def self.create_canvas
    config = Java3D::SimpleUniverse.get_preferred_configuration
    canvas = Java3D::Canvas3D.new(config)

    scene = create_scene_graph
    scene.compile

    # SimpleUniverse is a Convenience Utility class
    universe = Java3D::SimpleUniverse.new(canvas)

    # This will move the ViewPlatform back a bit so the
    # objects in the scene can be viewed.
    universe.get_viewing_platform.set_nominal_viewing_transform
    universe.add_branch_graph(scene)

    canvas
  end

  def self.create_scene_graph
    # Create the root of the branch graph
    obj_root = Java3D::BranchGroup.new

    # rotate object has composited transformation matrix
    rotate = Java3D::Transform3D.new
    temp_rotate = Java3D::Transform3D.new

    rotate.rot_x(PI / 4.0)
    temp_rotate.rot_y(PI / 5.0)
    rotate.mul(temp_rotate)

    obj_rotate = Java3D::TransformGroup.new(rotate)

    # Create the transform group node and initialize it to the
    # identity.  Enable the TRANSFORM_WRITE capability so that
    # our behavior code can modify it at runtime.  Add it to the
    # root of the subgraph.
    obj_spin = Java3D::TransformGroup.new
    obj_spin.set_capability(Java3D::TransformGroup::ALLOW_TRANSFORM_WRITE)

    obj_root.add_child(obj_rotate)
    obj_rotate.add_child(obj_spin)

    # Create a simple shape leaf node, add it to the scene graph.
    # ColorCube is a Convenience Utility class
    obj_spin.add_child(Java3D::ColorCube.new(0.4))

    # Create a new Behavior object that will perform the desired
    # operation on the specified transform object and add it into
    # the scene graph.
    y_axis = Java3D::Transform3D.new
    rotation_alpha = Java3D::Alpha.new(-1, 4000)

    rotator =
      Java3D::RotationInterpolator.new(rotation_alpha, obj_spin, y_axis,
      0.0, PI * 2.0)

    # a bounding sphere specifies a region a behavior is active
    # create a sphere centered at the origin with radius of 1
    bounds = Java3D::BoundingSphere.new
    rotator.set_scheduling_bounds(bounds)
    obj_spin.add_child(rotator)

    obj_root
  end

  def show
    frame = Swing::JFrame.new("3D Cube")
    frame.layout = Swing::BorderLayout.new
    frame.add("Center", ThreeDimensionalCube.create_canvas)
    frame.default_close_operation = Swing::JFrame::EXIT_ON_CLOSE
    frame.set_size(256, 256)
    frame.visible = true
  end

end

cube = ThreeDimensionalCube.new
cube.show