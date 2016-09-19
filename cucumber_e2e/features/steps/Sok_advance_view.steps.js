
//http://chaijs.com/
var chai = require('chai');

//https://github.com/domenic/chai-as-promised/
var chaiAsPromised = require('chai-as-promised');
chai.use(chaiAsPromised);
var expect = chai.expect;
var AdvanceView = require('../pages/advance_filter.js');
module.exports = function() {

	 advanceView = new AdvanceView();


       this.Given(/^that the user is in Advance vy$/, function (callback) {
         // Write code here that turns the phrase above into concrete actions
         callback(null, 'pending');
       });



}
