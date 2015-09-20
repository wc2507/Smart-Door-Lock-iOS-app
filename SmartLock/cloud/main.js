
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});
Parse.Cloud.define("cal",function(request,response){
    var jssha = require('cloud/jssha256.js')
    var query = new Parse.Query("HAHA")
    query.equalTo("ID",request.params.ID)
    query.find({
        success: function(results){
            var msg = results[0].get('Msg')
            var key = results[0].get('key')
            var msg2 = 'Hi how are you'
            var key2 = 'hihihihddwdwdw'
            var signiture1 = jssha.HMAC_SHA256_MAC(msg,key)
            var signiture2 = jssha.HMAC_SHA256_MAC(msg2,key2)
            response.success(signiture1+' '+signiture2)
        },
        error: function(){
            response.error("failed")
        }
    })
     
});
