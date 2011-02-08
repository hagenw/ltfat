# The name of our project is "LTFAT". CMakeLists files in this project can
# refer to the root source directory of the project as ${LTFAT_SOURCE_DIR} and
# to the root binary directory of the project as ${LTFAT_BINARY_DIR}.
cmake_minimum_required (VERSION 2.6)
project (LTFAT)

# Recurse into the "Hello" and "Demo" subdirectories. This does not actually
# cause another cmake executable to run. The same process will walk through
# the project's entire directory structure.
add_subdirectory (src)
