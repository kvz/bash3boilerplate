// Backgrounds.
// var backgrounds = [1,2,3,4,5,6]
var backgrounds = [1]

// Highlighting.
hljs.initHighlighting()

// Storage.
var store = window.sessionStorage

// Background.
var background = store.getItem('background')

if (!background) {
  var i = Math.random() * backgrounds.length | 0
  background = backgrounds[i]
  console.log('setting background to %s', background)
  store.setItem('background', background)
}

// Body class for background.
var el = document.getElementById('header-overlay')
el.style.backgroundImage = 'url(/assets/images/' + background + '.jpg)'

// Attach class to #menu element depending on page offset.
document.addEventListener('DOMContentLoaded', chooseMenuColor)
window.onscroll = chooseMenuColor

function chooseMenuColor() {
  var menuElement = document.getElementById('menu')
  var menuTopOffset = 45
  Math.floor(window.innerHeight * .20) < window.pageYOffset + menuTopOffset ?
    menuElement.classList.remove('over-header') :
    menuElement.classList.add('over-header')
}


function $get(selector) { return document.querySelector(selector) }
function $all(selector) {
	  return Array.prototype.slice.call(document.querySelectorAll(selector))
}

var container = $get('#menu-items')

// if (location.pathname !== '/') {
//   var li = document.createElement('li');
//   li.innerHTML = '<a href="/">&laquo; Home</a>';
//   container.appendChild(li);
// }

$all('#content h2').forEach(function(el) {
  var li = document.createElement('li');
  li.innerHTML = '<a href="#' + el.id + '">' + el.innerHTML + '</a>';
  container.appendChild(li);
})
