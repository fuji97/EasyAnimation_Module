class Sprite_EAM < Sprite
	include EAM_Sprite
end

def testEAMSprite
	@EAM = Sprite_EAM.new
	@EAM.bitmap = Bitmap.new("Graphics/Pictures/ball00")	# Change it with the image path that you want to use
	@EAM.ox = @EAM.bitmap.width/2
	@EAM.oy = @EAM.bitmap.height/2
	@EAM.x = 112
	@EAM.y = 99
	@EAM.setCircPoint(93,78)
	@EAM.curveMove(1122,120)
	pbWait(30)
	while @EAM.isAnimating?
		Graphics.update
		@EAM.update
	end
	pbWait(30)
	@EAM.dispose
end