class Box
	def initialize(position, rotation_speed)
	  @position = position
	  @rotation = P5::Vector.new
	  @rotation_speed = rotation_speed
	end
  
	def update
	  @rotation.x += @rotation_speed.x
	  @rotation.y += @rotation_speed.y
	end
  
	def display
	  P5.push()
	  P5.translate(@position.x, @position.y, @position.z)
	  P5.rotateX(@rotation.x)
	  P5.rotateY(@rotation.y)
	  P5.stroke(255)
	  P5.fill(0)
	  P5.box(80)
	  P5.pop()
	end
  end
  
  def setup
	P5.createCanvas(800, 600, P5.WEBGL)
	@boxes = []
	box_spacing = 200
	initial_x = -box_spacing
	3.times do
	  pos = P5::Vector.new(initial_x, 0, 0)
	  rotation_speed = P5::Vector.new(P5.random(0.005, 0.02), P5.random(0.005, 0.02), 0)
	  @boxes << Box.new(pos, rotation_speed)
	  initial_x += box_spacing
	end
  end
  
  def draw
	P5.background(0)
	@boxes.each do |box|
	  box.update
	  box.display
	end
  end