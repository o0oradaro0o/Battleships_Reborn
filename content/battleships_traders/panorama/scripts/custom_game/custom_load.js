"use strict";
var hidden = true;

var currentlearn = 1;
var maxpages = 12;

$.Schedule(10, next);

function prev() {
  try {
    $("#learn" + currentlearn).style.width = "0%";
    if (currentlearn == 1) {
      currentlearn = maxpages;
    } else {
      currentlearn--;
    }
  
    $("#learn" + currentlearn).style.width = "100%";
  
    $("#pageCountLabel").text = currentlearn + "/" + maxpages;
  } catch (error) {
    console.error(error);
    // Expected output: ReferenceError: nonExistentFunction is not defined
    // (Note: the exact output may be browser-dependent)
  }

}
function next() {
  try {
    $("#learn" + currentlearn).style.width = "0%";
    if (currentlearn == maxpages) {
      currentlearn = 1;
    } else {
      currentlearn++;
    }
  
    $("#learn" + currentlearn).style.width = "100%";
    $("#pageCountLabel").text = currentlearn + "/" + maxpages;
  } catch (error) {
    console.error(error);
    // Expected output: ReferenceError: nonExistentFunction is not defined
    // (Note: the exact output may be browser-dependent)
  }

}
