describe('angular-preloaded', function () {
  beforeEach(function () {
    angular.module('FakeCtrl', [])
    .controller('FakeCtrl', function ($scope, $preloaded) {
      $scope.preloaded = $preloaded;
    });

    module('gs.preloaded', 'FakeCtrl');
  });

  var $scope;

  beforeEach(inject(function ($rootScope, $compile, $controller) {
    $scope = $rootScope.$new();
    $compile('<script type="text/preloaded">{ "a": 1 }</script>')($rootScope);
    $compile('<script type="text/preloaded">{ "b": 2 }</script>')($rootScope);
    $compile('<script type="text/preloaded" name="c">{ "d": 3 }</script>')($rootScope);
    $compile('<script type="text/preloaded" data-name="e">{ "f": 4 }</script>')($rootScope);
    $controller('FakeCtrl', { $scope: $scope });
  }));

  it('injects preloaded data to controllers', function () {
    expect($scope.preloaded).toEqual({a: 1, b: 2, c: { d: 3}, e: { f: 4 }});
  });
});
