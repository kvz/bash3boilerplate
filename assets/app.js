require('./main.js')
require('./style.css')
require('./syntax.css')

// check if HMR is enabled
if (module.hot) {
  module.hot.accept('./main.js', function () {
    require('./main.js');
  });
  module.hot.accept('./style.css', function () {
    require('./style.css');
  });
}
