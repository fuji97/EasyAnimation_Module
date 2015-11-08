################################################################################
# Callbacks class
################################################################################
class EAM_Callback
	DEBUG = true
	class << self
		def log(obj,type)
			case type
			when :move
				echoln("Move finished") if DEBUG
				when :fade
				echoln("Fade finished") if DEBUG
				when :zoom
				echoln("Zoom finished") if DEBUG
				when :rotate
				echoln("Rotate finished") if DEBUG
				when :coloring
				echoln("Coloring finished") if DEBUG
			end
		end
	end
end

class Curve
	class << self
		def circPoint(origin, angle, rad, axisX)	# axisX = true if calculating X, else false if calculating Y
			if axisX
				# echoln("Cos - origine: " + origin.to_s + " Angle: " + angle.to_s + " Rad: " + rad.to_s)
				return origin + Math.cos(Curve.rad(angle)) * rad
			else
				# echoln("Sin - origine: " + origin.to_s + " Angle: " + angle.to_s + " Rad: " + rad.to_s)
				return origin - Math.sin(Curve.rad(angle)) * rad
			end
		end
		
		# Convert Radiants to Degrees
		def deg(radiants)
			return radiants * 180 / Math::PI
		end
		
		# Convert Degrees to Radiants
		def rad(degrees)
			return degrees * Math::PI / 180 
		end
		
		# Convert value in a valid angle [0-360]
		def correctAngle(angle)
			return angle % 360
		end
		
		def radiusFromPoints(circX, circY, pX, pY)
			dX = (circX - pX).abs
			dY = (circY - pY).abs
			return Math.sqrt(dX * dX + dY * dY)
		end
	
	def angle(circX, circY, pX, pY)
		begin
			m = -(pY - circY).to_f / (pX - circX).to_f
		rescue
			return (circY > pY ? 90 : 270)
		end
		# echoln("m: " + m.to_s + " - y = " + self.y.to_s + " cy = " + @circY.to_s + " x = " + self.x.to_s + " cx = " + @circX.to_s)
		angle = Curve.deg(Math.atan(m))
		if m > 0
			angle += 180 if circY < pY
		elsif m < 0
			if circY > pY
				angle += 180
			else
				angle += 360
			end
		else
			angle = (pX > circX ? 0 : 180)
		end
		
			# @angle += 360 if @angle < 0
		return angle
		end
	end
		
end

################################################################################
# A port of known Robert Penner's easing functions for Ruby by munshkr
# https://github.com/munshkr/easing-ruby/
################################################################################

class Ease
	class << self
		def linear_tween(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f
			
			return c * t / d + b
		end

		def ease_in_quad(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return c*(t/=d)*t + b;
		end
			
			
		def ease_out_quad(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return -c *(t/=d)*(t-2) + b;
		end

		def ease_in_out_quad(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			t /= d / 2
			return c / 2*t*t + b if (t < 1)
			t -= 1
			return -c/2 * (t*(t-2) - 1) + b
		end

		def ease_in_cubic(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return c*(t/=d)*t*t + b
		end

		def ease_out_cubic(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return c*((t=t/d-1)*t*t + 1) + b
		end

		def ease_in_out_cubic(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return c/2*t*t*t + b if ((t/=d/2) < 1)
			return c/2*((t-=2)*t*t + 2) + b
		end

		def ease_in_quart(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return c*(t/=d)*t*t*t + b
		end

		def ease_out_quart(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return -c * ((t=t/d-1)*t*t*t - 1) + b
		end

		def ease_in_out_quart(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return c/2*t*t*t*t + b if ((t/=d/2) < 1)
			return -c/2 * ((t-=2)*t*t*t - 2) + b
		end

		def ease_in_quint(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return c*(t/=d)*t*t*t*t + b
		end

		def ease_out_quint(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return c*((t=t/d-1)*t*t*t*t + 1) + b
		end

		def ease_in_out_quint(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return c/2*t*t*t*t*t + b if ((t/=d/2) < 1)
			return c/2*((t-=2)*t*t*t*t + 2) + b
		end

		def ease_in_sine(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return -c * Math.cos(t/d * (Math::PI/2)) + c + b
		end

		def ease_out_sine(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return c * Math.sin(t/d * (Math::PI/2)) + b
		end

		def ease_in_out_sine(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return -c/2 * (Math.cos(Math::PI*t/d) - 1) + b
		end

		def ease_in_expo(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return (t==0) ? b : c * (2 ** (10 * (t/d - 1))) + b
		end

		def ease_out_expo(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return (t==d) ? b+c : c * (-2**(-10 * t/d) + 1) + b
		end

		def ease_in_out_expo(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return b if t == 0
			return b + c if t == d
			return (c/2) * 2**(10 * (t-1)) + b if ((t /= d/2) < 1)
			return (c/2) * (-2**(-10 * t-=1) + 2) + b
		end

		def ease_in_circ(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b
		end

		def ease_out_circ(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return c * Math.sqrt(1 - (t=t/d-1)*t) + b
		end

		def ease_in_out_circ(t, b, c, d)
			t = t.to_f; b = b.to_f; c = c.to_f; d = d.to_f

			return -c/2 * (Math.sqrt(1 - t*t) - 1) + b if ((t/=d/2) < 1)
			return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b
		end
	end
end