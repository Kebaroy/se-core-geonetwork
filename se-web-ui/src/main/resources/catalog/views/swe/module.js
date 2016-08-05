/*
 * Copyright (C) 2001-2016 Food and Agriculture Organization of the
 * United Nations (FAO-UN), United Nations World Food Programme (WFP)
 * and United Nations Environment Programme (UNEP)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 *
 * Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
 * Rome - Italy. email: geonetwork@osgeo.org
 */

(function() {

  goog.provide('gn_search_swe');






  goog.require('cookie_warning');
  goog.require('gn_related_directive');
  goog.require('gn_resultsview');
  goog.require('gn_search');
  goog.require('swe_directives');
  goog.require('swe_search_config');

  var module = angular.module('gn_search_swe', [
    'gn_related_directive', 'gn_search',
    'gn_resultsview', 'cookie_warning',
    'swe_search_config', 'swe_directives']);

  module.controller('gnsSwe', [
    '$scope',
    '$location',
    'suggestService',
    '$http',
    '$window',
    '$translate',
    'gnUtilityService',
    'gnSearchSettings',
    'gnViewerSettings',
    'gnMap',
    'gnMdView',
    'gnMdViewObj',
    'gnWmsQueue',
    'gnSearchLocation',
    'gnOwsContextService',
    'hotkeys',
    'gnGlobalSettings',
    function($scope, $location, suggestService, $http, $window, $translate,
             gnUtilityService, gnSearchSettings, gnViewerSettings,
             gnMap, gnMdView, mdView, gnWmsQueue,
             gnSearchLocation, gnOwsContextService,
             hotkeys, gnGlobalSettings) {

      var viewerMap = gnSearchSettings.viewerMap;
      var searchMap = gnSearchSettings.searchMap;

      $scope.viewMode = 'full';

      $scope.modelOptions = angular.copy(gnGlobalSettings.modelOptions);
      $scope.modelOptionsForm = angular.copy(gnGlobalSettings.modelOptions);
      $scope.gnWmsQueue = gnWmsQueue;
      $scope.$location = $location;
      $scope.activeTab = '/home';
      $scope.resultTemplate = gnSearchSettings.resultTemplate;
      $scope.facetsSummaryType = gnSearchSettings.facetsSummaryType;
      $scope.location = gnSearchLocation;
      $scope.toggleMap = function() {
        $(searchMap.getTargetElement()).toggle();
      };
      hotkeys.bindTo($scope)
          .add({
            combo: 'h',
            description: $translate('hotkeyHome'),
            callback: function(event) {
              $location.path('/home');
            }
          }).add({
            combo: 't',
            description: $translate('hotkeyFocusToSearch'),
            callback: function(event) {
              event.preventDefault();
              var anyField = $('#gn-any-field');
              if (anyField) {
                gnUtilityService.scrollTo();
                $location.path('/search');
                anyField.focus();
              }
            }
          }).add({
            combo: 'enter',
            description: $translate('hotkeySearchTheCatalog'),
            allowIn: 'INPUT',
            callback: function() {
              $location.search('tab=search');
            }
            //}).add({
            //  combo: 'r',
            //  description: $translate('hotkeyResetSearch'),
            //  allowIn: 'INPUT',
            //  callback: function () {
            //    $scope.resetSearch();
            //  }
          }).add({
            combo: 'm',
            description: $translate('hotkeyMap'),
            callback: function(event) {
              $location.path('/map');
            }
          });


      // TODO: Previous record should be stored on the client side
      $scope.mdView = mdView;
      gnMdView.initMdView();
      $scope.goToSearch = function(any) {
        $location.path('/search').search({'any': any});
      };
      $scope.canEdit = function(record) {
        // TODO: take catalog config for harvested records
        if (record && record['geonet:info'] &&
            record['geonet:info'].edit == 'true') {
          return true;
        }
        return false;
      };
      $scope.openRecord = function(index, md, records) {
        gnMdView.feedMd(index, md, records);
      };

      $scope.closeRecord = function() {
        gnMdView.removeLocationUuid();
      };
      $scope.nextRecord = function() {
        // TODO: When last record of page reached, go to next page...
        $scope.openRecord(mdView.current.index + 1);
      };
      $scope.previousRecord = function() {
        $scope.openRecord(mdView.current.index - 1);
      };

      $scope.infoTabs = {
        lastRecords: {
          title: 'lastRecords',
          titleInfo: '',
          active: true
        },
        preferredRecords: {
          title: 'preferredRecords',
          titleInfo: '',
          active: false
        }};

      // Set the default browse mode for the home page
      $scope.$watch('searchInfo', function() {
        if (angular.isDefined($scope.searchInfo.facet)) {
          if ($scope.searchInfo.facet['inspireThemes'].length > 0) {
            $scope.browse = 'inspire';
          } else if ($scope.searchInfo.facet['topicCats'].length > 0) {
            $scope.browse = 'topics';
            //} else if ($scope.searchInfo.facet['categories'].length > 0) {
            //  $scope.browse = 'cat';
          }
        }
      });

      $scope.resultviewFns = {
        addMdLayerToMap: function(link, md) {

          if (gnMap.isLayerInMap(viewerMap,
              link.name, link.url)) {
            return;
          }
          gnMap.addWmsFromScratch(viewerMap, link.url, link.name, false, md);
        },
        addAllMdLayersToMap: function(layers, md) {
          angular.forEach(layers, function(layer) {
            $scope.resultviewFns.addMdLayerToMap(layer, md);
          });
        },
        loadMap: function(map, md) {
          gnOwsContextService.loadContextFromUrl(map.url, viewerMap);
        }
      };

      // Manage route at start and on $location change
      if (!$location.path()) {
        $location.path('/home');
      }
      $scope.activeTab = $location.path().
          match(/^(\/[a-zA-Z0-9]*)($|\/.*)/)[1];


      $scope.showMetadata = function(index, md, records) {
        angular.element('.geodata-row-popup').addClass('show');
        $scope.$emit('body:class:add', 'show-overlay');
        gnMdView.feedMd(index, md, records);
      };

      /**
       * Show full view results.
       */
      $scope.setFullViewResults = function() {
        angular.element('.geo-data-row').removeClass('compact-view');
        angular.element('.detail-view').addClass('active');
        angular.element('.compact-view').removeClass('active');
        $scope.viewMode = 'full';
      };

      /**
       * Show compact view results.
       */
      $scope.setCompactViewResults = function() {
        angular.element('.geo-data-row').addClass('compact-view');
        angular.element('.compact-view').addClass('active');
        angular.element('.detail-view').removeClass('active');
        $scope.viewMode = 'compact';
      };

      /**
       * Show map panel.
       */
      $scope.showMapPanel = function() {
        angular.element('.floating-map-cont').hide();
        $scope.$emit('body:class:add', 'small-map-view');
      };

      /**
       * Hide map panel.
       */
      $scope.hideMapPanel = function() {
        angular.element('.floating-map-cont').show();
        $scope.$emit('body:class:remove', 'small-map-view');
        $scope.$emit('body:class:remove', 'full-map-view');
        $scope.$emit('body:class:remove', 'medium-map-view');
      };

      $scope.resizeMapPanel = function() {
        var $b = angular.element(document).find('body');
        window_width = angular.element($window).width(),
        $map_data_list_cont = angular.element('.map-data-list-cont'),
        is_side_data_bar_open =
            ($map_data_list_cont.hasClass('open')) ? true : false,
        is_full_view_map = ($b.hasClass('full-map-view')) ? true : false,
        $data_list_cont = angular.element('.data-list-cont'),
        $map_cont = angular.element('.map-cont'),
        $obj = angular.element('#map-panel-resize');

        if (is_full_view_map) {
          if (is_side_data_bar_open) {
            $scope.$emit('body:class:remove', 'full-map-view');
            $scope.$emit('body:class:add', 'medium-map-view');
          } else {
            $scope.$emit('body:class:remove', 'full-map-view');
            $scope.$emit('body:class:add', 'small-map-view');
          }

          $obj.removeClass('small').addClass('full');
        } else {
          $scope.$emit('body:class:remove', 'medium-map-view');
          $scope.$emit('body:class:remove', 'small-map-view');
          $scope.$emit('body:class:add', 'full-map-view');

          if (is_side_data_bar_open) {
            $map_cont.css({
              width: (window_width - $data_list_cont.width())
            });
          } else {
            $map_cont.css({
              width: window_width
            });
          }
          $obj.removeClass('full').addClass('small');
        }
        return false;
      };

      $scope.$on('$locationChangeSuccess', function(next, current) {
        $scope.activeTab = $location.path().
            match(/^(\/[a-zA-Z0-9]*)($|\/.*)/)[1];

        if (gnSearchLocation.isSearch() && (!angular.isArray(
            searchMap.getSize()) || searchMap.getSize()[0] < 0)) {
          setTimeout(function() {
            searchMap.updateSize();

            // TODO: load custom context to the search map
            //gnOwsContextService.loadContextFromUrl(
            //  gnViewerSettings.defaultContext,
            //  searchMap);

          }, 0);
        }
        if (gnSearchLocation.isMap() && (!angular.isArray(
            viewerMap.getSize()) || viewerMap.getSize().indexOf(0) >= 0)) {
          setTimeout(function() {
            viewerMap.updateSize();
          }, 0);
        }
      });

      angular.extend($scope.searchObj, {
        advancedMode: false,
        from: 1,
        to: 30,
        viewerMap: viewerMap,
        searchMap: searchMap,
        mapfieldOption: {
          relations: ['within']
        },
        defaultParams: {
          'facet.q': '',
          resultType: gnSearchSettings.facetsSummaryType || 'details'
        },
        params: {
          'facet.q': '',
          resultType: gnSearchSettings.facetsSummaryType || 'details'
        }
      }, gnSearchSettings.sortbyDefault);

    }]);

  /**
   * Controller for the login page popup.
   */
  module.controller('SweLoginController',
      ['$scope', '$http', '$rootScope', '$translate',
       '$location', '$window', '$timeout',
       'gnUtilityService', 'gnConfig',
       function($scope, $http, $rootScope, $translate,
               $location, $window, $timeout,
               gnUtilityService, gnConfig) {
         $scope.formAction = '../../j_spring_security_check#' +
          $location.path();

         $scope.formData = {};

         $scope.redirectUrl = gnUtilityService.getUrlParameter('redirect');
         $scope.signinFailure = gnUtilityService.getUrlParameter('failure');
         $scope.gnConfig = gnConfig;

         // TODO: https://github.com/angular/angular.js/issues/1460
         // Browser autofill does not work properly
         $timeout(function() {
           $('input[data-ng-model], select[data-ng-model]').each(function() {
             angular.element(this).controller('ngModel')
              .$setViewValue($(this).val());
           });
         }, 300);

         /**
         * Ajax login.
         */
         $scope.login = function() {

           $http({method: 'POST',
              url: '../../j_spring_security_check',
              data: $.param($scope.formData),
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Ajax-call': true}})
            .success(function(data) {
              // Redirect to home page
              window.location.href = '../../catalog.search?view=swe';
            })
            .error(function(data) {
              // Show error message
              alert('Error');
            });
         };

       }]);


  /**
   * Controller for the landing page popup.
   *
   */
  module.controller('SweLandingPageWarningController', [
    '$cookies', '$scope',
    function($cookies, $scope) {

      $scope.hideLandingPage = true;

      $scope.init = function() {
        var hiddenLandingPage = window.localStorage.getItem('hideLandingPage');

        if (hiddenLandingPage) {
          angular.element('#landing-popup').removeClass('show');
        } else {
          angular.element('#landing-popup').addClass('show');
          $scope.$emit('body:class:add', 'show-overlay');
        }
      };

      $scope.close = function() {
        if ($scope.hideLandingPage) {
          window.localStorage.setItem('hideLandingPage', true);
        }
        angular.element('#landing-popup').removeClass('show');
        $scope.$emit('body:class:remove', 'show-overlay');
      };
    }]);


  /**
   * Controller for the filter panel.
   *
   */
  module.controller('SweFilterPanelController', ['$scope',
    function($scope) {

      $scope.open = false;
      $scope.advancedMode = false;

      $scope.toggleFilterPanel = function() {
        if ($scope.open) {
          angular.element(".site-filter-cont").removeClass('open');
        } else {
          angular.element(".site-filter-cont").addClass('open');
        }

        $scope.open = !$scope.open;
      };

      $scope.toggleAdvancedOptions = function() {
        if ($scope.advancedMode) {
          angular.element(".filter-options-cont").removeClass('open');
          angular.element(".site-filter-cont").removeClass('advanced');
        } else {
          angular.element(".filter-options-cont").addClass('open');
          angular.element(".site-filter-cont").addClass('advanced');
        }

        $scope.advancedMode = !$scope.advancedMode;
      };


      $scope.closeFilterPanel = function() {
        angular.element(".site-filter-cont").removeClass('open');

        $scope.open = false
      };
    }]);

})();
