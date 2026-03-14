phpToro.http = {
    get: function(url, options) {
        return phpToro.nativeCall('http', 'request', Object.assign({ url: url, method: 'GET' }, options || {}));
    },
    post: function(url, body, options) {
        return phpToro.nativeCall('http', 'request', Object.assign({ url: url, method: 'POST', body: body }, options || {}));
    },
    put: function(url, body, options) {
        return phpToro.nativeCall('http', 'request', Object.assign({ url: url, method: 'PUT', body: body }, options || {}));
    },
    delete: function(url, options) {
        return phpToro.nativeCall('http', 'request', Object.assign({ url: url, method: 'DELETE' }, options || {}));
    },
    request: function(options) {
        return phpToro.nativeCall('http', 'request', options);
    }
};
