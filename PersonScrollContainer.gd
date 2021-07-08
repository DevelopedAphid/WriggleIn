extends ScrollContainer

signal user_input_detected

# Allows you to scroll a scroll container by dragging.
# Includes momentum.

var swiping = false
var swipe_start
var swipe_mouse_start
var swipe_mouse_times = []
var swipe_mouse_positions = []
var bg_scroll_container

func _ready():
	bg_scroll_container = get_parent().get_node("BackgroundScrollContainer")

func _input(ev):
	emit_signal("user_input_detected")
	
	if ev is InputEventMouseButton:
		if ev.pressed:
			swiping = true
			swipe_start = Vector2(get_h_scroll(), get_v_scroll())
			swipe_mouse_start = ev.position
			swipe_mouse_times = [OS.get_ticks_msec()]
			swipe_mouse_positions = [swipe_mouse_start]
		else:
			swipe_mouse_times.append(OS.get_ticks_msec())
			swipe_mouse_positions.append(ev.position)
			var source = Vector2(get_h_scroll(), get_v_scroll())
			var idx = swipe_mouse_times.size() - 1
			var now = OS.get_ticks_msec()
			var cutoff = now - 100
			for i in range(swipe_mouse_times.size() - 1, -1, -1):
				if swipe_mouse_times[i] >= cutoff: idx = i
				else: break
			var flick_start = swipe_mouse_positions[idx]
			var flick_dur = min(0.3, (ev.position - flick_start).length() / 1000)
			if flick_dur > 0.0:
				var tween = Tween.new()
				add_child(tween)
				var delta = ev.position - flick_start
				var target = source - delta * flick_dur * 15.0
				tween.interpolate_method(self, 'set_h_scroll', source.x, target.x, flick_dur, Tween.TRANS_LINEAR, Tween.EASE_OUT)
				tween.interpolate_method(self, 'set_v_scroll', source.y, target.y, flick_dur, Tween.TRANS_LINEAR, Tween.EASE_OUT)
				tween.interpolate_callback(tween, flick_dur, 'queue_free')
				tween.start()
				
				var tween_bg = Tween.new()
				add_child(tween_bg)
				var delta_bg = ev.position - flick_start
				var target_bg = source - delta_bg * flick_dur * 15.0
				tween_bg.interpolate_method(bg_scroll_container, 'set_h_scroll', source.x, target_bg.x, flick_dur, Tween.TRANS_LINEAR, Tween.EASE_OUT)
				tween_bg.interpolate_method(bg_scroll_container, 'set_v_scroll', source.y, target_bg.y, flick_dur, Tween.TRANS_LINEAR, Tween.EASE_OUT)
				tween_bg.interpolate_callback(tween_bg, flick_dur, 'queue_free')
				tween_bg.start()
			swiping = false
	elif swiping and ev is InputEventMouseMotion:
		var delta = ev.position - swipe_mouse_start
		set_h_scroll(swipe_start.x - delta.x)
		set_v_scroll(swipe_start.y - delta.y)
		bg_scroll_container.set_v_scroll(swipe_start.y - delta.y)
		swipe_mouse_times.append(OS.get_ticks_msec())
		swipe_mouse_positions.append(ev.position)
