# Draw.io Diagram Examples

This document contains complete working examples of various diagram types.

## Table of Contents

1. [Simple Flowchart](#simple-flowchart)
2. [AWS Architecture Diagram](#aws-architecture-diagram)
3. [Swimlane Process Diagram](#swimlane-process-diagram)
4. [Mind Map](#mind-map)
5. [Transformer Architecture (Animated)](#transformer-architecture-animated)
6. [Git Branching Model](#git-branching-model)
7. [ER Diagram](#er-diagram)

---

## Simple Flowchart

**Use Case**: Basic process flow with decision points

```xml
<root>
  <mxCell id="0"/>
  <mxCell id="1" parent="0"/>

  <!-- Start -->
  <mxCell id="start" value="Start" style="ellipse;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
    <mxGeometry x="350" y="40" width="120" height="60" as="geometry"/>
  </mxCell>

  <!-- Process 1 -->
  <mxCell id="proc1" value="Initialize System" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
    <mxGeometry x="350" y="140" width="120" height="60" as="geometry"/>
  </mxCell>

  <!-- Decision -->
  <mxCell id="decision" value="Valid Input?" style="rhombus;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
    <mxGeometry x="330" y="240" width="160" height="80" as="geometry"/>
  </mxCell>

  <!-- Process 2 (Yes path) -->
  <mxCell id="proc2" value="Process Data" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
    <mxGeometry x="350" y="370" width="120" height="60" as="geometry"/>
  </mxCell>

  <!-- Error (No path) -->
  <mxCell id="error" value="Show Error" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;" vertex="1" parent="1">
    <mxGeometry x="550" y="250" width="120" height="60" as="geometry"/>
  </mxCell>

  <!-- End -->
  <mxCell id="end" value="End" style="ellipse;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
    <mxGeometry x="350" y="480" width="120" height="60" as="geometry"/>
  </mxCell>

  <!-- Edges -->
  <mxCell id="e1" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;" edge="1" parent="1" source="start" target="proc1">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e2" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;" edge="1" parent="1" source="proc1" target="decision">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e3" value="Yes" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;" edge="1" parent="1" source="decision" target="proc2">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e4" value="No" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;exitX=1;exitY=0.5;entryX=0;entryY=0.5;" edge="1" parent="1" source="decision" target="error">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e5" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;" edge="1" parent="1" source="proc2" target="end">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e6" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;exitX=0.5;exitY=1;entryX=1;entryY=0.5;" edge="1" parent="1" source="error" target="end">
    <mxGeometry relative="1" as="geometry">
      <Array as="points">
        <mxPoint x="610" y="510"/>
      </Array>
    </mxGeometry>
  </mxCell>
</root>
```

---

## AWS Architecture Diagram

**Use Case**: Cloud infrastructure visualization

```xml
<root>
  <mxCell id="0"/>
  <mxCell id="1" parent="0"/>

  <!-- VPC Container -->
  <mxCell id="vpc" value="VPC (10.0.0.0/16)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;dashed=1;verticalAlign=top;fontSize=14;fontStyle=1;" vertex="1" parent="1">
    <mxGeometry x="40" y="80" width="720" height="480" as="geometry"/>
  </mxCell>

  <!-- Public Subnet -->
  <mxCell id="public_subnet" value="Public Subnet" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;dashed=1;verticalAlign=top;" vertex="1" parent="1">
    <mxGeometry x="80" y="140" width="300" height="180" as="geometry"/>
  </mxCell>

  <!-- Private Subnet -->
  <mxCell id="private_subnet" value="Private Subnet" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;dashed=1;verticalAlign=top;" vertex="1" parent="1">
    <mxGeometry x="420" y="140" width="300" height="180" as="geometry"/>
  </mxCell>

  <!-- Internet Gateway -->
  <mxCell id="igw" value="Internet Gateway" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
    <mxGeometry x="170" y="20" width="120" height="40" as="geometry"/>
  </mxCell>

  <!-- Load Balancer -->
  <mxCell id="alb" value="Application&#xa;Load Balancer" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
    <mxGeometry x="170" y="180" width="120" height="60" as="geometry"/>
  </mxCell>

  <!-- Web Server -->
  <mxCell id="web" value="Web Server&#xa;(EC2)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
    <mxGeometry x="170" y="260" width="120" height="40" as="geometry"/>
  </mxCell>

  <!-- App Server -->
  <mxCell id="app" value="App Server&#xa;(EC2)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#e1d5e7;strokeColor=#9673a6;" vertex="1" parent="1">
    <mxGeometry x="480" y="180" width="120" height="60" as="geometry"/>
  </mxCell>

  <!-- Database -->
  <mxCell id="db" value="RDS&#xa;Database" style="shape=cylinder;whiteSpace=wrap;html=1;fillColor=#e1d5e7;strokeColor=#9673a6;" vertex="1" parent="1">
    <mxGeometry x="510" y="260" width="60" height="60" as="geometry"/>
  </mxCell>

  <!-- S3 Bucket -->
  <mxCell id="s3" value="S3 Bucket" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#ffe6cc;strokeColor=#d79b00;" vertex="1" parent="1">
    <mxGeometry x="340" y="380" width="120" height="40" as="geometry"/>
  </mxCell>

  <!-- Users -->
  <mxCell id="users" value="Users" style="shape=actor;whiteSpace=wrap;html=1;" vertex="1" parent="1">
    <mxGeometry x="200" y="-80" width="60" height="80" as="geometry"/>
  </mxCell>

  <!-- Edges -->
  <mxCell id="e1" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;" edge="1" parent="1" source="users" target="igw">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e2" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;" edge="1" parent="1" source="igw" target="alb">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e3" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;" edge="1" parent="1" source="alb" target="web">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e4" value="API calls" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;exitX=1;exitY=0.5;entryX=0;entryY=0.5;" edge="1" parent="1" source="web" target="app">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e5" value="SQL" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;" edge="1" parent="1" source="app" target="db">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e6" value="Store files" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;exitX=0.5;exitY=1;entryX=0.5;entryY=0;" edge="1" parent="1" source="web" target="s3">
    <mxGeometry relative="1" as="geometry">
      <Array as="points">
        <mxPoint x="230" y="350"/>
        <mxPoint x="400" y="350"/>
      </Array>
    </mxGeometry>
  </mxCell>
</root>
```

---

## Swimlane Process Diagram

**Use Case**: Cross-functional workflows

```xml
<root>
  <mxCell id="0"/>
  <mxCell id="1" parent="0"/>

  <!-- Title -->
  <mxCell id="title" value="Order Processing Workflow" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;fontSize=16;fontStyle=1;" vertex="1" parent="1">
    <mxGeometry x="250" y="20" width="300" height="30" as="geometry"/>
  </mxCell>

  <!-- Customer Lane -->
  <mxCell id="lane1" value="Customer" style="swimlane;startSize=30;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
    <mxGeometry x="40" y="80" width="720" height="120" as="geometry"/>
  </mxCell>

  <mxCell id="step1" value="Place Order" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="lane1">
    <mxGeometry x="30" y="50" width="100" height="50" as="geometry"/>
  </mxCell>

  <mxCell id="step7" value="Receive Product" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="lane1">
    <mxGeometry x="590" y="50" width="100" height="50" as="geometry"/>
  </mxCell>

  <!-- Sales Lane -->
  <mxCell id="lane2" value="Sales Team" style="swimlane;startSize=30;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
    <mxGeometry x="40" y="200" width="720" height="120" as="geometry"/>
  </mxCell>

  <mxCell id="step2" value="Verify Order" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="lane2">
    <mxGeometry x="170" y="50" width="100" height="50" as="geometry"/>
  </mxCell>

  <mxCell id="step3" value="Process Payment" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="lane2">
    <mxGeometry x="310" y="50" width="100" height="50" as="geometry"/>
  </mxCell>

  <!-- Warehouse Lane -->
  <mxCell id="lane3" value="Warehouse" style="swimlane;startSize=30;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
    <mxGeometry x="40" y="320" width="720" height="120" as="geometry"/>
  </mxCell>

  <mxCell id="step4" value="Pick Items" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="lane3">
    <mxGeometry x="310" y="50" width="100" height="50" as="geometry"/>
  </mxCell>

  <mxCell id="step5" value="Pack Order" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="lane3">
    <mxGeometry x="450" y="50" width="100" height="50" as="geometry"/>
  </mxCell>

  <!-- Shipping Lane -->
  <mxCell id="lane4" value="Shipping" style="swimlane;startSize=30;fillColor=#e1d5e7;strokeColor=#9673a6;" vertex="1" parent="1">
    <mxGeometry x="40" y="440" width="720" height="120" as="geometry"/>
  </mxCell>

  <mxCell id="step6" value="Ship Order" style="rounded=1;whiteSpace=wrap;html=1;" vertex="1" parent="lane4">
    <mxGeometry x="590" y="50" width="100" height="50" as="geometry"/>
  </mxCell>

  <!-- Edges (all at root level) -->
  <mxCell id="e1" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;exitX=1;exitY=0.5;entryX=0;entryY=0.5;" edge="1" parent="1" source="step1" target="step2">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e2" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;" edge="1" parent="1" source="step2" target="step3">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e3" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;exitX=0.5;exitY=1;entryX=0.5;entryY=0;" edge="1" parent="1" source="step3" target="step4">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e4" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;" edge="1" parent="1" source="step4" target="step5">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e5" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;exitX=1;exitY=0.5;entryX=0;entryY=0.5;" edge="1" parent="1" source="step5" target="step6">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e6" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;html=1;exitX=0.5;exitY=0;entryX=0.5;entryY=1;" edge="1" parent="1" source="step6" target="step7">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>
</root>
```

---

## Mind Map

**Use Case**: Hierarchical concept organization

```xml
<root>
  <mxCell id="0"/>
  <mxCell id="1" parent="0"/>

  <!-- Central Idea -->
  <mxCell id="center" value="Machine Learning" style="ellipse;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontSize=16;fontStyle=1;" vertex="1" parent="1">
    <mxGeometry x="320" y="240" width="160" height="80" as="geometry"/>
  </mxCell>

  <!-- Branch 1: Supervised -->
  <mxCell id="supervised" value="Supervised Learning" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1;" vertex="1" parent="1">
    <mxGeometry x="120" y="100" width="120" height="60" as="geometry"/>
  </mxCell>

  <mxCell id="classification" value="Classification" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
    <mxGeometry x="40" y="40" width="100" height="40" as="geometry"/>
  </mxCell>

  <mxCell id="regression" value="Regression" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
    <mxGeometry x="40" y="100" width="100" height="40" as="geometry"/>
  </mxCell>

  <!-- Branch 2: Unsupervised -->
  <mxCell id="unsupervised" value="Unsupervised Learning" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;fontStyle=1;" vertex="1" parent="1">
    <mxGeometry x="560" y="100" width="120" height="60" as="geometry"/>
  </mxCell>

  <mxCell id="clustering" value="Clustering" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
    <mxGeometry x="700" y="40" width="100" height="40" as="geometry"/>
  </mxCell>

  <mxCell id="dimreduce" value="Dimensionality&#xa;Reduction" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
    <mxGeometry x="700" y="100" width="100" height="40" as="geometry"/>
  </mxCell>

  <!-- Branch 3: Reinforcement -->
  <mxCell id="reinforcement" value="Reinforcement Learning" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#e1d5e7;strokeColor=#9673a6;fontStyle=1;" vertex="1" parent="1">
    <mxGeometry x="340" y="420" width="120" height="60" as="geometry"/>
  </mxCell>

  <mxCell id="qlearning" value="Q-Learning" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#e1d5e7;strokeColor=#9673a6;" vertex="1" parent="1">
    <mxGeometry x="250" y="510" width="100" height="40" as="geometry"/>
  </mxCell>

  <mxCell id="policygradient" value="Policy Gradient" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#e1d5e7;strokeColor=#9673a6;" vertex="1" parent="1">
    <mxGeometry x="380" y="510" width="100" height="40" as="geometry"/>
  </mxCell>

  <!-- Branch 4: Deep Learning -->
  <mxCell id="deep" value="Deep Learning" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;fontStyle=1;" vertex="1" parent="1">
    <mxGeometry x="120" y="360" width="120" height="60" as="geometry"/>
  </mxCell>

  <mxCell id="cnn" value="CNN" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;" vertex="1" parent="1">
    <mxGeometry x="40" y="450" width="80" height="40" as="geometry"/>
  </mxCell>

  <mxCell id="rnn" value="RNN" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;" vertex="1" parent="1">
    <mxGeometry x="140" y="450" width="80" height="40" as="geometry"/>
  </mxCell>

  <!-- Edges -->
  <mxCell id="e1" style="edgeStyle=orthogonalEdgeStyle;curved=1;endArrow=none;html=1;strokeWidth=2;" edge="1" parent="1" source="center" target="supervised">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e2" style="edgeStyle=orthogonalEdgeStyle;curved=1;endArrow=none;html=1;" edge="1" parent="1" source="supervised" target="classification">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e3" style="edgeStyle=orthogonalEdgeStyle;curved=1;endArrow=none;html=1;" edge="1" parent="1" source="supervised" target="regression">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e4" style="edgeStyle=orthogonalEdgeStyle;curved=1;endArrow=none;html=1;strokeWidth=2;" edge="1" parent="1" source="center" target="unsupervised">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e5" style="edgeStyle=orthogonalEdgeStyle;curved=1;endArrow=none;html=1;" edge="1" parent="1" source="unsupervised" target="clustering">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e6" style="edgeStyle=orthogonalEdgeStyle;curved=1;endArrow=none;html=1;" edge="1" parent="1" source="unsupervised" target="dimreduce">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e7" style="edgeStyle=orthogonalEdgeStyle;curved=1;endArrow=none;html=1;strokeWidth=2;" edge="1" parent="1" source="center" target="reinforcement">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e8" style="edgeStyle=orthogonalEdgeStyle;curved=1;endArrow=none;html=1;" edge="1" parent="1" source="reinforcement" target="qlearning">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e9" style="edgeStyle=orthogonalEdgeStyle;curved=1;endArrow=none;html=1;" edge="1" parent="1" source="reinforcement" target="policygradient">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e10" style="edgeStyle=orthogonalEdgeStyle;curved=1;endArrow=none;html=1;strokeWidth=2;" edge="1" parent="1" source="center" target="deep">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e11" style="edgeStyle=orthogonalEdgeStyle;curved=1;endArrow=none;html=1;" edge="1" parent="1" source="deep" target="cnn">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e12" style="edgeStyle=orthogonalEdgeStyle;curved=1;endArrow=none;html=1;" edge="1" parent="1" source="deep" target="rnn">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>
</root>
```

---

## Transformer Architecture (Animated)

**Use Case**: Technical architecture with animated data flow

(This is a simplified version - see the cached responses in the codebase for the full transformer diagram)

```xml
<root>
  <mxCell id="0"/>
  <mxCell id="1" parent="0"/>

  <!-- Title -->
  <mxCell id="title" value="Simplified Transformer" style="text;html=1;fontSize=18;fontStyle=1;" vertex="1" parent="1">
    <mxGeometry x="300" y="20" width="200" height="30" as="geometry"/>
  </mxCell>

  <!-- Encoder -->
  <mxCell id="encoder" value="ENCODER" style="rounded=1;fillColor=#e1d5e7;strokeColor=#9673a6;verticalAlign=top;fontStyle=1;" vertex="1" parent="1">
    <mxGeometry x="100" y="100" width="160" height="200" as="geometry"/>
  </mxCell>

  <mxCell id="mha_enc" value="Multi-Head&#xa;Attention" style="rounded=1;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
    <mxGeometry x="120" y="220" width="120" height="50" as="geometry"/>
  </mxCell>

  <mxCell id="ff_enc" value="Feed Forward" style="rounded=1;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
    <mxGeometry x="120" y="140" width="120" height="40" as="geometry"/>
  </mxCell>

  <!-- Decoder -->
  <mxCell id="decoder" value="DECODER" style="rounded=1;fillColor=#ffe6cc;strokeColor=#d79b00;verticalAlign=top;fontStyle=1;" vertex="1" parent="1">
    <mxGeometry x="540" y="100" width="160" height="200" as="geometry"/>
  </mxCell>

  <mxCell id="mha_dec" value="Multi-Head&#xa;Attention" style="rounded=1;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
    <mxGeometry x="560" y="220" width="120" height="50" as="geometry"/>
  </mxCell>

  <mxCell id="ff_dec" value="Feed Forward" style="rounded=1;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
    <mxGeometry x="560" y="140" width="120" height="40" as="geometry"/>
  </mxCell>

  <!-- Output -->
  <mxCell id="output" value="Output" style="rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontStyle=1;" vertex="1" parent="1">
    <mxGeometry x="560" y="50" width="120" height="30" as="geometry"/>
  </mxCell>

  <!-- Animated Edges -->
  <mxCell id="e1" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;flowAnimation=1;strokeWidth=2;strokeColor=#6c8ebf;" edge="1" parent="1" source="mha_enc" target="ff_enc">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e2" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;flowAnimation=1;strokeWidth=2;strokeColor=#9673a6;dashed=1;" edge="1" parent="1" source="ff_enc" target="mha_dec">
    <mxGeometry relative="1" as="geometry">
      <Array as="points">
        <mxPoint x="350" y="160"/>
        <mxPoint x="350" y="245"/>
      </Array>
    </mxGeometry>
  </mxCell>

  <mxCell id="e3" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;flowAnimation=1;strokeWidth=2;strokeColor=#d79b00;" edge="1" parent="1" source="mha_dec" target="ff_dec">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="e4" style="edgeStyle=orthogonalEdgeStyle;endArrow=classic;flowAnimation=1;strokeWidth=2;strokeColor=#6c8ebf;" edge="1" parent="1" source="ff_dec" target="output">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>
</root>
```

---

## Git Branching Model

**Use Case**: Version control workflow visualization

```xml
<root>
  <mxCell id="0"/>
  <mxCell id="1" parent="0"/>

  <!-- Main Branch -->
  <mxCell id="main_label" value="main" style="text;html=1;fontStyle=1;fontSize=14;" vertex="1" parent="1">
    <mxGeometry x="40" y="100" width="60" height="30" as="geometry"/>
  </mxCell>

  <mxCell id="m1" value="v1.0" style="ellipse;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
    <mxGeometry x="140" y="90" width="60" height="50" as="geometry"/>
  </mxCell>

  <mxCell id="m2" value="v1.1" style="ellipse;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
    <mxGeometry x="440" y="90" width="60" height="50" as="geometry"/>
  </mxCell>

  <mxCell id="m3" value="v2.0" style="ellipse;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
    <mxGeometry x="740" y="90" width="60" height="50" as="geometry"/>
  </mxCell>

  <!-- Develop Branch -->
  <mxCell id="dev_label" value="develop" style="text;html=1;fontStyle=1;fontSize=14;" vertex="1" parent="1">
    <mxGeometry x="40" y="240" width="80" height="30" as="geometry"/>
  </mxCell>

  <mxCell id="d1" value="" style="ellipse;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
    <mxGeometry x="260" y="230" width="40" height="40" as="geometry"/>
  </mxCell>

  <mxCell id="d2" value="" style="ellipse;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
    <mxGeometry x="350" y="230" width="40" height="40" as="geometry"/>
  </mxCell>

  <mxCell id="d3" value="" style="ellipse;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
    <mxGeometry x="560" y="230" width="40" height="40" as="geometry"/>
  </mxCell>

  <mxCell id="d4" value="" style="ellipse;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
    <mxGeometry x="650" y="230" width="40" height="40" as="geometry"/>
  </mxCell>

  <!-- Feature Branch -->
  <mxCell id="feat_label" value="feature/new" style="text;html=1;fontStyle=1;fontSize=12;" vertex="1" parent="1">
    <mxGeometry x="40" y="390" width="100" height="30" as="geometry"/>
  </mxCell>

  <mxCell id="f1" value="" style="ellipse;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
    <mxGeometry x="350" y="380" width="40" height="40" as="geometry"/>
  </mxCell>

  <mxCell id="f2" value="" style="ellipse;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
    <mxGeometry x="440" y="380" width="40" height="40" as="geometry"/>
  </mxCell>

  <!-- Hotfix Branch -->
  <mxCell id="hot_label" value="hotfix" style="text;html=1;fontStyle=1;fontSize=12;" vertex="1" parent="1">
    <mxGeometry x="40" y="540" width="60" height="30" as="geometry"/>
  </mxCell>

  <mxCell id="h1" value="" style="ellipse;whiteSpace=wrap;html=1;fillColor=#f8cecc;strokeColor=#b85450;" vertex="1" parent="1">
    <mxGeometry x="560" y="530" width="40" height="40" as="geometry"/>
  </mxCell>

  <!-- Main branch timeline -->
  <mxCell id="em1" style="endArrow=classic;html=1;strokeWidth=3;strokeColor=#82b366;" edge="1" parent="1" source="m1" target="m2">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="em2" style="endArrow=classic;html=1;strokeWidth=3;strokeColor=#82b366;" edge="1" parent="1" source="m2" target="m3">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <!-- Develop branch timeline -->
  <mxCell id="ed1" style="endArrow=classic;html=1;strokeWidth=2;strokeColor=#6c8ebf;" edge="1" parent="1" source="d1" target="d2">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="ed2" style="endArrow=classic;html=1;strokeWidth=2;strokeColor=#6c8ebf;" edge="1" parent="1" source="d2" target="d3">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="ed3" style="endArrow=classic;html=1;strokeWidth=2;strokeColor=#6c8ebf;" edge="1" parent="1" source="d3" target="d4">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <!-- Feature branch -->
  <mxCell id="ef1" style="endArrow=classic;html=1;strokeColor=#d6b656;" edge="1" parent="1" source="f1" target="f2">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <!-- Branch and merge -->
  <mxCell id="branch_dev" value="branch" style="endArrow=classic;html=1;strokeColor=#6c8ebf;dashed=1;exitX=0.5;exitY=1;entryX=0.5;entryY=0;" edge="1" parent="1" source="m1" target="d1">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="branch_feat" value="branch" style="endArrow=classic;html=1;strokeColor=#d6b656;dashed=1;exitX=0.5;exitY=1;entryX=0;entryY=0;" edge="1" parent="1" source="d2" target="f1">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="merge_feat" value="merge" style="endArrow=classic;html=1;strokeColor=#d6b656;dashed=1;exitX=1;exitY=0;entryX=0.5;entryY=1;" edge="1" parent="1" source="f2" target="d3">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="merge_dev1" value="merge" style="endArrow=classic;html=1;strokeColor=#6c8ebf;dashed=1;exitX=0.5;exitY=0;entryX=0.5;entryY=1;" edge="1" parent="1" source="d2" target="m2">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="merge_dev2" value="merge" style="endArrow=classic;html=1;strokeColor=#6c8ebf;dashed=1;exitX=0.5;exitY=0;entryX=0.5;entryY=1;" edge="1" parent="1" source="d4" target="m3">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="branch_hot" value="hotfix" style="endArrow=classic;html=1;strokeColor=#b85450;dashed=1;exitX=0.5;exitY=1;entryX=0;entryY=0;" edge="1" parent="1" source="m2" target="h1">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="merge_hot" value="merge" style="endArrow=classic;html=1;strokeColor=#b85450;dashed=1;exitX=1;exitY=0;entryX=0.5;entryY=1;" edge="1" parent="1" source="h1" target="m3">
    <mxGeometry relative="1" as="geometry">
      <Array as="points">
        <mxPoint x="750" y="480"/>
        <mxPoint x="770" y="200"/>
      </Array>
    </mxGeometry>
  </mxCell>
</root>
```

---

## ER Diagram

**Use Case**: Database schema visualization

```xml
<root>
  <mxCell id="0"/>
  <mxCell id="1" parent="0"/>

  <!-- User Table -->
  <mxCell id="user_table" value="User" style="swimlane;fontStyle=1;align=center;verticalAlign=top;childLayout=stackLayout;startSize=26;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
    <mxGeometry x="60" y="100" width="160" height="140" as="geometry"/>
  </mxCell>

  <mxCell id="user_pk" value="PK: user_id: INT" style="text;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;rotatable=0;fontStyle=4;" vertex="1" parent="user_table">
    <mxGeometry y="26" width="160" height="26" as="geometry"/>
  </mxCell>

  <mxCell id="user_fields" value="username: VARCHAR&#xa;email: VARCHAR&#xa;created_at: DATETIME" style="text;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;rotatable=0;" vertex="1" parent="user_table">
    <mxGeometry y="52" width="160" height="88" as="geometry"/>
  </mxCell>

  <!-- Order Table -->
  <mxCell id="order_table" value="Order" style="swimlane;fontStyle=1;align=center;verticalAlign=top;childLayout=stackLayout;startSize=26;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
    <mxGeometry x="340" y="100" width="180" height="160" as="geometry"/>
  </mxCell>

  <mxCell id="order_pk" value="PK: order_id: INT" style="text;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;fontStyle=4;" vertex="1" parent="order_table">
    <mxGeometry y="26" width="180" height="26" as="geometry"/>
  </mxCell>

  <mxCell id="order_fk" value="FK: user_id: INT" style="text;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;fontStyle=2;" vertex="1" parent="order_table">
    <mxGeometry y="52" width="180" height="26" as="geometry"/>
  </mxCell>

  <mxCell id="order_fields" value="total_amount: DECIMAL&#xa;status: VARCHAR&#xa;created_at: DATETIME" style="text;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;" vertex="1" parent="order_table">
    <mxGeometry y="78" width="180" height="82" as="geometry"/>
  </mxCell>

  <!-- Product Table -->
  <mxCell id="product_table" value="Product" style="swimlane;fontStyle=1;align=center;verticalAlign=top;childLayout=stackLayout;startSize=26;fillColor=#fff2cc;strokeColor=#d6b656;" vertex="1" parent="1">
    <mxGeometry x="60" y="350" width="160" height="140" as="geometry"/>
  </mxCell>

  <mxCell id="product_pk" value="PK: product_id: INT" style="text;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;fontStyle=4;" vertex="1" parent="product_table">
    <mxGeometry y="26" width="160" height="26" as="geometry"/>
  </mxCell>

  <mxCell id="product_fields" value="name: VARCHAR&#xa;price: DECIMAL&#xa;stock: INT" style="text;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;" vertex="1" parent="product_table">
    <mxGeometry y="52" width="160" height="88" as="geometry"/>
  </mxCell>

  <!-- OrderItem Table (Junction) -->
  <mxCell id="orderitem_table" value="OrderItem" style="swimlane;fontStyle=1;align=center;verticalAlign=top;childLayout=stackLayout;startSize=26;fillColor=#e1d5e7;strokeColor=#9673a6;" vertex="1" parent="1">
    <mxGeometry x="340" y="350" width="180" height="140" as="geometry"/>
  </mxCell>

  <mxCell id="orderitem_pk" value="PK: orderitem_id: INT" style="text;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;fontStyle=4;" vertex="1" parent="orderitem_table">
    <mxGeometry y="26" width="180" height="26" as="geometry"/>
  </mxCell>

  <mxCell id="orderitem_fk" value="FK: order_id: INT&#xa;FK: product_id: INT" style="text;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;fontStyle=2;" vertex="1" parent="orderitem_table">
    <mxGeometry y="52" width="180" height="48" as="geometry"/>
  </mxCell>

  <mxCell id="orderitem_fields" value="quantity: INT&#xa;price: DECIMAL" style="text;align=left;verticalAlign=top;spacingLeft=4;spacingRight=4;overflow=hidden;" vertex="1" parent="orderitem_table">
    <mxGeometry y="100" width="180" height="40" as="geometry"/>
  </mxCell>

  <!-- Relationships -->
  <mxCell id="rel1" value="1" style="endArrow=none;html=1;edgeStyle=orthogonalEdgeStyle;exitX=1;exitY=0.5;entryX=0;entryY=0.5;strokeWidth=2;" edge="1" parent="1" source="user_pk" target="order_fk">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="rel1_label" value="places" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];" vertex="1" connectable="0" parent="rel1">
    <mxGeometry x="-0.1" y="2" relative="1" as="geometry">
      <mxPoint x="5" y="-8" as="offset"/>
    </mxGeometry>
  </mxCell>

  <mxCell id="rel1_many" value="*" style="text;html=1;align=center;verticalAlign=middle;" vertex="1" parent="1">
    <mxGeometry x="310" y="145" width="20" height="20" as="geometry"/>
  </mxCell>

  <mxCell id="rel2" value="1" style="endArrow=none;html=1;edgeStyle=orthogonalEdgeStyle;exitX=0.5;exitY=1;entryX=0.5;entryY=0;strokeWidth=2;" edge="1" parent="1" source="order_table" target="orderitem_table">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="rel2_label" value="contains" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];" vertex="1" connectable="0" parent="rel2">
    <mxGeometry x="-0.1" y="1" relative="1" as="geometry">
      <mxPoint x="20" as="offset"/>
    </mxGeometry>
  </mxCell>

  <mxCell id="rel2_many" value="*" style="text;html=1;align=center;verticalAlign=middle;" vertex="1" parent="1">
    <mxGeometry x="430" y="320" width="20" height="20" as="geometry"/>
  </mxCell>

  <mxCell id="rel3" value="*" style="endArrow=none;html=1;edgeStyle=orthogonalEdgeStyle;exitX=1;exitY=0.5;entryX=0;entryY=0.5;strokeWidth=2;" edge="1" parent="1" source="product_pk" target="orderitem_fk">
    <mxGeometry relative="1" as="geometry"/>
  </mxCell>

  <mxCell id="rel3_label" value="in" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];" vertex="1" connectable="0" parent="rel3">
    <mxGeometry x="-0.15" y="1" relative="1" as="geometry">
      <mxPoint x="10" y="-8" as="offset"/>
    </mxGeometry>
  </mxCell>

  <mxCell id="rel3_one" value="1" style="text;html=1;align=center;verticalAlign=middle;" vertex="1" parent="1">
    <mxGeometry x="230" y="387" width="20" height="20" as="geometry"/>
  </mxCell>
</root>
```

---

## Tips for Using Examples

1. **Copy Structure**: Use these examples as starting points and modify as needed
2. **Preserve IDs**: Ensure all IDs remain unique when combining examples
3. **Adjust Positions**: Modify x/y coordinates to fit your layout requirements
4. **Update Styles**: Change colors and styles to match your preferences
5. **Add Details**: Extend examples with additional elements as needed

## Color Scheme Reference

For consistent professional diagrams, use these color combinations:

| Category | Fill Color | Stroke Color | Use Case                     |
| -------- | ---------- | ------------ | ---------------------------- |
| Blue     | #dae8fc    | #6c8ebf      | Primary elements, servers    |
| Green    | #d5e8d4    | #82b366      | Success states, completion   |
| Yellow   | #fff2cc    | #d6b656      | Warning, attention areas     |
| Red      | #f8cecc    | #b85450      | Errors, critical paths       |
| Purple   | #e1d5e7    | #9673a6      | Special features, highlights |
| Orange   | #ffe6cc    | #d79b00      | Alternative, secondary       |
