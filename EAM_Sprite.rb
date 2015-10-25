# TODO - Fix custom centre point

################################################################################
#	EASYANIMATION MODULE FOR SPRITE, extend only Sprites
################################################################################
module EAM_Sprite
	attr_accessor	:draggable
	attr_reader		:rotationOX
	attr_reader		:rotationOY
	attr_reader		:zoomOX
	attr_reader		:zoomOY
	attr_accessor	:circX
	attr_accessor	:circY
	attr_reader		:angle
	attr_reader		:radius
	
	alias :initialize_old :initialize
	def initialize(viewport=nil)
		viewport ? super(viewport) : super
		@draggable = false
		@rotationOX = nil
		@rotationOY = nil
		@zoomOX = nil
		@zoomOY = nil
		@circX = 0
		@circY = 0
		@angle = nil
		@radius = nil
		@transition ={}
		@animationRadius ={}
		@fade ={}
		@zoom ={}
		@rotate ={}
		@coloring ={}
		# Initializing position variables
		@transition["stX"] = 0
		@transition["stY"] = 0
		@transition["edX"] = 0
		@transition["edY"] = 0
		@transition["frame"] = 0
		@transition["totFrame"] = 0
		@transition["ease"] = nil
		@transition["stAngle"] = 0
		@transition["currAngle"] = 0
		@transition["XValue"] = 0
		@transition["YValue"] = 0
		@transition["callback"] = nil
		@transition["active"] = false
		# TODO - Add radius and centre point animation
		# Initializing opacity variables
		@fade["start"] = 0
		@fade["end"] = 0
		@fade["frame"] = 0
		@fade["totFrame"] = 0
		@fade["ease"] = nil
		@fade["opacityVal"] = 0
		@fade["callback"] = nil
		@fade["active"] = false
		# Initializing zoom variables
		@zoom["stX"] = 0
		@zoom["stY"] = 0
		@zoom["edX"] = 0
		@zoom["edY"] = 0
		@zoom["frame"] = 0
		@zoom["totFrame"] = 0
		@zoom["ease"] = nil
		@zoom["XValue"] = 0
		@zoom["YValue"] = 0
		@zoom["callback"] = nil
		@zoom["active"] = false
		# Initializing angle variables
		@rotate["start"] = 0
		@rotate["end"] = 0
		@rotate["frame"] = 0
		@rotate["totFrame"] = 0
		@rotate["ease"] = nil
		@rotate["angleVal"] = 0
		@rotate["callback"] = nil
		@rotate["active"] = false
		# Initializing color variables
		@coloring["start"] = 0
		@coloring["end"] = 0
		@coloring["frame"] = 0
		@coloring["totFrame"] = 0
		@coloring["ease"] = nil
		@coloring["colorVal"] = 0
		@coloring["callback"] = nil
		@coloring["active"] = false
		# Initializing radius animation variables
		@animationRadius["active"] = false
	end
	
	def setRotationPoint(x,y)
		@rotationOX = x
		@rotationOY = y
	end
	
	def setZoomPoint(x,y)
		@zoomOX = x
		@zoomOY = y
	end
	
	def setCircPoint(x,y)
		@circX = x
		@circY = y
	end
	
	def calculateAngle
		@angle = Curve.angle(@circX,@circY,self.x,self.y)
	end
	
	def calculateRadius
		@radius = Curve.radiusFromPoints(@circX,@circY,self.x,self.y)
	end
	
	def calculateCircCentre
		
	end
	
	def calculatePosition(angle=nil)
		angle = @angle if angle == nil
		echoln("Angle " + angle.to_s)
		self.x = Curve.radiusFromAngle(@circX,angle,@radius,true)
		self.y = Curve.radiusFromAngle(@circY,angle,@radius,false)
	end
	
	# Animate position (straight line)
	def move(x,y,frame,ease=:linear_tween,callback=nil)
		@transition["stX"] = self.x
		@transition["stY"] = self.y
		@transition["edX"] = x
		@transition["edY"] = y
		@transition["frame"] = 0
		@transition["totFrame"] = frame
		@transition["ease"] = Ease.method(ease)
		@transition["XValue"] = self.x
		@transition["YValue"] = self.y
		@transition["callback"] = callback ? EAM_Callback.method(callback) : nil
		@transition["active"] = true
		@transition["type"] = "linear"
	end
	
	# Animate position (curve)
	def curveMove(angle,frame,ease=:linear_tween,callback=nil)
		calculateAngle
		calculateRadius
		@transition["stAngle"] = @angle
		@transition["edAngle"] = angle
		@transition["ease"] = Ease.method(ease)
		@transition["currAngle"] = @angle
		@transition["frame"] = 0
		@transition["totFrame"] = frame
		@transition["callback"] = callback ? EAM_Callback.method(callback) : nil
		@transition["active"] = true
		@transition["type"] = "curve"
		# echoln("Start: " + @transition["stAngle"].to_s + " End: " + @transition["edAngle"].to_s)
	end
	# NB: 'move' and 'curveMove' cannot be played at the same time
	
	def animateRadius(length,frame,ease=:linear_tween,callback=nil)
		calculateRadius
		@animationRadius["start"] = @radius
		@animationRadius["end"] = length
		@animationRadius["ease"] = Ease.method(ease)
		@animationRadius["frame"] = 0
		@animationRadius["totFrame"] = frame
		@animationRadius["callback"] = callback ? EAM_Callback.method(callback) : nil
		@animationRadius["active"] = true
	end
	
	# Animate opacity
	def fade(opacity,frame,ease=:linear_tween,callback=nil)
		@fade["start"] = self.opacity
		@fade["end"] = opacity
		@fade["frame"] = 0
		@fade["totFrame"] = frame
		@fade["ease"] = Ease.method(ease)
		@fade["opacityVal"] = self.opacity
		@fade["callback"] = callback ? EAM_Callback.method(callback) : nil
		@fade["active"] = true
	end
	
	# Animate zoom
	def zoom(x,y,frame,ease=:linear_tween,callback=nil)
		@zoom["stX"] = self.zoom_x
		@zoom["stY"] = self.zoom_y
		@zoom["edX"] = x
		@zoom["edY"] = y
		@zoom["frame"] = 0
		@zoom["totFrame"] = frame
		@zoom["ease"] = Ease.method(ease)
		@zoom["XValue"] = self.zoom_x
		@zoom["YValue"] = self.zoom_y
		@zoom["callback"] = callback ? EAM_Callback.method(callback) : nil
		@zoom["active"] = true
	end
	
	# Animate rotation
	def rotate(angle,frame,ease=:linear_tween,callback=nil)
		@rotate["start"] = self.angle
		@rotate["end"] = angle
		@rotate["frame"] = 0
		@rotate["totFrame"] = frame
		@rotate["ease"] = Ease.method(ease)
		@rotate["angleVal"] = self.angle
		@rotate["callback"] = callback ? EAM_Callback.method(callback) : nil
		@rotate["active"] = true
	end
	
	# Animate color blending
	def coloring(mColor,frame,ease=:linear_tween,callback=nil)
		@coloring["start"] = self.color.clone
		@coloring["end"] = mColor
		@coloring["frame"] = 0
		@coloring["totFrame"] = frame
		@coloring["ease"] = Ease.method(ease)
		@coloring["colorVal"] = self.color.clone
		@coloring["callback"] = callback ? EAM_Callback.method(callback) : nil
		@coloring["active"] = true
	end
	
	# alias :update_old :update
	def update
		# update_old
		drag_xy if @draggable
		if @transition["active"]
			@transition["frame"] += 1
			if @transition["type"] == "linear"
				@transition["XValue"] = @transition["ease"].call(@transition["frame"], @transition["stX"], @transition["edX"]-@transition["stX"], @transition["totFrame"])
				@transition["YValue"] = @transition["ease"].call(@transition["frame"], @transition["stY"], @transition["edY"]-@transition["stY"], @transition["totFrame"])
				
				self.x = @transition["XValue"].round
				self.y = @transition["YValue"].round
				if @transition["frame"] >= @transition["totFrame"]
					@transition["active"] = false
					self.x = @transition["edX"]
					self.y = @transition["edY"]
					@transition["callback"].call(self,:move) if @transition["callback"]
				end
			elsif @transition["type"] == "curve"
				@transition["currAngle"] = @transition["ease"].call(@transition["frame"], @transition["stAngle"], @transition["edAngle"]-@transition["stAngle"], @transition["totFrame"])
				
				calculatePosition(@transition["currAngle"])
				
				#self.x = @transition["XValue"].round
				#self.y = @transition["YValue"].round
				if @transition["frame"] >= @transition["totFrame"]
					@transition["active"] = false
					@angle = @transition["end"]
					calculatePosition
					@transition["callback"].call(self,:move) if @transition["callback"]
				end
			end
		end
		if @animationRadius["active"]
			@animationRadius["frame"] += 1
			@radius = @animationRadius["ease"].call(@animationRadius["frame"], @animationRadius["start"], @animationRadius["end"]-@animationRadius["start"], @animationRadius["totFrame"])
			if @animationRadius["frame"] >= @animationRadius["totFrame"]
				@animationRadius["active"] = false
				@radius = @animationRadius["end"]
				end
			calculatePosition
		end
		if @fade["active"]
			@fade["frame"] += 1
			@fade["opacityVal"] = @fade["ease"].call(@fade["frame"], @fade["start"], @fade["end"]-@fade["start"], @fade["totFrame"])
			self.opacity = @fade["opacityVal"].round
			if @fade["frame"] >= @fade["totFrame"]
				@fade["active"] = false
				self.opacity = @fade["end"]
				@fade["callback"].call(self,:fade) if @fade["callback"]
			end
		end
		if @zoom["active"]
			@zoom["frame"] += 1
			@zoom["XValue"] = @zoom["ease"].call(@zoom["frame"], @zoom["stX"], @zoom["edX"]-@zoom["stX"], @zoom["totFrame"])
			@zoom["YValue"] = @zoom["ease"].call(@zoom["frame"], @zoom["stY"], @zoom["edY"]-@zoom["stY"], @zoom["totFrame"])
			if !@zoomOX.nil?
				defOX = self.ox
				self.ox = @zoomOX
				echo(@zoom["frame"].to_s + " " + @zoomOX.to_s + " ")
			end
			if !@zoomOY.nil?
				defOY = self.oy
				self.oy = @zoomOY
				#echoln (@zoomOY.to_s)
			end
			self.zoom_x = @zoom["XValue"]
			self.zoom_y = @zoom["YValue"]
			self.ox = defOX if !@zoomOX.nil?
			self.oy = defOY if !@zoomOY.nil?
			#echoln("Frame: " + @zoom["frame"].to_s + " " + @zoom["XValue"].to_s + " " + @zoom["YValue"].to_s)
			if @zoom["frame"] >= @zoom["totFrame"]
				@zoom["active"] = false
				self.zoom_x = @zoom["edX"]
				self.zoom_y = @zoom["edY"]
				@zoom["callback"].call(self,:zoom) if @zoom["callback"]
			end
		end
		if @rotate["active"]
			@rotate["frame"] += 1
			@rotate["rotateVal"] = validAngle(@rotate["ease"].call(@rotate["frame"], @rotate["start"], @rotate["end"]-@rotate["start"], @rotate["totFrame"]))
			if !@rotationOX.nil?
				defOX = self.ox
				self.ox = @rotationOX
			end
			if !@rotationOY.nil?
				defOY = self.oy
				self.oy = @rotationOY
			end
			self.angle = @rotate["rotateVal"].round
			self.ox = defOX if !@rotationOX.nil?
			self.oy = defOY if !@rotationOY.nil?
			if @rotate["frame"] >= @rotate["totFrame"]
				@rotate["active"] = false
				self.angle = @rotate["end"]
				@rotate["callback"].call(self,:rotate) if @rotate["callback"]
			end
		end
		if @coloring["active"]
			@coloring["frame"] += 1
			@coloring["colorVal"].red = @coloring["ease"].call(@coloring["frame"], @coloring["start"].red, @coloring["end"].red-@coloring["start"].red, @coloring["totFrame"]) if @coloring["start"].red != @coloring["end"].red
			@coloring["colorVal"].green = @coloring["ease"].call(@coloring["frame"], @coloring["start"].green, @coloring["end"].green-@coloring["start"].green, @coloring["totFrame"]) if @coloring["start"].green != @coloring["end"].green
			@coloring["colorVal"].blue = @coloring["ease"].call(@coloring["frame"], @coloring["start"].blue, @coloring["end"].blue-@coloring["start"].blue, @coloring["totFrame"]) if @coloring["start"].blue != @coloring["end"].blue
			@coloring["colorVal"].alpha = @coloring["ease"].call(@coloring["frame"], @coloring["start"].alpha, @coloring["end"].alpha-@coloring["start"].alpha, @coloring["totFrame"]) if @coloring["start"].alpha != @coloring["end"].alpha
			self.color = @coloring["colorVal"]
			if @coloring["frame"] >= @coloring["totFrame"]
				@coloring["active"] = false
				self.color = @coloring["end"]
				@coloring["callback"].call(self,:coloring) if @coloring["callback"]
			end
		end
	end
	
	def isTransition?
		return @transition["active"]
	end
	
	def isFade?
		return @fade["active"]
	end
	
	def isRotate?
		return @rotate["active"]
	end
	
	def isZoom?
		return @zoom["active"]
	end
	
	def isColor?
		return @coloring["active"]
	end
	
	def isRadius?
		return @animationRadius["active"]
	end
	
	def isAnimating?
		return isTransition? || isFade? || isRotate? || isZoom? || isColor? || isRadius?
	end
	
	# Used to calculate a valid angle
	def validAngle(angle)
		angle = angle - 360 if angle >= 360
		angle = validAngle(angle) if angle >= 360
		return angle
	end
	
	##############################################################################
	# MOUSE METHOD - Require Luka S.J.'s mouse module
	##############################################################################
	
	def leftClick?
		return false if defined?($mouse) != nil
		return $mouse.leftClick?(self)
	end
	
	def rightClick?
		return false if defined?($mouse) != nil
		return $mouse.rightClick?(self)
	end
	
	def leftPress?
		return false if defined?($mouse) != nil
		return $mouse.leftPress?(self)
	end
	
	def rightPress?
		return false if defined?($mouse) != nil
		return $mouse.rightPress?(self)
	end
	
	def over?
		return false if defined?($mouse) != nil
		return $mouse.over?(self)
	end
	
	def overPixel?
		return false if defined?($mouse) != nil
		return $mouse.overPixel?(self)
	end
	
	def drag_x(limit_x=nil,limit_width=nil)
		return if defined?($mouse) != nil
		$mouse.drag_x(self,limit_x,limit_width)
	end
	
	def drag_x(limit_y=nil,limit_height=nil)
		return if defined?($mouse) != nil
		$mouse.drag_y(self,limit_y,limit_height)
	end
	
	def drag_xy(limit_x=nil,limit_y=nil,limit_width=nil,limit_height=nil)
		return if defined?($mouse) != nil
		$mouse.drag_xy(self,limit_x,limit_y,limit_width,limit_height)
	end
end
