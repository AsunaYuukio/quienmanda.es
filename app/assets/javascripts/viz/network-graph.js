function NetworkGraph(selector) {

  // Basic D3.js SVG container setup
  var width = $(selector).width(),
      height = width * .5,
      centerx = width / 2,
      centery = height / 2,
      linkDistance = height * .2;

  var category2 = [ "#60A300", "#A9C300" ];
  var color = d3.scale.ordinal().range(category2).domain([1,2]);

  // I keep track of panning+zooming and use the 'drag' behaviour plus two buttons.
  // The mousewheel behaviour of the 'zoom' behaviour was annoying, and couldn't 
  // find a way of disabling it.
  var scale = 1;
  var center_x = 0;
  var center_y = 0;

  var svg = d3.select(selector).append("svg")
      .attr("width", width)
      .attr("height", height)
      .call(d3.behavior.drag().on("drag", onDrag))
      .append("g");   // Removing this breaks zooming/panning

  // Force layout configuration
  var force = d3.layout.force()
      .on("tick", tick)
      .charge(-linkDistance * 5)
      .gravity(0.05)
      .linkDistance(linkDistance)
      .size([width, height]);

  // Node drag behaviour
  var drag = force.drag()
      .on("dragstart", dragstart)
      .on("dragend", dragend);

  // Visualization data
  var nodes = {};
  var links = {};

  // D3.js selectors, available for tick() method
  var node,
      path,
      text;

  // Arrow marker
  svg.append("svg:defs")
    .append("svg:marker")
      .attr("id", 'relation')
      .attr("viewBox", "0 -5 15 10")
      .attr("refX", 20)
      .attr("refY", -0.5)
      .attr("markerWidth", 5)
      .attr("markerHeight", 5)
      .attr("orient", "auto")
    .append("svg:path")
      .attr("d", "M0,-5L10,0L0,5");

  // Create two separate containers for links and nodes, to make sure
  // nodes come always after nodes, even when loading data dynamically
  svg.append("g")
    .attr("id", "linksContainer");
  svg.append("g")
    .attr("id", "nodesContainer");


  /* PUBLIC interface */

  this.display = function() {
    // Create force layout
    force
        .nodes(d3.values(nodes))
        .links(d3.values(links))
        .start();

    // Relations
    path = svg.select("#linksContainer").selectAll(".link")
        .data(force.links(), function(d) { return d.id; })

    path.enter().append("svg:path")
        .attr("class", "link")
        .attr("marker-end", function(d) { return "url(#relation)"; });

    // Nodes
    node = svg
        .select("#nodesContainer")
        .selectAll(".node")
        .data(force.nodes(), function(d) { return d.url; })

    var that = this;
    node.enter().append("g")
      .call(drag)
      .call(createNode)
        .attr("class", function(d) { return d.root ? "node root" : "node" } )
        .on('dblclick', function(d) { that.loadNode(d.url); })
      .append("text")
        .attr("dx", 11)
        .attr("dy", ".35em")
        .text(function(d) { return d.name });
  };

  this.loadNode = function(url) {
    var networkGraph = this;
    $.getJSON(url, function(data) {
      var isFirstLoad = (typeof node === 'undefined');

      // Add the retrieved nodes to the network graph
      $.each(data.nodes, function(key, node) {
        if ( isFirstLoad ) {
          presetFirstNodes(node);
        }
        nodes[node.url] = nodes[node.url] || node;
      });

      // Add the retrieved links to the network graph
      $.each(data.links, function(key, link) {
        link.source = nodes[link.source];
        link.target = nodes[link.target];
        links[link.id] = links[link.id] || link;
      });

      networkGraph.display();
    });
  };

  // Zoom controls
  this.zoomIn = function() {
    scale *= 1.2;
    rescale();
  };
  this.zoomOut = function() {
    scale /= 1.2;
    rescale();
  };
  this.zoomReset = function() {
    scale = 1;
    center_x = 0;
    center_y = 0;
    rescale();
  }

  /* PRIVATE */

  function createNode(node) {
    node.append("circle")
      .attr("r", 9)
      .style("fill", function(d) { return color(d.group); });
  }

  // When creating a new, pre-position the root node in the middle of the screen 
  // (and mark it as fixed for the D3.js layout). Put the non-root nodes randomly 
  // in a circle around it to avoid the dizzying start where all the nodes fly around
  function presetFirstNodes(node) {
    if (node['root']) {
      node['fixed'] = true;
      node['x'] = centerx;
      node['y'] = centery;
    } else {
      var angle = 2 * Math.PI * Math.random();
      node['x'] = centerx + linkDistance * Math.sin(angle);
      node['y'] = centery + linkDistance * Math.cos(angle);
    }
  };

  // Force layout iteration
  function tick() {
    path.attr("d", function(d) {
      var dx = d.target.x - d.source.x,
          dy = d.target.y - d.source.y,
          dr = Math.sqrt(dx * dx + dy * dy) * 1.5;
      return "M" + d.source.x + "," + d.source.y + "A" + dr + "," + dr + " 0 0,1 " + d.target.x + "," + d.target.y;
    });

    node.attr("transform", function(d) {
      return "translate(" + d.x + "," + d.y + ")";
    });
  };

  // Canvas drag handler
  function onDrag() {
    center_x += d3.event.dx;
    center_y += d3.event.dy;
    rescale();
    d3.event.sourceEvent.stopPropagation(); // silence other listeners
  }
  function rescale() {
    svg.attr("transform", "translate(" + center_x + ","+ center_y+")scale("+scale+")");
  }

  // Node drag handlers
  function dragstart(d) {
    d3.event.sourceEvent.stopPropagation(); // silence other listeners
  }
  function dragend(d) {
    d.fixed = true; // fix the node position after dragging is completed
  };
};