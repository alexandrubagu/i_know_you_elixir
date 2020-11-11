import Utils from "./api/utils";

const newGraph = () => Utils.request.post(`/api/new-graph`);

const createSubgraph = (id, params) =>
  Utils.request.post(`/api/${id}/create_subgraph`, params);

const getShortestPath = (id, params) =>
  Utils.request.post(`/api/${id}/get_shortest_path`, params);

export default { newGraph, createSubgraph, getShortestPath };
