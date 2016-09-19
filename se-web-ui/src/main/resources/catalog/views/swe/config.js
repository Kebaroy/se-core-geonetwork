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

  goog.provide('swe_search_config');

  var module = angular.module('swe_search_config',
      ['pascalprecht.translate']);
  //var module = angular.module('swe_search_config', []);


  module.run(['gnSearchSettings', 'gnViewerSettings',
    'gnOwsContextService', 'gnMap',
    function(gnSearchSettings, gnViewerSettings,
             gnOwsContextService, gnMap) {

      gnViewerSettings.defaultContext = null;

      // Keep one layer in the background
      // while the context is not yet loaded.
      gnViewerSettings.bgLayers = [
        gnMap.createLayerForType('osm')
      ];

      gnViewerSettings.servicesUrl =
          gnViewerSettings.mapConfig.listOfServices || {};

      // WMS settings
      gnViewerSettings.singleTileWMS = true;

      var bboxStyle = new ol.style.Style({
        stroke: new ol.style.Stroke({
          color: 'rgba(255,0,0,1)',
          width: 2
        }),
        fill: new ol.style.Fill({
          color: 'rgba(255,0,0,0.3)'
        })
      });

      gnSearchSettings.olStyles = {
        drawBbox: bboxStyle,
        mdExtent: new ol.style.Style({
          stroke: new ol.style.Stroke({
            color: 'orange',
            width: 2
          })
        }),
        mdExtentHighlight: new ol.style.Style({
          stroke: new ol.style.Stroke({
            color: 'orange',
            width: 3
          }),
          fill: new ol.style.Fill({
            color: 'rgba(255,255,0,0.3)'
          })
        })

      };

      // Object to store the current Map context
      gnViewerSettings.storage = 'sessionStorage';

      // -1199982.87894;4699997.48693
      // 617761.505804;7968053.15247

      var extent = [-1200000, 4700000, 2540000, 8500000];
      var resolutions = [4096.0, 2048.0, 1024.0, 512.0, 256.0,
        128.0, 64.0, 32.0, 16.0, 8.0];
      var matrixIds = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

      proj4.defs(
          'EPSG:3006',
          '+proj=utm +zone=33 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 ' +
          '+units=m +axis=neu +no_defs');
      ol.proj.get('EPSG:3006').setExtent(extent);
      ol.proj.get('EPSG:3006').setWorldExtent([-5.05651650131, 40.6662879582,
        28.0689828648, 71.7832476487]);
      var projection = ol.proj.get('EPSG:3006');

      var tileGrid = new ol.tilegrid.WMTS({
        tileSize: 256,
        extent: extent,
        resolutions: resolutions,
        matrixIds: matrixIds
      });

      var apiKey = 'a9a380d6b6f25f22e232b8640b05ea8';

      var wmts = [new ol.layer.Tile({
        extent: extent,
        source: new ol.source.WMTS({
          url: 'https://api.lantmateriet.se/open/topowebb-ccby/' +
              'v1/wmts/token/' + apiKey + '/',
          layer: 'topowebb',
          format: 'image/png',
          matrixSet: '3006',
          tileGrid: tileGrid,
          version: '1.0.0',
          style: 'default',
          crossOrigin: 'anonymous'
        })
      })];


      /*******************************************************************
       * Define maps
       */
      var mapsConfig = {
        resolutions: resolutions,
        extent: extent,
        projection: projection,
        center: [572087, 6802255],
        zoom: 0
      };

      // Add backgrounds to TOC
      gnViewerSettings.bgLayers = wmts;
      gnViewerSettings.servicesUrl = {};

      var interactions = ol.interaction.defaults({
        altShiftDragRotate: false,
        pinchRotate: false
      });

      var viewerMap = new ol.Map({
        controls: [],
        interactions: interactions,
        view: new ol.View(mapsConfig)
      });

      var searchMap = new ol.Map({
        controls: [],
        layers: wmts,
        interactions: interactions,
        view: new ol.View(mapsConfig)
      });

      /** Facets configuration */
      gnSearchSettings.facetsSummaryType = 'swe-details';

      /*
       * Hits per page combo values configuration. The first one is the
       * default.
       */
      gnSearchSettings.hitsperpageValues = [20, 50, 100];

      /* Pagination configuration */
      gnSearchSettings.paginationInfo = {
        hitsPerPage: gnSearchSettings.hitsperpageValues[0]
      };

      gnSearchSettings.sortbyValues = [{
        sortBy: 'changeDate',
        sortOrder: ''
      }, {
        sortBy: 'title',
        sortOrder: 'reverse'
      }];

      /* Default search by option */
      gnSearchSettings.sortbyDefault = gnSearchSettings.sortbyValues[0];

      gnSearchSettings.resultTemplate = '../../catalog/views/swe/' +
          'templates/resultList.html';

      // Mapping for md links in search result list.
      gnSearchSettings.linkTypes = {
        //links: ['LINK', 'kml'],
        links: ['HTTP:Information'],
        downloads: ['HTTP:Nedladdning', 'HTTP:OGC:WFS'],
        //layers:['OGC', 'kml'],
        layers: ['HTTP:OGC:WMS'],
        maps: ['ows']
      };

      // Set custom config in gnSearchSettings
      angular.extend(gnSearchSettings, {
        viewerMap: viewerMap,
        searchMap: searchMap
      });
    }
  ]);


  /*module.config(['$LOCALES', function($LOCALES) {
    $LOCALES.push('../../catalog/views/swe/locales/|search');
  }]);*/

  module.config(['$LOCALES', function($LOCALES) {
    $LOCALES.push('../../catalog/views/swe/locales/|search');
    $LOCALES.push('/../api/0.1/standard/iso19139.swe/' +
        'codelists/gmd%3ACI_RoleCode');
    $LOCALES.push('/../api/0.1/standard/iso19139.swe/' +
        'codelists/gmd%3ACI_DateTypeCode');

  }]);

})();
