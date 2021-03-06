# Copyright (c) 2019, NVIDIA CORPORATION.
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

from c_cc cimport *
from c_graph cimport *
from libc.stdint cimport uintptr_t
import cudf
import numpy as np

cpdef weakly_connected_components(G, connect_type = CUGRAPH_WEAK):
    """
    Generate the connected components and attach a component label to each vertex.
    
    Parameters
    ----------
    G : cugraph.Graph
      cuGraph graph descriptor, should contain the connectivity information as an edge list 
      (edge weights are not used for this algorithm). Currently, the graph should be undirected where 
      an undirected edge is represented by a directed edge in both directions.
      The adjacency list will be computed if not already present.
      The number of vertices should fit into a 32b int. 

    connect_type : cugraph_cc_t
      Weak (CUGRAPH_WEAK), or Strong (CUGRAPH_STRONG) (not implemented, yet)
    
    Returns
    -------
    df : cudf.DataFrame
      df['labels'][i] gives the label id of the i'th vertex
       
        
    Examples
    --------
    >>> M = read_mtx_file(graph_file)
    >>> sources = cudf.Series(M.row)
    >>> destinations = cudf.Series(M.col)
    >>> G = cuGraph.Graph()
    >>> G.add_edge_list(sources,destinations,none)
    >>> df = cuGraph.weak_cc(G, CUGRAPH_WEAK)
    """

    cdef uintptr_t graph = G.graph_ptr
    cdef gdf_graph* g = <gdf_graph*>graph

    err = gdf_add_adj_list(<gdf_graph*> graph)
    cudf.bindings.cudf_cpp.check_gdf_error(err)

    num_verts = G.number_of_vertices()

    df = cudf.DataFrame()
    df['labels'] = cudf.Series(np.zeros(num_verts, dtype=np.int32))
    cdef gdf_column c_labels = get_gdf_column_view(df['labels'])

    gdf_connected_components(g, <cugraph_cc_t>connect_type, &c_labels)
    return df
