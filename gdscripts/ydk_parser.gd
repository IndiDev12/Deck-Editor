# ydk_parser.gd
extends Node
## Pure YDK parser. No UI dependencies.

const DECK_DIR := "res://deck/"   # change to "user://deck/" if you want writable user space

## Returns { "main": Array[int], "extra": Array[int], "side": Array[int] }
## on failure returns empty arrays (no crash).
static func parse_file(path: String) -> Dictionary:
	var out := {"main": [] as Array[int], "extra": [] as Array[int], "side": [] as Array[int]}
	if not FileAccess.file_exists(path):
		push_warning("[YdkParser] file not found: %s" % path)
		return out

	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_warning("[YdkParser] cannot open: %s (err %d)" % [path, FileAccess.get_open_error()])
		return out

	var section := ""   # "main" | "extra" | "side" | ""
	while not f.eof_reached():
		var raw := f.get_line()
		var line := raw.strip_edges()
		if line.is_empty():
			continue

		# Section headers
		if line.begins_with("#main"):
			section = "main"; continue
		elif line.begins_with("#extra"):
			section = "extra"; continue
		elif line.begins_with("!side"):
			section = "side"; continue
		elif line.begins_with("#"):
			# generic comment (e.g. #created by ...)
			continue

		# Otherwise it should be a card passcode
		if not line.is_valid_int():
			continue   # skip malformed lines silently
		var id := int(line)
		if section in out:
			(out[section] as Array[int]).append(id)

	f.close()
	return out


## Lists every *.ydk in DECK_DIR. Returns Array[String] of absolute paths
## plus a parallel Array[String] of display names (filename without extension).
static func list_decks(dir_path: String = DECK_DIR) -> Dictionary:
	var paths: Array[String] = []
	var names: Array[String] = []

	var dir := DirAccess.open(dir_path)
	if dir == null:
		push_warning("[YdkParser] deck folder missing: %s" % dir_path)
		return {"paths": paths, "names": names}

	dir.list_dir_begin()
	var fname := dir.get_next()
	while fname != "":
		if not dir.current_is_dir() and fname.to_lower().ends_with(".ydk"):
			paths.append(dir_path.trim_suffix("/") + "/" + fname)
			names.append(fname.get_basename())
		fname = dir.get_next()
	dir.list_dir_end()
	return {"paths": paths, "names": names}
