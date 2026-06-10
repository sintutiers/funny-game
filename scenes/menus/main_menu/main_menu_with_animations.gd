extends MainMenu

## Main menu extension that adds options and animates the title and menu fading in.
## The scene adds a 'Continue' button if a game is in progress.
## The animation can be skipped by the player with any input.
## Optional scene to open when the player clicks a 'Level Select' button.

@export var level_select_packed_scene: PackedScene
@export var confirm_new_game: bool = true

@onready var continue_game_button: Button = %ContinueGameButton
@onready var level_select_button: Button = %LevelSelectButton
@onready var new_game_confirmation: PanelContainer = %NewGameConfirmation
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = $MenuAnimationTree.get("parameters/playback")

func load_game_scene() -> void:
	GameState.start_game()
	super.load_game_scene()

func new_game() -> void:
	if confirm_new_game and continue_game_button.visible:
		new_game_confirmation.show()
	else:
		GameState.reset()
		load_game_scene()

func intro_done() -> void:
	animation_state_machine.travel("OpenMainMenu")

func _is_in_intro() -> bool:
	return animation_state_machine.get_current_node() == "Intro"

func _event_skips_intro(event: InputEvent) -> bool:
	return event.is_action_released("ui_accept") or \
		event.is_action_released("ui_select") or \
		event.is_action_released("ui_cancel") or \
		_event_is_mouse_button_released(event)

func _open_sub_menu(menu: PackedScene) -> Node:
	animation_state_machine.travel("OpenSubMenu")
	return super._open_sub_menu(menu)

func _close_sub_menu() -> void:
	super._close_sub_menu()
	animation_state_machine.travel("OpenMainMenu")

func _show_level_select_if_set() -> void:
	if level_select_packed_scene == null:
		return
	if GameState.get_levels_reached() <= 1:
		return
	level_select_button.show()

func _show_continue_if_set() -> void:
	if GameState.get_current_level_path().is_empty():
		return
	continue_game_button.show()

func _ready() -> void:
	super._ready()
	_show_level_select_if_set()
	_show_continue_if_set()

func _get_neighbor_focus(current: Control, neighbor_path: NodePath, fallback: Control) -> Control:
	if not neighbor_path.is_empty():
		var neighbor := get_node(neighbor_path)
		if neighbor:
			return neighbor
	return fallback

func _input(event: InputEvent) -> void:
	if _is_in_intro() and _event_skips_intro(event):
		intro_done()
		return
	if not is_visible_in_tree():
		super._input(event)
		return
	var current_focus: Control = get_viewport().gui_get_focus_owner()
	if not current_focus:
		super._input(event)
		return
	var next_control: Control = null
	if event.is_action_pressed("down"):
		next_control = current_focus.find_next_valid_focus()
	elif event.is_action_pressed("up"):
		next_control = current_focus.find_prev_valid_focus()
	elif event.is_action_pressed("left"):
		next_control = _get_neighbor_focus(current_focus, current_focus.focus_neighbor_left, current_focus.find_prev_valid_focus())
	elif event.is_action_pressed("right"):
		next_control = _get_neighbor_focus(current_focus, current_focus.focus_neighbor_right, current_focus.find_next_valid_focus())

	if next_control and next_control != current_focus:
		next_control.grab_focus()
		get_viewport().set_input_as_handled()
		return
	super._input(event)

func _on_continue_game_button_pressed() -> void:
	GameState.continue_game()
	load_game_scene()

func _on_level_select_button_pressed() -> void:
	var level_select_scene := _open_sub_menu(level_select_packed_scene)
	if level_select_scene.has_signal("level_selected"):
		level_select_scene.connect("level_selected", load_game_scene)


func _on_new_game_confirmation_confirmed() -> void:
	GameState.reset()
	load_game_scene()
