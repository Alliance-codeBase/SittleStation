/// strips filepath path, leaving only it's name and extension
/proc/strip_filepath_path(file, file_types)
	var/last_slash = findlasttext("[file]", "/")
	if(!last_slash)
		return "[file]"

	return copytext("[file]", last_slash + 1)
