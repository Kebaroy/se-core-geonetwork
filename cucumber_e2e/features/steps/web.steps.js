//http://chaijs.com/
var chai = require('chai');

//https://github.com/domenic/chai-as-promised/
var chaiAsPromised = require('chai-as-promised');
chai.use(chaiAsPromised);

var expect = chai.expect;
module.exports = function() {
	//this.World = require(process.cwd() + '/features/support/world').World;


 this.Given(/^I go on "([^"]*)"$/, function (arg1, callback) {
 
	browser.get('http://geoportalentst.lmv.lm.se:9080/geonetwork/srv/eng/catalog.search?view=swe#/search?');
	browser.ignoreSynchronization = true;
	browser.findElement(by.xpath("//*[contains(text(),'börja använda geodataportalen')]")).click();
	
	// browser.findElement(by.xpath("//*[contains(text(),'visa filtrering')]")).click();
	
	//browser.findElement(by.css('filter-toggle-link opens-filter-section')).click();
	// browser.pause();
	expect(browser.getTitle()).to.eventually.equal(arg1).and.notify(callback);
		
   // callback();
	
  });

  this.Then(/^the title should equal "([^"]*)"$/, function (arg1, callback) {
  expect(browser.getTitle()).to.eventually.equal(arg1).and.notify(callback);
  	
  });
   
  

   
}

     