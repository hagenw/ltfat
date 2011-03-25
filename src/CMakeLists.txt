# Create a library called "ltfat"

add_definitions(-DLTFAT_DOUBLE -Wall -Wextra -pedantic -Werror -std=c99)

set(FILES ltfat   dgt.c dgt_fac.c dgt_fb.c dgtreal_fac.c
                  dgt_walnut.c dwilt.c gabdual.c gabdual_fac.c
                  gabtight.c gabtight_fac.c heapint.c idgt_fac.c integer_manip.c
                  iwfac.c ltfat_blaslapack.c reassign.c spread.c tfutil.c wfac.c
                  windows.c winmanip.c)

add_library (ltfat-nomem SHARED ${FILES} ) 
add_library (ltfat ${FILES} c-safe-memalloc.c) 

target_link_libraries(ltfat ${CMAKE_REQUIRED_LIBRARIES})

include_directories(. ../thirdparty)

# enable gcc specific stuff
if (CMAKE_COMPILER_IS_GNUCC)
    set_source_files_properties(${LTFAT_LIB_SRC} PROPERTIES COMPILE_FLAGS "-DLTFAT_DOUBLE -O2 -std=c99 -Werror -Wall -pedantic")
endif ()

set(CMAKE_REQUIRED_LIBRARIES "ltfat;${CMAKE_REQUIRED_LIBRARIES}")

# install
#install(ltfat LIBRARY DESTINATION lib)




