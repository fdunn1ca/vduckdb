module vduckdb

import dl
import time
import os

fn get_libname() !string {
	// Check current directory first
	if os.is_file(dl.get_libname('./libduckdb')) {
		return dl.get_libname('./libduckdb')
	}
	// Check environment variable
	if os.is_file(dl.get_libname('${os.getenv('LIBDUCKDB_DIR')}/libduckdb')) {
		return dl.get_libname('${os.getenv('LIBDUCKDB_DIR')}/libduckdb')
	}
	// Check the executable's own directory (resolving symlinks), so a binary shipped next to
	// its libduckdb works from any working directory
	exe_dir := os.dir(os.real_path(os.executable()))
	if os.is_file(dl.get_libname('${exe_dir}/libduckdb')) {
		return dl.get_libname('${exe_dir}/libduckdb')
	}
	return error('')
}

const library_file_path = get_libname() or {
	println('[ERROR]: No libduckdb library installed. Put libduckdb in the current directory or next to the executable, or set LIBDUCKDB_DIR to the directory containing it')
	exit(1)
}
const start_date = time.Time{
	year:  1970
	month: 1
	day:   1
}
