(function(window, angular, undefined) {'use strict';

angular.module('gs.preloaded', [])
.directive('script', ['$preloaded', function ($preloaded) {
  return {
    restrict: 'E',
    link: function (scope, el, attrs) {
      var data;

      if (attrs.type !== 'text/preloaded') {
        return;
      }

      data = JSON.parse(el.text());

      if (attrs.hasOwnProperty('name')) {
        $preloaded[attrs.name] = data;
      } else {
        angular.extend($preloaded, data);
      }
    }
  };
}])

.constant('$preloaded', {});

})(window, window.angular);
