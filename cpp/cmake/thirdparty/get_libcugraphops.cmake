#=============================================================================
# Copyright (c) 2022, NVIDIA CORPORATION.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#=============================================================================

function(find_and_configure_cugraphops)

    if(TARGET cugraphops::cugraphops)
        return()
    endif()

    rapids_find_generate_module(cugraphops
        HEADER_NAMES            graph/sampling.h
        LIBRARY_NAMES           cugraph-ops++
        INCLUDE_SUFFIXES        cugraph-ops
        BUILD_EXPORT_SET    cugraph-exports
        INSTALL_EXPORT_SET  cugraph-exports
    )

    rapids_find_package(cugraphops
        REQUIRED
        BUILD_EXPORT_SET    cugraph-exports
        INSTALL_EXPORT_SET  cugraph-exports
    )

endfunction()

find_and_configure_cugraphops()