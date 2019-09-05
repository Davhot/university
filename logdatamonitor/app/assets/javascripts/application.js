// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery-3.2.1.min
//= require jquery-ui.min
//= require bootstrap
//= require bootstrap-growl.min
//= require moment
//= require bootstrap-datetimepicker
//= require moment/ru
//= require d3.v3.min
//= require c3.min
//= require_tree .

function humanFileSize(size) {
  size *= 1024;
  if(size <= 0) { return size }
  var i = Math.floor( Math.log(size) / Math.log(1024) );
  return ( size / Math.pow(1024, i) ).toFixed(2) + ' ' + ['B', 'kB', 'MB', 'GB', 'TB'][i];
};

function roundToSix(num) {
    return +(Math.round(num + "e+6")  + "e-6");
}

function bytes_to_megabytes(size) {
  return roundToSix(size / Math.pow(1024, 2)) + ' ' + 'MB';
};

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
};
