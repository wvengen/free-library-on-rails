// based on https://github.com/shprink/d3js-wordcloud
// using https://github.com/jasondavies/d3-cloud
// also interesting is https://weblogs.java.net/blog/manningpubs/archive/2014/11/10/d3-making-word-cloud-effective-graphical-object

var Wordcloud = (function(wc, d3) {
  var fontSize, layout, svg, vis;

  // override this :)
  wc.words = [];
  wc.selector = '#wordcloud';

  wc.scale = 'sqrt';
  wc.spiral = 'archimedean';
  wc.fill = d3.scale.category20b();
  wc.padding = 5;
  wc.transitionDuration = 200;
  // width and height can be a function or pixels
  wc.width = function() { return window.innerWidth; };
  wc.height = function() { return window.innerHeight; };

  wc.element = function() {
    return d3.select(wc.selector);
  };

  wc._width = function() {
    return (typeof wc.width == 'function') ? wc.width() : wc.width;
  };
  wc._height = function() {
    return (typeof wc.height == 'function') ? wc.height() : wc.height;
  };

  wc.init = function() {
    var w = wc._width();
    var h = wc._height();
    layout = d3.layout.cloud()
	  .spiral(wc.spiral)
      .timeInterval(Infinity)
      .size([w, h])
	  .padding(wc.padding)
      .fontSize(function(d) {
        return fontSize(+d.size);
      })
      .text(function(d) {
        return d.text;
      })
      .on("end", wc.draw);

    svg = wc.element().append("svg");
    vis = svg.append("g").attr("transform", "translate(" + [w >> 1, h >> 1] + ")");

    wc.update();
	svg.on('resize', function() { wc.update() });
  };

  wc.draw = function(data, bounds) {
    var w = wc._width();
    var h = wc._height();

    svg.attr("width", w).attr("height", h);

    scale = bounds ? Math.min(
      w / Math.abs(bounds[1].x - w / 2),
      w / Math.abs(bounds[0].x - w / 2),
      h / Math.abs(bounds[1].y - h / 2),
      h / Math.abs(bounds[0].y - h / 2)) / 2 : 1;

    var text = vis.selectAll("text")
      .data(data, function(d) {
        return d.text.toLowerCase();
      });
    text.transition()
      .duration(wc.transitionDuration)
      .attr("transform", function(d) {
        return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
      })
      .style("font-size", function(d) {
        return d.size + "px";
      });
    text.enter().append("text")
      .attr("text-anchor", "middle")
      .attr("transform", function(d) {
        return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
      })
      .style("font-size", function(d) {
        return d.size + "px";
      })
      .style("opacity", 1e-6)
      .transition()
      .duration(wc.transitionDuration)
      .style("opacity", 1);
    text.style("font-family", function(d) {
        return d.font || svg.style("font-family");
      })
     .style("fill", function(d) {
        return wc.fill(d.text.toLowerCase());
      })
      .text(function(d) {
        return d.text;
      })
	  // clickable words
	  .style("cursor", function(d, i) {
        if (d.href) return 'pointer';
	  })
	  .on("mouseover", function(d, i) {
		if (d.href) d3.select(this).transition()
		              .style('font-size', d.size + 4 + 'px');
	  })
	  .on("mouseout", function(d, i) {
        if (d.href) d3.select(this).transition()
		              .style('font-size', d.size + 'px');
	  })
	  .on("click", function(d, i) {
	    if (d.href) window.location = d.href;
	  });

    vis.transition()
	  .attr("transform", "translate(" + [w >> 1, h >> 1] + ")scale(" + scale + ")");
  };

  wc.update = function() {
	var words = wc.words;
    fontSize = d3.scale[wc.scale]().range([10, 100]);
    if (words.length){
      fontSize.domain([+words[words.length - 1].size || 1, +words[0].size]);
    }
    layout.stop().words(words).start();
  };

  return wc;
})(Wordcloud || {}, d3);
