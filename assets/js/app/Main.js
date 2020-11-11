import React, { useState, useEffect } from "react";
import { Row, Col, Card, Form, Input, Button } from "antd";
import { MinusCircleOutlined, PlusOutlined } from "@ant-design/icons";
import API from "./api";
import Graph from "react-graph-vis";

const options = {
  edges: {
    color: "#000",
    shadow: true,
    smooth: true,
    background: {
      enabled: true,
      color: "#fff",
    },
  },
  height: "500px",
};

const events = {
  select: function (event) {
    var { nodes, edges } = event;
  },
};

const zip = (arrays) =>
  arrays[0].map((_, i) => arrays.map((array) => array[i]));

const Main = (props) => {
  const [form] = Form.useForm();

  const [graphId, setGraphId] = useState(null);
  const [graphData, setGraphData] = useState({ nodes: [], edges: [] });

  useEffect(() => {
    API.newGraph().then(({ data: { graph_id: id } }) => setGraphId(id));
  }, []);

  const createSubgraph = (params) => {
    API.createSubgraph(graphId, { subgraph: params }).then((response) => {
      setGraphData(response.data);
      form.resetFields();
    });
  };

  const getShortestPath = ({ from, to }) => {
    API.getShortestPath(graphId, { from: from, to: to }).then((response) => {
      let withoutLastElement = [...response.data];
      let withoutFirstElement = [...response.data];

      withoutLastElement.splice(-1, 1);
      withoutFirstElement.splice(0, 1);

      let shortestPath = zip([withoutLastElement, withoutFirstElement]).map(
        ([from, to]) => {
          return { from: from, to: to };
        }
      );

      let edges = graphData.edges.map((edge) => {
        if (
          shortestPath.some(
            (path) => path.from == edge.from && path.to == edge.to
          )
        ) {
          return {
            ...edge,
            dashes: false,
            background: {
              enabled: true,
              color: "red",
              size: 5,
            },
          };
        } else {
          return edge;
        }
      });
      console.log(edges);
      setGraphData({ ...graphData, edges });
    });
  };

  return (
    <Row gutter={[16, 24]}>
      <Col span={12}>
        <Card title="Add your name and your friend list">
          <Form form={form} name="subgraph" onFinish={createSubgraph}>
            <Form.Item
              name="name"
              rules={[{ required: true, message: "Missing name" }]}
            >
              <Input placeholder="Your name" />
            </Form.Item>

            <Form.List name="friends">
              {(fields, { add, remove }) => (
                <>
                  {fields.map((field) => (
                    <Row key={field.key}>
                      <Col flex={5} style={{ paddingRight: 5 }}>
                        <Form.Item
                          {...field}
                          name={[field.name, "name"]}
                          fieldKey={[field.fieldKey, "name"]}
                          rules={[
                            { required: true, message: "Missing friend name" },
                          ]}
                        >
                          <Input placeholder="Friend name" />
                        </Form.Item>
                      </Col>
                      <Col flex={"none"} style={{ paddingTop: 5 }}>
                        <MinusCircleOutlined
                          onClick={() => remove(field.name)}
                        />
                      </Col>
                    </Row>
                  ))}
                  <Form.Item>
                    <Button
                      type="dashed"
                      onClick={() => add()}
                      block
                      icon={<PlusOutlined />}
                    >
                      Add friend
                    </Button>
                  </Form.Item>
                </>
              )}
            </Form.List>
            <Form.Item>
              <Button type="primary" htmlType="submit">
                Submit
              </Button>
            </Form.Item>
          </Form>
        </Card>
      </Col>
      <Col span={12}>
        <Card
          title="Shortest Path"
          key={"ShortestPath"}
          style={{ marginBottom: 16 }}
        >
          <Form name="shortest_path" onFinish={getShortestPath}>
            <Form.Item name="from">
              <Input placeholder="From" />
            </Form.Item>
            <Form.Item name="to">
              <Input placeholder="To" />
            </Form.Item>
            <Form.Item>
              <Button type="primary" htmlType="submit">
                Submit
              </Button>
            </Form.Item>
          </Form>
        </Card>

        <Card title="Visualization graph" key={"VisualizationGraph"}>
          <Graph graph={graphData} options={options} events={events} />
        </Card>
      </Col>
    </Row>
  );
};

export default Main;
