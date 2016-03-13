################################################################################
#	EASYANIMATION MODULE FOR VIEWPORT, extend only Viewports
#
# Version 1.1 (Build 2)
# 13/103/16
# Scripter: Fuji
################################################################################
module EAM_Viewport
	attr_accessor	:circX
	attr_accessor	:circY
	attr_reader		:cAngle
	attr_reader		:radius
	
	alias :initialize_old :initialize
	def initialize(x,y=nil,width=nil,height=nil)
		if y.nil? && width.nil? && height.nil?
			super(x)
		elsif x.nil? || y.nil? || width.nil? || height.nil?
			raise "Params not valid"
		else
			super(x,y,width,height)
		end
		@circX = 0
		@circY = 0
		@cAngle = nil
		@radius = nil
		@transition ={}
		@animationRadius ={}
		@transitionCirc ={}
		@coloring ={}
		@toning ={}
		# Initializing position variables
		@transition["active"] = false
		@fade["active"] = false
		# Initializing zoom variables
		@zoom["active"] = false
		# Initializing angle variables
		@rotate["active"] = false
		# Initializing color variables
		@coloring["active"] = false
		# Initializing radius animation variables
		@animationRadius["active"] = false
		# Initializing circumference centre animation variables
		@transitionCirc["active"] = false
		# Initializing tone variables
		@toning["active"] = false
	end
	
	def setCircPoint(x,y)
		@circX = x
		@circY = y
	end
	
	def calculateAngle
		@cAngle = Curve.angle(@circX,@circY,self.rect.x,self.rect.y)
	end
	
	def calculateRadius
		@radius = Curve.radiusFromPoints(@circX,@circY,self.rect.x,self.rect.y)
	end
	
	def calculateCircCentre
		@circX = self.rect.x - @radius * Math.cos(@cAngle)
		@circY = self.rect.y - @radius * Math.sin(@cAngle)
	end
	
	def calculatePosition(angle=nil)
		angle = @cAngle if angle == nil
		echoln("Angle " + angle.to_s)
		self.rect.x = Curve.circPoint(@circX,angle,@radius,true)
		self.rect.y = Curve.circPoint(@circY,angle,@radius,false)
	end
	
	# Animate position (straight line)
	def move(x,y,frame,ease=:linear_tween,callback=nil)
		@transition["stX"] = self.rect.x
		@transition["stY"] = self.rect.y
		@transition["edX"] = x
		@transition["edY"] = y
		@transition["frame"] = 0
		@transition["totFrame"] = frame
		@transition["ease"] = Ease.method(ease)
		#@transition["XValue"] = self.rect.x
		#@transition["YValue"] = self.rect.y
		@transition["callback"] = callback
		@transition["active"] = true
		@transition["type"] = "linear"
	end
	
	# Animate position (curve)
	def curveMove(angle,frame,ease=:linear_tween,callback=nil)
		calculateAngle
		calculateRadius
		@transition["stAngle"] = @cAngle
		@transition["edAngle"] = angle
		@transition["ease"] = Ease.method(ease)
		@transition["currAngle"] = @cAngle
		@transition["frame"] = 0
		@transition["totFrame"] = frame
		@transition["callback"] = callback
		@transition["active"] = true
		@transition["type"] = "curve"
		# echoln("Start: " + @transition["stAngle"].to_s + " End: " + @transition["edAngle"].to_s)
	end
	# NB: 'move' and 'curveMove' cannot be played at the same time
	
	def moveCirc(cX,cY,frame,ease=:linear_tween,callback=nil)
		calculateCircCentre if !@circX && !@circY
		@transitionCirc["stX"] = @circX
		@transitionCirc["stY"] = @circY
		@transitionCirc["edX"] = cX
		@transitionCirc["edY"] = cY
		@transitionCirc["ease"] = Ease.method(ease)
		@transitionCirc["frame"] = 0
		@transitionCirc["totFrame"] = frame
		@transitionCirc["callback"] = callback
		@transitionCirc["active"] = true
	end
	
	def animateRadius(length,frame,ease=:linear_tween,callback=nil)
		calculateRadius
		@animationRadius["start"] = @radius
		@animationRadius["end"] = length
		@animationRadius["ease"] = Ease.method(ease)
		@animationRadius["frame"] = 0
		@animationRadius["totFrame"] = frame
		@animationRadius["callback"] = callback
		@animationRadius["active"] = true
	end
	
	# Animate color blending
	def coloring(mColor,frame,ease=:linear_tween,callback=nil)
		@coloring["start"] = self.color.clone
		@coloring["end"] = mColor
		@coloring["frame"] = 0
		@coloring["totFrame"] = frame
		@coloring["ease"] = Ease.method(ease)
		@coloring["color"] = Color.new(0,0,0)
		@coloring["callback"] = callback
		@coloring["active"] = true
	end
	
	# Animate tone
	def tone(mTone,frame,ease=:linear_tween,callback=nil)
		@toning["start"] = self.tone.clone
		@toning["end"] = mTone
		@toning["frame"] = 0
		@toning["totFrame"] = frame
		@toning["ease"] = Ease.method(ease)
		@toning["color"] = Tone.new(0,0,0)
		@toning["callback"] = callback
		@toning["active"] = true
	end
	
	def waitAnimation
		while isAnimating?
			update
			Graphics.update
		end
	end
	
	# alias :update_old :update
###############################################################################
##### UPDATE METHOD #####
###############################################################################
	def update
		# update_old
		needCalculatePosition = false
		calculatePositionParam = nil
		if @transition["active"]
			@transition["frame"] += 1
			if @transition["type"] == "linear"
				xx = @transition["ease"].call(@transition["frame"], @transition["stX"], @transition["edX"]-@transition["stX"], @transition["totFrame"])
				yy = @transition["ease"].call(@transition["frame"], @transition["stY"], @transition["edY"]-@transition["stY"], @transition["totFrame"])
				
				self.rect.x = xx.round
				self.rect.y = yy.round
				if @transition["frame"] >= @transition["totFrame"]
					@transition["active"] = false
					self.rect.x = @transition["edX"]
					self.rect.y = @transition["edY"]
					@transition["callback"].call(self,:move) if @transition["callback"]
				end
			elsif @transition["type"] == "curve"
				angle = @transition["ease"].call(@transition["frame"], @transition["stAngle"], @transition["edAngle"]-@transition["stAngle"], @transition["totFrame"])
				needCalculatePosition = true
				calculatePositionParam = angle
				
				#calculatePosition(@transition["currAngle"])
				
				#self.rect.x = @transition["XValue"].round
				#self.rect.y = @transition["YValue"].round
				if @transition["frame"] >= @transition["totFrame"]
					@transition["active"] = false
					@cAngle = @transition["edAngle"]
					calculatePosition
					calculatePositionParam = @cAngle
					@transition["callback"].call(self,:moveCurve) if @transition["callback"]
				end
			end
		end
		if @animationRadius["active"]
			@animationRadius["frame"] += 1
			@radius = @animationRadius["ease"].call(@animationRadius["frame"], @animationRadius["start"], @animationRadius["end"]-@animationRadius["start"], @animationRadius["totFrame"])
			needCalculatePosition = true
			if @animationRadius["frame"] >= @animationRadius["totFrame"]
				@animationRadius["active"] = false
				@radius = @animationRadius["end"]
				calculatePosition
				@animationRadius["callback"].call(self,:animateRadius) if @animationRadius["callback"]
			end
		end
		if @transitionCirc["active"]
			@transitionCirc["frame"] += 1
			cX = @transitionCirc["ease"].call(@transitionCirc["frame"], @transitionCirc["stX"], @transitionCirc["edX"]-@transitionCirc["stX"], @transitionCirc["totFrame"])
			cY = @transitionCirc["ease"].call(@transitionCirc["frame"], @transitionCirc["stY"], @transitionCirc["edY"]-@transitionCirc["stY"], @transitionCirc["totFrame"])
			@circX = cX.round
			@circY = cY.round
			needCalculatePosition = true
			if @transitionCirc["frame"] >= @transitionCirc["totFrame"]
				@transitionCirc["active"] = false
				@circX = @transitionCirc["edX"]
				@circY = @transitionCirc["edY"]
				calculatePosition
				@transitionCirc["callback"].call(self,:moveCirc) if @transitionCirc["callback"]
			end
		end
		# Calculate the position just once
		calculatePosition(calculatePositionParam) if needCalculatePosition 
		# Animate color
		if @coloring["active"]
			@coloring["frame"] += 1
			@coloring["color"].red = @coloring["ease"].call(@coloring["frame"], @coloring["start"].red, @coloring["end"].red-@coloring["start"].red, @coloring["totFrame"]) if @coloring["start"].red != @coloring["end"].red
			@coloring["color"].green = @coloring["ease"].call(@coloring["frame"], @coloring["start"].green, @coloring["end"].green-@coloring["start"].green, @coloring["totFrame"]) if @coloring["start"].green != @coloring["end"].green
			@coloring["color"].blue = @coloring["ease"].call(@coloring["frame"], @coloring["start"].blue, @coloring["end"].blue-@coloring["start"].blue, @coloring["totFrame"]) if @coloring["start"].blue != @coloring["end"].blue
			@coloring["color"].alpha = @coloring["ease"].call(@coloring["frame"], @coloring["start"].alpha, @coloring["end"].alpha-@coloring["start"].alpha, @coloring["totFrame"]) if @coloring["start"].alpha != @coloring["end"].alpha
			self.color = @coloring["color"]
			if @coloring["frame"] >= @coloring["totFrame"]
				@coloring["active"] = false
				self.color = @coloring["end"]
				@coloring["callback"].call(self,:coloring) if @coloring["callback"]
			end
		end
		# Animate tone
		if @toning["active"]
			@toning["frame"] += 1
			@toning["color"].red = @toning["ease"].call(@toning["frame"], @toning["start"].red, @toning["end"].red-@toning["start"].red, @toning["totFrame"]) if @toning["start"].red != @toning["end"].red
			@toning["color"].green = @toning["ease"].call(@toning["frame"], @toning["start"].green, @toning["end"].green-@toning["start"].green, @toning["totFrame"]) if @toning["start"].green != @toning["end"].green
			@toning["color"].blue = @toning["ease"].call(@toning["frame"], @toning["start"].blue, @toning["end"].blue-@toning["start"].blue, @toning["totFrame"]) if @toning["start"].blue != @toning["end"].blue
			@toning["color"].grey = @toning["ease"].call(@toning["frame"], @toning["start"].grey, @toning["end"].grey-@toning["start"].grey, @toning["totFrame"]) if @toning["start"].grey != @toning["end"].grey
			self.tone = @toning["color"]
			if @toning["frame"] >= @toning["totFrame"]
				@toning["active"] = false
				self.tone = @toning["end"]
				@toning["callback"].call(self,:toning) if @toning["callback"]
			end
		end
	end
	
	def isTransition?
		return @transition["active"]
	end
	
	def isColor?
		return @coloring["active"]
	end
	
	def isTone?
		return @toning["active"]
	end
	
	def isAnimatingRadius?
		return @animationRadius["active"]
	end
	
	def isAnimatingCirc?
		return @transitionCirc["active"]
	end
	def isAnimating?
		return isTransition? || isColor? || isAnimatingRadius? || isAnimatingCirc? || isTone?
	end
end