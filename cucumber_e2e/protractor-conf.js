exports.config = {
  baseUrl: 'http://geoportalentst.lmv.lm.se:9080/geonetwork/srv/eng/catalog.search?view=swe#/search?',
  seleniumAddress: 'http://localhost:4444/wd/hub',
    getPageTimeout: 60000,
  allScriptsTimeout: 500000,
  framework: 'custom',
  frameworkPath: 'node_modules/protractor-cucumber-framework',
  specs: [
	'features/web.feature'
,'features/Sok_Enkel_vy.feature'
,'features/sok_advance_view.feature'
  ],
  cucumberOpts: {
    require: [
		'features/steps/web.steps.js',
    'features/steps/Sok_Enkel_vy.steps.js',
    'features/steps/Sok_advance_view.steps.js'
],

    format: 'pretty',
	keepAlive: false,
   tags: '~@qa_ready'
  }
};
