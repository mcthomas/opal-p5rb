module P5

  def self.mult(obj)
    obj.mult(:mult) do |*args|
      P5::Mult.new(*args).to_js(self)
    end
  end

  def self.method_missing(name, *args)
    %x{
      obj = window[name];
      if (typeof(obj) == 'function') {
        return window[name].apply(window, args);
      } else {
        return window[name];
      }
    }
  end

  # EVENT FUNCTIONS (REQUIRED)

  %x{
    window.preload = function() { Opal.top.$preload(); };
    window.setup = function() { Opal.top.$setup(); };
    window.draw = function() { Opal.top.$draw(); };
    window.setMoveThreshold = function() { Opal.top.$setMoveThreshold(); };
    window.setShakeThreshold = function() { Opal.top.$setShakeThreshold(); };
    window.deviceMoved = function() { Opal.top.$deviceMoved(); };
    window.deviceTurned = function() { Opal.top.$deviceTurned(); };
    window.deviceShaken = function() { Opal.top.$deviceShaken(); };
    window.keyPressed = function() { Opal.top.$keyPressed(); };
    window.keyReleased = function() { Opal.top.$keyReleased(); };
    window.keyTyped = function() { Opal.top.$keyTyped(); };
    window.keyIsDown = function() { return Opal.top.$keyIsDown(); };
    window.mouseMoved = function() { Opal.top.$mouseMoved(); };
    window.mouseDragged = function() { Opal.top.$mouseDragged(); };
    window.mousePressed = function() { Opal.top.$mousePressed(); };
    window.mouseReleased = function() { Opal.top.$mouseReleased(); };
    window.mouseClicked = function() { Opal.top.$mouseClicked(); };
    window.doubleClicked = function() { Opal.top.$doubleClicked(); };
    window.mouseWheel = function(event) { Opal.top.$mouseWheel(event); };
    window.requestPointerLock = function() { Opal.top.$requestPointerLock(); };
    window.exitPointerLock = function() { Opal.top.$exitPointerLock(); };    
    window.touchStarted = function() { Opal.top.$touchStarted(); };    
    window.touchMoved = function() { Opal.top.$touchMoved(); };    
    window.touchEnded = function() { Opal.top.$touchEnded(); };  
  }

  # RUBY TO P5 OBJECT MAPPINGS (REQUIRED FOR P5 METHODS THAT RETURN P5 OBJECT INSTANCES)

  class Vector
    attr_accessor :x, :y, :z
  
    def initialize(x = 0, y = 0, z = 0)
      @x = x
      @y = y
      @z = z
    end
  
    # Instance method that calls the corresponding p5.js method
    def call_p5_method(method_name, *args)
      js_method = "p5.`#{method_name}`"
      js_args = args.empty? ? '' : args.join(', ')
      "#{to_js}.#{js_method}(#{js_args})"
    end
  
    def to_js
      "p5.createVector(#{@x}, #{@y}, #{@z})"
    end
  
    # Instance methods
    def toString
      call_p5_method('str')
    end
  
    def set(x_or_vector, y = nil, z = nil)
      if x_or_vector.is_a?(Vector)
        @x = x_or_vector.x
        @y = x_or_vector.y
        @z = x_or_vector.z
      else
        @x = x_or_vector
        @y = y
        @z = z
      end
    end
  
    def copy
      call_p5_method('copy')
    end
  
    def add(*args)
      call_p5_method('add', *args)
    end
  
    def sub(*args)
      call_p5_method('sub', *args)
    end
  
    def mult(scalar_or_vector)
      call_p5_method('mult', scalar_or_vector)
    end
  
    def div(scalar_or_vector)
      call_p5_method('div', scalar_or_vector)
    end
  
    def mag
      call_p5_method('mag')
    end
  
    def magSq
      call_p5_method('magSq')
    end
  
    def dot(vector)
      call_p5_method('dot', vector.to_js)
    end
  
    def cross(vector)
      call_p5_method('cross', vector.to_js)
    end
  
    def dist(vector)
      call_p5_method('dist', vector.to_js)
    end
  
    def normalize
      call_p5_method('normalize')
    end
  
    def limit(max)
      call_p5_method('limit', max)
    end
  
    def setMag(len)
      call_p5_method('setMag', len)
    end
  
    def heading
      call_p5_method('heading')
    end
  
    def setHeading(angle)
      call_p5_method('setHeading', angle)
    end
  
    def rotate(angle)
      call_p5_method('rotate', angle)
    end
  
    def angleBetween(vector)
      call_p5_method('angleBetween', vector.to_js)
    end
  
    def lerp(target, amount)
      call_p5_method('lerp', target.to_js, amount)
    end
  
    def slerp(target, amount)
      call_p5_method('slerp', target.to_js, amount)
    end
  
    def reflect(normal)
      call_p5_method('reflect', normal.to_js)
    end
  
    def array
      call_p5_method('array')
    end
  
    def equals(vector)
      call_p5_method('equals', vector.to_js)
    end
  
    # Class methods
    class << self
      def fromAngle(angle)
        "p5.createVector.fromAngle(#{angle})"
      end
  
      def random2D
        "p5.createVector.random2D()"
      end
  
      def random3D
        "p5.createVector.random3D()"
      end
  
      def fromAngles(phi, theta)
        "p5.createVector.fromAngles(#{phi}, #{theta})"
      end
    end
  end
  

  class Color
    def initialize(pInst, vals = nil)
      @pInst = pInst
      @vals = vals
    end

    def to_js
      if @vals.nil?
        "new p5.Color(#{@pInst})"
      else
        "new p5.Color(#{@pInst}, #{@vals})"
      end
    end
  end

  class Font
    def initialize(pInst = nil)
      @pInst = pInst
    end

    def to_js
      if @pInst.nil?
        "new p5.Font()"
      else
        "new p5.Font(#{@pInst})"
      end
    end
  end

  class Renderer
    def initialize(elt, pInst = nil, isMainCanvas = nil)
      @elt = elt
      @pInst = pInst
      @isMainCanvas = isMainCanvas
    end

    def to_js
      if @pInst.nil?
        "new p5.Renderer(#{@elt})"
      elsif @isMainCanvas.nil?
        "new p5.Renderer(#{@elt}, #{@pInst})"
      else
        "new p5.Renderer(#{@elt}, #{@pInst}, #{@isMainCanvas})"
      end
    end
  end

  class Graphics
    def initialize(w, h, renderer, pInst = nil, canvas = nil)
      @w = w
      @h = h
      @renderer = renderer
      @pInst = pInst
      @canvas = canvas
    end

    def to_js
      if @pInst.nil?
        "new p5.Graphics(#{@w}, #{@h}, #{@renderer})"
      elsif @canvas.nil?
        "new p5.Graphics(#{@w}, #{@h}, #{@renderer}, #{@pInst})"
      else
        "new p5.Graphics(#{@w}, #{@h}, #{@renderer}, #{@pInst}, #{@canvas})"
      end
    end
  end

  class Video
    def initialize(src, callback = nil)
      @src = src
      @callback = callback
    end

    def to_js
      if @callback.nil?
        "createVideo(#{@src})"
      else
        "createVideo(#{@src}, #{@callback})"
      end

    end
  end

  class Audio
    def initialize(src, callback = nil)
      @src = src
      @callback = callback
    end
  
    def to_js
      if @callback.nil?
        "createAudio(#{@src})"
      else
        "createAudio(#{@src}, #{@callback})"
      end
    end
  end
  
  class Capture
    def initialize(type, callback = nil)
      @type = type
      @callback = callback
    end
  
    def to_js
      if @callback.nil?
        "createCapture(#{@type})"
      else
        "createCapture(#{@type}, #{@callback})"
      end
    end
  end
  
  class Framebuffer
    def initialize(options = nil)
      @options = options
    end
  
    def to_js
      if @options.nil?
        "createFramebuffer()"
      else
        "createFramebuffer(#{@options})"
      end
    end
  end
  
  class StringDict
    def initialize(key, value = nil)
      @key = key
      @value = value
    end
  
    def to_js
      if @value.nil?
        "createStringDict(#{@key})"
      else
        "createStringDict(#{@key}, #{@value})"
      end
    end
  end
  
  class NumberDict
    def initialize(key, value = nil)
      @key = key
      @value = value
    end
  
    def to_js
      if @value.nil?
        "createNumberDict(#{@key})"
      else
        "createNumberDict(#{@key}, #{@value})"
      end
    end
  end
  
  class Writer
    def initialize(name, extension = nil)
      @name = name
      @extension = extension
    end
  
    def to_js
      if @extension.nil?
        "createWriter(#{@name})"
      else
        "createWriter(#{@name}, #{@extension})"
      end
    end
  end  
  
  class ShaderToCreate
    def initialize(vertSrc, fragSrc)
      @vertSrc = vertSrc
      @fragSrc = fragSrc
    end
  
    def to_js
      "createShader(#{@vertSrc}, #{@fragSrc})"
    end
  end
  
  class Image
    def initialize(width, height)
      @width = width
      @height = height
    end
  
    def to_js
      "createImage(#{@width}, #{@height})"
    end
  end
  
  class Camera
    def to_js
      "createCamera()"
    end
  end
  
  class ShaderToLoad
    def initialize(vertFilename, fragFilename, callback = nil, errorCallback = nil)
      @vertFilename = vertFilename
      @fragFilename = fragFilename
      @callback = callback
      @errorCallback = errorCallback
    end
  
    def to_js
      if @callback.nil?
        "loadShader(#{@vertFilename}, #{@fragFilename})"
      elsif @errorCallback.nil?
        "loadShader(#{@vertFilename}, #{@fragFilename}, #{@callback})"
      else
        "loadShader(#{@vertFilename}, #{@fragFilename}, #{@callback}, #{@errorCallback})"
      end
    end
  end
  
  class Mult
    def initialize(*args)
      case args.size
      when 1
        @arg1 = args[0]
      when 2
        @arg1 = args[0]
        @arg2 = args[1]
      when 3
        @arg1 = args[0]
        @arg2 = args[1]
        @arg3 = args[2]
      end
    end
  
    def to_js
      if @arg2.nil?
        "mult(#{@arg1}"
      elsif @arg3.nil?
        "mult(#{@arg1}, #{@arg2})"
      else
        "mult(#{@arg1}, #{@arg2}, #{@arg3})"
      end
    end
  end
  
  class Element
    def initialize(tag, content = nil)
      @tag = tag
      @content = content
    end
  
    def to_js
      if @content.nil?
        "createElement(#{@tag})"
      else
        "createElement(#{@tag}, #{@content})"
      end
    end
  end
  
  class Img
    def initialize(src, alt, crossOrigin = nil, successCallback = nil)
      @src = src
      @alt = alt
      @crossOrigin = crossOrigin
      @successCallback = successCallback
    end
  
    def to_js
      if @successCallback.nil?
        if @crossOrigin.nil?
          "createImg(#{@src}, #{@alt})"
        else
          "createImg(#{@src}, #{@alt}, #{@crossOrigin})"
        end
      else
        "createImg(#{@src}, #{@alt}, #{@crossOrigin}, #{@successCallback})"
      end
    end
  end
  
  class Select
    def initialize(arg = nil)
      @arg = arg
    end
  
    def to_js
      if @arg.nil?
        "createSelect()"
      else
        "createSelect(#{@arg})"
      end
    end
  end
  
  class Input
    def initialize(arg1 = nil, arg2 = nil)
      @arg1 = arg1
      @arg2 = arg2
    end
  
    def to_js
      if @arg2.nil?
        "createInput(#{@arg1})"
      else
        "createInput(#{@arg1}, #{@arg2})"
      end
    end
  end
  
  class Slider
    def initialize(min, max, value = nil, step = nil)
      @min = min
      @max = max
      @value = value
      @step = step
    end
  
    def to_js
      if @value.nil?
        "createSlider(#{@min}, #{@max})"
      elsif @step.nil?
        "createSlider(#{@min}, #{@max}, #{@value})"
      else
        "createSlider(#{@min}, #{@max}, #{@value}, #{@step})"
      end
    end
  end
  
  class A
    def initialize(href, html, target = nil)
      @href = href
      @html = html
      @target = target
    end
  
    def to_js
      if @target.nil?
        "createA(#{@href}, #{@html})"
      else
        "createA(#{@href}, #{@html}, #{@target})"
      end
    end
  end
  
  class Checkbox
    def initialize(label = nil, value = nil)
      @label = label
      @value = value
    end
  
    def to_js
      if @label.nil?
        "createCheckbox()"
      elsif @value.nil?
        "createCheckbox(#{@label})"
      else
        "createCheckbox(#{@label}, #{@value})"
      end
    end
  end
  
  class Span
    def initialize(html = nil)
      @html = html
    end
  
    def to_js
      "createSpan(#{@html})"
    end
  end
  
  class ColorPicker
    def initialize(value = nil)
      @value = value
    end
  
    def to_js
      "createColorPicker(#{@value})"
    end
  end
  
  class Radio
    def initialize(arg1 = nil, arg2 = nil)
      @arg1 = arg1
      @arg2 = arg2
    end
  
    def to_js
      if @arg1.nil?
        "createRadio()"
      elsif @arg2.nil?
        "createRadio(#{@arg1})"
      else
        "createRadio(#{@arg1}, #{@arg2})"
      end
    end
  end
  
  class Button
    def initialize(label, value = nil)
      @label = label
      @value = value
    end
  
    def to_js
      if @value.nil?
        "createButton(#{@label})"
      else
        "createButton(#{@label}, #{@value})"
      end
    end
  end
  
  class FileInput
    def initialize(callback, multiple = nil)
      @callback = callback
      @multiple = multiple
    end
  
    def to_js
      if @multiple.nil?
        "createFileInput(#{@callback})"
      else
        "createFileInput(#{@callback}, #{@multiple})"
      end
    end
  end
  
  class Div
    def initialize(html = nil)
      @html = html
    end
  
    def to_js
      "createDiv(#{@html})"
    end
  end
  
  class P
    def initialize(html = nil)
      @html = html
    end
  
    def to_js
      "createP(#{@html})"
    end
  end
  
  class Canvas
    def initialize(w, h, renderer = nil, canvas = nil)
      @w = w
      @h = h
      @renderer = renderer
      @canvas = canvas
    end
  
    def to_js
      if @renderer.nil?
        "createCanvas(#{@w}, #{@h})"
      elsif @canvas.nil?
        "createCanvas(#{@w}, #{@h}, #{@renderer})"
      else
        "createCanvas(#{@w}, #{@h}, #{@renderer}, #{@canvas})"
      end
    end
  end

  # RUBY METHODS FOR THE RUBY TO P5 OBJECT MAPPINGS (REQUIRED FOR COMPATIBILITY TO RETURN P5 OBJECT INSTANCES)
  
  def createVector(x, y, z)
    P5::Vector.new(`x`, `y`, `z`)
  end
  
  def createShader(vertSrc, fragSrc)
    P5::ShaderToCreate.new(`vertSrc`, `fragSrc`)
  end
  
  def createImage(width, height)
    P5::Image.new(`width`, `height`)
  end
  
  def createCamera()
    P5::Camera.new
  end
  
  def loadShader(vertFilename, fragFilename, callback = nil, errorCallback = nil)
    if callback.nil?
      P5::ShaderToLoad.new(`vertFilename`, `fragFilename`)
    elsif errorCallback.nil?
      P5::ShaderToLoad.new(`vertFilename`, `fragFilename`, `callback`)
    else
      P5::ShaderToLoad.new(`vertFilename`, `fragFilename`, `callback`, `errorCallback`)
    end
  end
  
  def mult(*args)
    case args.size
    when 1
      P5::Mult.new(`args[0]`)
    when 2
      P5::Mult.new(`args[0]`, `args[1]`)
    when 3
      P5::Mult.new(`args[0]`, `args[1]`, `args[2]`)
    end
  end
  
  def createElement(tag, content = nil)
    P5::Element.new(`tag`, `content`)
  end
  
  def createImg(src, alt, crossOrigin = nil, successCallback = nil)
    if crossOrigin.nil?
      P5::Img.new(`src`, `alt`)
    elsif crossOrigin.nil?
      P5::Img.new(`src`, `alt`, `crossOrigin`, `successCallback`)
    end
  end
  
  def createSelect(arg)
      P5::Select.new(`arg`)
  end
  
  def createInput(value, type = nil)
      P5::Input.new(`value`, `type`)
  end
  
  def createSlider(min, max, value = nil, step = nil)
      P5::Slider.new(`min`, `max`, `value`, `step`)
  end
  
  def createA(href, html, target = nil)
      P5::A.new(`href`, `html`, `target`)
  end
  
  def createCheckbox(label, value = nil)
      P5::Checkbox.new(`label`, `value`)
  end
  
  def createSpan(html)
    if html.nil?
      P5::Span.new()
    else
      P5::Span.new(`html`)
    end  
  end
  
  def createColorPicker(value)
    P5::ColorPicker.new(`value`)
  end
  
  def createRadio(containerElement = nil, name = nil)
    if containerElement.nil?
      P5::Radio.new()
    elsif name.nil?
      P5::Radio.new(`containerElement`)
    else
      P5::Radio.new(`containerElement`, `name`)
    end
  end
  
  def createButton(label, value = nil)
    if value.nil?
      P5::Button.new(`label`)
    else
      P5::Button.new(`label`, `value`)
    end
  end
  
  def createFileInput(callback, multiple = nil)
    if multiple.nil?
      P5::FileInput.new(`callback`)
    else
      P5::FileInput.new(`callback`, `multiple`)
    end
  end
  
  def createDiv(html)
    if html.nil?
      P5::Div.new()
    else
      P5::Div.new(`html`)
    end  
  end
  
  def createP(html = nil)
    if html.nil?
      P5::P.new()
    else
      P5::P.new(`html`)
    end
  end
  
  def createCanvas(w, h, renderer = nil, canvas = nil)
    if renderer.nil?
      P5::Canvas.new(`w`, `h`)
    elsif canvas.nil?
      P5::Canvas.new(`w`, `h`, `renderer`)
    else
      P5::Canvas.new(`w`, `h`, `renderer`, `canvas`)
    end
  end  

  def createVideo(src, callback = nil)
    if callback.nil?
      P5::Video.new(`src`)
    else
      P5::Video.new(`src`, `callback`)
    end
  end

  def createAudio(src, callback = nil)
    if callback.nil?
      P5::Audio.new(`src`)
    else
      P5::Audio.new(`src`, `callback`)
    end
  end

  def createCapture(type, callback = nil)
    if callback.nil?
      P5::Capture.new(`type`)
    else
      P5::Capture.new(`type`, `callback`)
    end
  end

  def createGraphics(w, h, renderer, pInst = nil, canvas = nil)
    if pInst.nil?
      P5::Graphics.new(`w`, `h`, `renderer`)
    elsif canvas.nil?
      P5::Graphics.new(`w`, `h`, `renderer`, `pInst`)
    else
      P5::Graphics.new(`w`, `h`, `renderer`, `pInst`, `canvas`)
    end
  end

  def createFramebuffer(options = nil)
    if options.nil?
      P5::Framebuffer.new()
    else
      P5::Framebuffer.new(`options`)
    end
  end

  def createStringDict(key, value)
    if value.nil?
      P5::StringDict.new(`key`)
    else
      P5::StringDict.new(`key`, `value`)
    end
  end

  def createNumberDict(key, value)
    if value.nil?
      P5::NumerDict.new(`key`)
    else
      P5::NumerDict.new(`key`, `value`)
    end
  end

  def createWriter(name, extension = nil)
    if extension.nil?
      P5::Writer.new(`name`)
    else
      P5::Writer.new(`name`, `extension`)
    end
  end

end