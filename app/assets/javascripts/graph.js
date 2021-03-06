/**
 * Created by efthimios on 10/10/2014.
 */
//data format
var demo_data = {
    prices:
        [
            {
                key : "Contract 1",
                values : [0.5, 0.1, 0.35, 0.8, 0.72, 0.7]
            },
            {
                key : "Contract 2",
                values : [0.1, 0.5, 0.8, 0.35, 0.8, 0.1]
            },
            {
                key : "Contract 3",
                values : [0.2, 0.8, 0.7, 0.6, 0.5, 0.4]
            }
        ],
    volume: [10, 20, 30, 13, 20, 40],
    dates:["2014-09-01 12:00", "2014-09-02 12:00", "2014-09-03 12:00", "2014-09-04 12:00", "2014-09-05 12:00", "2014-09-06 12:00"]
}

//some variables
var available_size = 960,
    margin = {top: 40, right: 40, bottom: 100, left: 40},
    margin2 = {top: 420, right: 20, bottom: 20, left: 40},
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom,
    lineChartHeight = 400 - margin.top - margin.bottom,
    height2 = 467 - margin2.top - margin2.bottom;
line2ChartHeight = 400 - margin2.top - margin2.bottom,
    barHeight = 80;
bar2Height = 30;
barWidth = 10;
bar2Width = 5;
color = d3.scale.category10();

//date format
var parseDate = d3.time.format("%Y-%m-%d %H:%M").parse;
var formatDate = d3.time.format("%Y-%m-%d %H:%M");

//scales
var x = d3.time.scale().range([0, width]),
    x2 = d3.time.scale().range([0, width]),
    y = d3.scale.linear().range([lineChartHeight, 0]),
    y2 = d3.scale.linear().range([height2, 0]);
barY = d3.scale.linear().range([barHeight, 0]);
bar2Y = d3.scale.linear().range([bar2Height, 0]);

//axis
var xAxis = d3.svg.axis().scale(x).orient("bottom"),
    xAxis2 = d3.svg.axis().scale(x2).orient("bottom"),
    yAxis = d3.svg.axis().scale(y).orient("left").ticks(7);;
    baryAxis = d3.svg.axis().scale(barY).orient("left").ticks(3);

//need one for volume?

var brush = d3.svg.brush()
    .x(x2)
    .on("brush", brushed);

var line = d3.svg.line()
    .interpolate("linear")
    .x(function(d) { return x(d.date); })
    .y(function(d) { return y(d.price); });

var line2 = d3.svg.line()
    .interpolate("linear")
    .x(function(d) { return x2(d.date); })
    .y(function(d) { return y2(d.price); });

var svg = d3.select("chart").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom -40);

svg.append("defs").append("clipPath")
    .attr("id", "clip")
    .append("rect")
    .attr("width", width)
    .attr("height", lineChartHeight);

var priceText = svg.append("g")
    .append("text")
    .text("Price")
    .style("color", "black")
    .style("font-size", "12px")
    .attr("transform", "translate(" + margin.left + ", " + (margin.top -4) +")");

var volumeText = svg.append("g")
    .append("text")
    .text("Volume")
    .style("font-size", "12px")
    .attr("transform", "translate(" + margin.left + ", " + (lineChartHeight + margin.top +38) +")");

function make_y_axis() {
    return d3.svg.axis()
        .scale(y)
        .orient("left")
        .ticks(4);
}

function make_x_axis() {
    return d3.svg.axis()
        .scale(x)
        .orient("bottm")
        .ticks(4);
}

function make_bar_x_axis() {
    return d3.svg.axis()
        .scale(barx)
        .orient("bottom")
        .ticks(4);
}

function make_bar_y_axis() {
    return d3.svg.axis()
        .scale(barY)
        .orient("left")
        .ticks(4);
}

function chart(data) {
    console.log(data)
    color.domain(data.prices.map(function(entry) {return entry.key}));

    svg = d3.select("chart").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom - 40);

    svg.append("defs").append("clipPath")
        .attr("id", "clip")
        .append("rect")
        .attr("width", width)
        .attr("height", height);

    legend = svg.append("g")
        .attr("class", "legend")
        .attr("transform", "translate(" + margin.left + ", 0)");

    focus_area = svg.append("svg:g")
        .attr("class", "focus")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    context = svg.append("g")
        .attr("class", "context")
        .attr("transform", "translate(" + margin2.left + "," + margin2.top + ")");


    tooltip = focus_area.append("svg:g")
        .attr("class", "tooltip")
        .style("display", "none");

    tooltip.append("circle")
        .attr("r", 4.5);

    div = d3.select("body").append("div")
        .attr("class", "tooltip")
        .style("opacity", 0);

    data.dates.forEach(function(d, i){
        data.dates[i] = parseDate(d);
    });

    var contracts = color.domain().map(function(key, i) {
        return {
            key: key,
            prices: data.prices[i].values.map(function(d,i) {
                return {date: data.dates[i], price: d};
            })
        };
    });

    var volumes = data.volume.map(function (d, i){
        return {
            date: data.dates[i],
            volume: d
        }
    });

    //define domains
    x.domain(d3.extent(data.dates));
    y.domain([0,1]);
    x2.domain(x.domain());
    y2.domain(y.domain());
    barY.domain([0, d3.max(data.volume)]);
    bar2Y.domain(barY.domain());

    data.prices.forEach(function(d,i) {

        // Add the Legend
        legend.append("text")
            .attr("x", width - ((width/10)+i*width/10)) // spacing
            .attr("y", margin.top - 5)
            .attr("class", "legend")    // style the legend
            .style("fill", function() { // dynamic colours
                return d.color = color(d.key); })
            .style("cursor", "pointer")
            .on("click", function(){
                var active   = d.active ? false : true,
                    newOpacity = active ? 0 : 1;
                console.log(newOpacity);
                d3.select("#tag"+d.key.replace(/\s+/g, ''))
                    .transition().duration(100)
                    .style("opacity", newOpacity);
                d3.select("#tag2"+d.key.replace(/\s+/g, ''))
                    .transition().duration(100)
                    .style("opacity", newOpacity);
                d.active = active;
            })
            .text(d.key);
    });

    focus_area.append("rect")
        .attr("x", 0)
        .attr("y", 0)
        .attr("height", (lineChartHeight))
        .attr("width", (width - 1 ))
        .style("stroke", "black")
        .style("fill", "none")
        .style("stroke-width", "1");

    focus_area.append("clipPath")
        .attr("id", "focusClip")
        .append("rect")
        .attr("x", 0)
        .attr("y", 0)
        .attr("width", width)
        .attr("height", lineChartHeight);

    focus_area.append("g")
        .attr("class", "grid")
        .call(make_y_axis()
            .tickSize(-width, 0, 0)
            .tickFormat("")
    );

    focus_area.append("g")
        .attr("class", "grid")
        .attr("transform", "translate(0," + (lineChartHeight) + ")")
        .call(make_x_axis()
            .tickSize(-(lineChartHeight), 0, 0)
            .tickFormat("")
    );

    focus_area.append("rect")
        .attr("x", 0)
        .attr("y", lineChartHeight + margin.top)
        .attr("height", (barHeight-20))
        .attr("width", (width))
        .style("stroke", "#E0E0E0")
        .style("fill", "#E0E0E0")
        .style("stroke-width", "0.5");
    focus_area.append("clipPath")
        .attr("id", "barFocusClip")
        .append("rect")
        .attr("x", 0)
        .attr("y", lineChartHeight + margin.top)
        .attr("width", width)
        .attr("height", barHeight-20);

    focus_area.append("g")
        .attr("class", "grid")
        .attr("transform", "translate(0," + (lineChartHeight+margin.top) + ")")
        .call(make_bar_y_axis()
            .tickSize(-width, 0, 0)
            .tickFormat("")
    );

    bar = focus_area.selectAll(".bars")
        .data(volumes)
        .enter().append("g")
        .attr('clip-path', 'url(#barFocusClip)')

    bar.append("rect")
        .attr("class", "bar")
        .transition()
        .delay(function(d, i) { return i * 100; })
        .duration(1000)
        .attr("id", function(d,i) { return "bar"+i; })
        .attr("x", function(d,i) { console.log(x(d.date)); return (x(d.date) - (barWidth - 1)/2); })
        .attr("y", function(d,i) { console.log(i + " " + barY(d.volume)); return height - barHeight + barY(d.volume); })
        .attr("width", barWidth - 1)
        .attr("height", function(d) { return barHeight - barY(d.volume); });

    contract = focus_area.selectAll(".contract")
        .data(contracts)
        .enter().append("g")
        .attr("class", "contract")

    contract.append("path")
        .attr("class", "line")
        .attr('clip-path', 'url(#focusClip)')
        .style("stroke", function(d) {
            return d.color = color(d.key); })
        .attr("id", function(d) {
            return 'tag'+d.key.replace(/\s+/g, ''); })
        .attr("d", function(d) { return line(d.prices); })

    dot = focus_area.selectAll(".dots")
        .data(contracts)
        .enter()
        .append("g")
        .style("fill", function(d) {
            console.log(d.key);
            return d.color = color(d.key);
        })
        .style("opacity", 0);

    dot.selectAll(".dot")
        .data(function(d, i) { return d.prices; })
        .enter()
        .append("circle")
        .attr("class", "dot")
        .attr("r", 20)
        .attr("cx", function(d) { return x(d.date); })
        .attr("cy", function(d) { return y(d.price); })
        .attr('clip-path', 'url(#focusClip)')
        .on("mouseover", function(d) {
            tooltip.attr("transform", "translate(" + x(d.date) + "," + y(d.price) + ")");
            tooltip.style("fill", d3.select(this.parentNode).style("fill"))
                .transition()
                .duration(200)
                .style("opacity", 1)
                .style("display", null);
            div.transition()
                .duration(200)
                .style("opacity", .9);
            div.html(d.price + " @ " + formatDate(d.date))
                .style("left", (d3.event.pageX) + "px")
                .style("top", (d3.event.pageY - 28) + "px");
        })
        .on("mouseout", function(d) {
            console.log("mouse out");
            tooltip.transition()
                .duration(500)
                .style("display", "none");
            div.transition()
                .duration(500)
                .style("opacity", 0);
        });

    focus_area.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + lineChartHeight + ")")
        .call(xAxis);

    focus_area.append("g")
        .attr("class", "y axis")
        .call(yAxis);

    focus_area.append("g")
        .attr("class", "y axis")
        .attr("transform", "translate(0, "+(lineChartHeight+margin.top) +")")
        .call(baryAxis);

    context.append("rect")
        .attr("height", bar2Height)
        .attr("y", height2 - bar2Height)
        .attr("width", width)
        .style("stroke", "white")
        .style("fill", "white");

    contextbar = context.selectAll(".bars")
        .data(volumes)
        .enter().append("g")
        .attr('clip-path', 'url(#focusClip)');

    contextbar.append("rect")
        .attr("class", "bar")
        .attr("id", function(d,i) { return "bar"+i; })
        .attr("x", function(d,i) { return (x(d.date) - (bar2Width - 1)/2); })
        .attr("y", function(d) { return height2 - bar2Height + bar2Y(d.volume); })
        .attr("width", barWidth - 1)
        .attr("height", function(d) { return bar2Height - bar2Y(d.volume); });

    contracts2 = context.selectAll(".contract")
        .data(contracts)
        .enter().append("g")
        .attr("class", "contract");

    contracts2.append("path")
        .attr("class", "line")
        .attr('clip-path', 'url(#focusClip)')
        .style("stroke", function(d) {
            return d.color = color(d.key); })
        .attr("id", function(d) {
            return 'tag2'+d.key.replace(/\s+/g, ''); })
        .attr("d", function(d) { return line2(d.prices); })

    /*
    context.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height2 + ")")
        .call(xAxis2);
    */

    context.append("g")
        .attr("class", "x brush")
        .call(brush)
        .selectAll("rect")
        .attr("y", -6)
        .attr("height", height2 + 7);

    context.select(".brush").selectAll(".resize")
        .append("path").attr("d", resizePath)
        .attr("transform", "translate(0, " +(-height2/2-margin2.bottom)+ ")");

    // define our brush extent to be begin and end of the year
    brush.extent(x.domain());
    brush(d3.select(".brush").transition());
}

function nochart(){
    noDataText = svg.selectAll('.nv-noData').data(["No Data Available"]);
    noDataText.enter().append('text')
        .attr('class', 'nvd3 nv-noData')
        .style('text-anchor', 'right');

    noDataText
        .attr('x', width/2)
        .attr('y', height/2)
        .text(function(d) { return d });
}

function createChart(data){
    if (!data) {
        nochart();
    } else {
        chart(data);
    }
}

/*
$( document ).ready( function() {
    d3.xhr( "/markets/1/graph_data", function( json ) {
        console.log(json.response)
        createChart(JSON.parse(json.response));
    });
});
*/



function brushed() {
    x.domain(brush.empty() ? x2.domain() : brush.extent());
    focus_area.selectAll(".line").attr("d", function(d) { return line(d.prices); });
    d3.selectAll(".dot")
        .attr("cx", function(d) { return x(d.date); })
        .attr("cy", function(d) { return y(d.price); });
    focus_area.select(".x.axis").call(xAxis);
    focus_area.selectAll(".barHover").attr("class", "bar");
    focus_area.selectAll(".bar").attr("x", function(d) { return x(d.date) - (barWidth - 1)/2; });
    focus_area.selectAll(".bartext").attr("x", function(d) { return x(d.date); });
}

// Taken from crossfilter (http://square.github.com/crossfilter/)
function resizePath(d) {
    var e = +(d == 'e'),
        x = e ? 1 : -1,
        y = 30;
    return 'M' + (.5 * x) + ',' + y
        + 'A6,6 0 0 ' + e + ' ' + (6.5 * x) + ',' + (y + 6)
        + 'V' + (2 * y - 6)
        + 'A6,6 0 0 ' + e + ' ' + (.5 * x) + ',' + (2 * y)
        + 'Z'
        + 'M' + (2.5 * x) + ',' + (y + 8)
        + 'V' + (2 * y - 8)
        + 'M' + (4.5 * x) + ',' + (y + 8)
        + 'V' + (2 * y - 8);
}