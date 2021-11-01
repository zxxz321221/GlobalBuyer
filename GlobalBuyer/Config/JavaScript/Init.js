(function () {
    if (window.top !== window) {
        return;
    }

    var loadScript = function(scriptUrl, callback) {
        var elem, bl,
            // 防止在ie9中，callback执行两次
            isExecuted = false;

        if (scriptUrl == null) {
            return String(fn);
        }
        elem = document.createElement('script');
        if ( typeof(callback) === 'function' )  {
            bl = true;
        }

        // for ie
        function handle(){
            var status = elem.readyState;
            if (status === 'loaded' || status === 'complete') {
                if (bl && !isExecuted) {
                    callback();
                    isExecuted = true;
                }
                elem.onreadystatechange = null;
            }
        }
        elem.onreadystatechange = handle;

        // for 非ie
        if (bl && !isExecuted) {
            elem.onload = callback;
            isExecuted = true;
        }

        elem.src = scriptUrl;
        document.getElementsByTagName('head')[0].appendChild(elem);
    } 

    loadScript('//buy.dayanghang.net/inject/m-common.js', function(){
        console.log('DYH load over');
    });

} ());
