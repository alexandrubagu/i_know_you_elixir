import "../css/app.scss";
import * as React from "react";
import * as ReactDOM from "react-dom";
import { Layout } from "antd";
import Main from "./app/Main";

ReactDOM.render(
  <Layout>
    <Layout.Header style={{ position: "fixed", zIndex: 1, width: "100%" }}>
      <div className="logo">
        <h1>Do I Know You ?!</h1>
      </div>
    </Layout.Header>
    <Layout.Content className="site-layout">
      <div
        className="site-layout-background"
        style={{ padding: "80px 50px", minHeight: "calc(100vh)" }}
      >
        <Main />
      </div>
    </Layout.Content>
  </Layout>,
  document.getElementById("root")
);
