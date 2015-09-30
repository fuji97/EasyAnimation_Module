class EAMSprite < Sprite
	include EAM_Sprite
end

class EAM_Callback
	class << self
		def back1(obj,type)
			obj.move(0,50,20,:ease_out_cubic,:back2)
			echoln(type.to_s)
		end
		def back2(obj,type)
			obj.move(50,50,20,:ease_out_cubic,:back3)
			echoln(type.to_s)
		end
		def back3(obj,type)
			obj.move(50,0,20,:ease_out_cubic,:back4)
			echoln(type.to_s)
		end
		def back4(obj,type)
			obj.move(0,0,20,:ease_out_cubic,:back1)
			echoln(type.to_s)
		end
	end
end

def testEAM
	obj = EAMSprite.new
	obj.bitmap = Bitmap.new("Graphics/Pictures/WheelMenu/cerchioMagico")
	EAM_Callback.back1(obj,:move)
	while obj.isAnimating?
		obj.update
		Graphics.update
	end
end
