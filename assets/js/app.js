// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"

import socket from "./socket"

let data = document.getElementById('data');
let name = data.attributes.name;

let channelLocal = socket.channel('room:lobby', {}); // connect to chat "room"
let channelUser = socket.channel('user:'+name.value, {})

channelLocal.on('shout', function (payload) { // listen to the 'shout' event
  let li = document.createElement("li"); // create new list item DOM element
  let name = payload.name || 'guest';    // get name from payload or set default
  li.innerHTML = '<b>' + name + '</b>: ' + payload.message; // set li contents
  ul.appendChild(li);                    // append to list
});

channelLocal.on('command', function (payload) {  // listen to the 'command' event
  let li = document.createElement("li");    // set color to blue
  li.setAttribute("style", "color: blue;");
  let name = payload.name || 'guest';
  li.innerHTML = '<b>' + name + '</b>: ' + payload.message;
  ul.appendChild(li);
})

channelUser.on('shout', function (payload) {
  let li = document.createElement("li");
  li.setAttribute("style", "color: blue;");
  let name = payload.name || 'guest' ;
  li.innerHTML = '<b>' + name + '</b>: ' + payload.message;
  ul.appendChild(li);
})

channelUser.on('miss', function(payload) {
  console.log(payload);
})

channelLocal.join()
  .receive("ok", resp => { console.log("Joined successfully", resp)})
  .receive("error", resp => { console.log("Unable to join", resp)})

channelUser.join()
  .receive("ok", resp => {console.log("Joined successfully", resp)})
  .receive("error", resp => {console.log("Unable to join", resp)})

let ul = document.getElementById('msg-list');        // list of messages.         // name of message sender
let msg = document.getElementById('msg');            // message input field

// "listen" for the [Enter] keypress event to send a message:
msg.addEventListener('keypress', function (event) {
  if (event.keyCode == 13 && msg.value.length > 0) { // don't sent empty msg.

    if(!msg.value.startsWith("/")){ // If the message is not a command 
      channelLocal.push('shout', { // send the message to the server on "shout" channel
        name: name.value,     // get value of "name" of person sending the message
        message: msg.value    // get message text (value) from msg input field.
      });
    } else {
      // If the message is a command
      const args = msg.value.slice(1).trim().split(/ +/); // Splice the arguments, trim the prefix
      const command = args.shift().toLowerCase(); // Retrieve the command
      if (command === "whisper" || command == "w"){ // Whisper command to talk privately to someone
        let toUser = args.shift();
        console.log("Send to " + toUser);
        channelUser.push('whisper', {dest: toUser, name: name.value, message: args.join(" ")});
      }
    }
    msg.value = '';         // reset the message input field for next message.
  }
});