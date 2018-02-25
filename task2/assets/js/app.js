// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import $ from "jquery";
// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
function start(task_id) {
  let text = JSON.stringify({
    timeblock: {
      start_time: Date.now(),
      end_time: Date.now(),
      task_id: task_id
    },
  })

  $.ajax(start_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { set_button(resp.data.id) },
  });
}

function end(block_id) {
  let text = JSON.stringify({
    timeblock: {
      end_time: Date.now()
    },
  })
  $.ajax(start_path + "/" + block_id, {
    method: "put",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { set_button(resp.data.id) },
  })
}


function set_button(block_id) {
  let btn = $("#start-button")
  if (!btn.data("start")) {
    btn.data("start", true);
    btn.data("block_id", block_id)
  } else {
    btn.data("start", false);
    getBlock(block_id);
  }
  update_button();
}

function update_button() {
  let btn = $("#start-button")
  if (!btn.data("start")) {
    btn.text("Start Working")
    btn.attr('class', 'btn btn-primary')
  } else {
    btn.text("Stop Working ")
    btn.attr('class', 'btn btn-warning')
  }
}

function getBlock(block_id) {
  $.ajax(start_path + "/" + block_id, {
    method: "get",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: "",
    success: (resp) => { showBlock(resp.data) },
  })
}

function showBlock(data) {
  let start_time = data.start_time;
  let end_time = data.end_time;
  let start_utc = new Date(start_time).toISOString().substr(0, 19).replace("T"," ")
  let end_utc = new Date(end_time).toISOString().substr(0, 19).replace("T"," ")
  let spent_minutes = Math.floor(((end_time - start_time)/1000/60) << 0);
  let spent_time = spent_minutes + "minutes "
  let item = "<tr class='block-row' id='b" + data.id + "'><td><strong>" + start_utc +"Z" + "</strong></td><td><strong>"
              + end_utc +"Z" + "</strong></td><td><strong>" + spent_time  + "</strong></td><td>"
              + "<span><button onclick='edit_start(" + data.id + ")' class='btn btn-warning btn-xs'>Edit Start Time</button></span>"
              + "<span><button onclick='edit_end(" + data.id + ")' class='btn btn-warning btn-xs'>Edit End Time</button></span>"
              + "<span><button onclick='delete_block(" + data.id + ")' class='btn btn-danger btn-xs'>Delete</button></span>"
              +"</td></tr>"
  $("#blocks").append(item)
}

window.delete_block = function(block_id) {
  $.ajax(start_path + "/" + block_id, {
    method: "delete",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: "",
    success: (resp) => { $("#b" + block_id).remove() },
  })
}

window.edit_start = function(block_id) {
  $("#edit-block").append("<div class='row'>"
  + "<div class='col-9'><label for='start-time-input'>Input start Time (Your input must follow YYYY-MM-DDTHH:MM:SS, Like: 2018-01-01T03:24:00)</label>"
  +"<input type='text' id='start-time-input' class='form-control'></div>"
  + "<div class='col-3'><button class='btn btn-primary btn-lg' onclick='update_start(" + block_id + ")'>Change</button><button class='btn btn-secondary btn-lg' onclick='location.reload()'>Cancel</button></div>"
  + "</div>")
}

window.edit_end = function(block_id) {
  $("#edit-block").append("<div class='row'>"
  + "<div class='col-9'><label for='end-time-input'>Input end Time (Your input must follow YYYY-MM-DDTHH:MM:SS, Like: 2018-01-01T03:24:00)</label>"
  +"<input type='text' id='end-time-input' class='form-control'></div>"
  + "<div class='col-3'><button class='btn btn-primary btn-lg' onclick='update_end(" + block_id + ")'>Change</button><button class='btn btn-secondary btn-lg' onclick='location.reload()'>Cancel</button></div>"
  + "</div>")
}

window.update_start = function (block_id) {
  let start_val = $("#start-time-input").val();
  let date = new Date(""+start_val)
  if (isNaN(date.getTime())) {
    $("#warnning").append("<p>Your input is Invalid, Please follow the rule</p>")
  }
  let text = JSON.stringify({
    timeblock: {
      start_time: date.getTime() - 1000*60*60*5
    },
  })
  $.ajax(start_path + "/" + block_id, {
    method: "put",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { location.reload() },
  })
}

window.update_end = function (block_id) {
  let end_val = $("#end-time-input").val();
  let date = new Date(""+end_val)
  if (isNaN(date.getTime())) {
    $("#warnning").append("<p>Your input is Invalid, Please follow the rule</p>")
  }
  let text = JSON.stringify({
    timeblock: {
      end_time: date.getTime() - 1000*60*60*5
    },
  })
  $.ajax(start_path + "/" + block_id, {
    method: "put",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => { location.reload() },
  })
}

function start_click(ev) {
  let btn = $(ev.target);
  if (!btn.data("start")) {
    start(task_id)
  } else {
    end(btn.data("block_id"))
  }
}

window.add_time_block = function () {
  console.log("click!!!")
  let start_val = $("#add-start-time").val();
  let end_val = $("#add-end-time").val();
  let startDate = new Date("" + start_val);
  let endDate = new Date("" + end_val);
  if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
    $("#add-time-warnning").css("color", "red")
    $("#add-time-warnning").text("Your input is Invalid, Please follow the rule")
  }
  let text = JSON.stringify({
    timeblock: {
      start_time: startDate.getTime(),
      end_time: endDate.getTime(),
      task_id: task_id
    },
  })

  $.ajax(start_path, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => {
      $("#add-start-time").val("")
      $("#add-end-time").val("")
      $("#add-time-warnning").css("color", "green")
      $("#add-time-warnning").text("Success!")
      showBlock(resp.data)
     },
  });

}

function init_start() {
  if (!$('#start-button')) {
    return;
  }
  let rows = $(".block-row")
  for (let i = 0; i < rows.length; i++) {
    let block_id = $(rows[i]).attr('id').substr(1)
    $(rows[i]).append("<td>"
     + "<span><button onclick='edit_start(" + block_id + ")' class='btn btn-warning btn-xs'>Edit Start Time</button>"
     + "<span><button onclick='edit_end(" + block_id + ")' class='btn btn-warning btn-xs'>Edit End Time</button>"
     + "<span><button onclick='delete_block(" + block_id + ")' class='btn btn-danger btn-xs'>Delete</button></span>"
     + "</span></td>")
  }
  $("#start-button").click(start_click);
}

$(init_start)
