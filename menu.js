// Variable holding the full path to the root of the website
var root = [].slice.call(document.getElementsByTagName("script")).pop().src.split("/").slice(0, -1).join("/") + "/";

// The next function and the handler are not used at the moment, but they have proved to be
// nice in case you want sub-menus, so we leave them in for now.
function percentageVisible(el) {
  var rect = el.getBoundingClientRect();
  windowHeight = (window.innerHeight || document.documentElement.clientHeight);
  ymin = Math.min(Math.max(rect.top, 0), windowHeight);
  ymax = Math.min(Math.max(rect.bottom, 0), windowHeight);
  return 100. * (ymax - ymin) / windowHeight;
}

handler = function() {
  var sections = document.getElementsByClassName("section");
  var section = null;
  var maxPercentage = 0;
  for (i = 0; i < sections.length; i++) {
    var percentage = percentageVisible(sections[i]);
    if (percentage > maxPercentage) {
      section = sections[i];
      maxPercentage = percentage;
    }
  }
  var toChange = null;
  $("nav[data-nav-helper='true']").find("li").children("a").each(function() {
    if ($(this).attr("href") === window.location.href.split('#')[0]) {
      if ($(this).children("span.location").length > 0) {
        toChange = $(this).children("span.location")[0];
      }
    }
  });
  if (toChange != null) {
    if (section == null) {
      toChange.innerHTML = "";
    } else {
      toChange.innerHTML = section.dataset.shorthand;
    }
  }
}
$(window).on('DOMContentLoaded load resize scroll', handler);

document.write(''+
'<nav id="nav" class="navbar navbar-inverse navbar-fixed-top" data-nav-helper="true">'+
'  <div id="menu" class="container">'+
'        <div  class="navbar-header">'+
'  <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#dropit">'+
'    <span class ="sr-only"> Show and Hide the Navigation</span>'+
'    <span class="icon-bar"></span>'+
'    <span class="icon-bar"></span>'+
'    <span class="icon-bar"></span>'+
'  </button>'+
'      <a class="navbar-brand" href="' +root+'index.html"><img class="logo" src="'+root+'images/logo/einstein_right.svg" alt="ETK"></a>'+
'      <!--see https://developer.mozilla.org/en-US/docs/Web/HTML/Element/img -->'+
'      <a class="navbar-brand" href="' +root+'index.html"><img class="logo" srcset="'+root+'images/logo/logo-white.png 400w, '+root+'images/logo/logo-white-300.png 300w, '+root+'images/logo/logo-white-200.png 200w, '+root+'images/logo/logo-white-100.png 100w, '+root+'images/logo/logo-white-75.png 75w, '+root+'images/logo/logo-white-50.png 50w" src="'+root+'images/logo/logo-white-266.png"  alt="ETK"></a>'+
'  </div>'+
'  <div class="container collapse navbar-collapse" id="dropit">'+
''+
'    <ul class="nav navbar-nav">'+
'      <li ><a class="main-menu text" href="'+root+'index.html">Home</a></li>'+
'      <li ><a class="main-menu text" href="'+root+'about.html">About</a></li>'+
'      <li ><a  class="main-menu" href="'+root+'download.html">Download</a></li>'+
'      <li ><a  class="main-menu" href="'+root+'documentation.html">Documentation</a></li>'+
'      <li ><a  class="main-menu" href="'+root+'support.html">Help!</a></li>'+
'      <li ><a  class="main-menu" href="'+root+'contribute.html">Contribute</a></li>'+
'      <li ><a  class="main-menu" href="'+root+'gallery.html">Gallery</a></li>'+
'    </ul>'+
'  </div>'+
'  </div>'+
''+
'</nav>');

// Highlight the menu entry that links to this page
$(function () {
    $("nav[data-nav-helper='true']").find("li").children("a").each(function () {
        var linkfile = $(this).attr("href").split(root)[1].split("#")[0];
        if (linkfile === window.location.pathname.split('/').pop()) {
            $(this).parent().addClass("active");
        } else {
            $(this).parent().removeClass("active");
        }
    })});

$(document).ready(function() {
  $(".navbar-nav li ul li a ").click(function(event) {
    $(".navbar-collapse").collapse('hide');
  });
});

