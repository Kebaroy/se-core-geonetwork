//http://chaijs.com/
var chai = require('chai');

//https://github.com/domenic/chai-as-promised/
var chaiAsPromised = require('chai-as-promised');
chai.use(chaiAsPromised);
var expect = chai.expect;

module.exports = function() {

	//this.World = require(process.cwd() + '/features/support/world').World;
  
  this.Given(/^I go to "([^"]*)"$/, function (arg1, callback) {
	 browser.get('http://geoportalentst.lmv.lm.se:9080/geonetwork/srv/eng/catalog.search?view=swe#/search?');
	browser.ignoreSynchronization = true;
	
	
	expect(browser.getTitle()).to.eventually.equal(arg1).and.notify(callback);
	
	
  });
 this.Then(/^I type "([^"]*)" i searchfield$/, function (arg1, callback) {

  //browser.findElement(by.xpath("//*[@id='gn-any-field']")).sendKeys('Afrika');
   // Write code here that turns the phrase above into concrete actions
  // callback(null, 'pending');
 });
 

   
}

     