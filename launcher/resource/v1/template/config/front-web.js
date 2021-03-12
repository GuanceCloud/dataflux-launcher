window.DEPLOYCONFIG = {
    cookieDomain: '.{{ domain.domain }}',
    apiUrl: '{{ "http" if other.tls.tlsDisabled else "https"}}://{{ domain.subDomain.consoleApi }}.{{ domain.domain }}',
    wsUrl: '{{ "ws" if other.tls.tlsDisabled else "wss"}}://{{ domain.subDomain.websocket }}.{{ domain.domain }}',
    innerAppDisabled: 1,
    innerAppLogin: '{{ "http" if other.tls.tlsDisabled else "https"}}://auth.{{ domain.domain }}/redirectpage/login',
    innerAppRegister: '{{ "http" if other.tls.tlsDisabled else "https"}}://auth.{{ domain.domain }}/redirectpage/register',
    innerAppProfile: '{{ "http" if other.tls.tlsDisabled else "https"}}://auth.{{ domain.domain }}/redirectpage/profile',
    innerAppCreateworkspace: '{{ "http" if other.tls.tlsDisabled else "https"}}://auth.{{ domain.domain }}/redirectpage/createworkspace',
    staticFileUrl: '{{ "http" if other.tls.tlsDisabled else "https"}}://{{ domain.subDomain.staticResource }}.{{ domain.domain }}',
    staticDatakit: 'https://static.dataflux.cn',
    cloudDatawayUrl: '',
    showHelp: 1,
    rumEnable: 0,
    rumDatakitUrl: "",
    rumApplicationId: "",
    rumJsUrl: "https://static.dataflux.cn/js-sdk/dataflux-rum.js",
    rumDataEnv: 'prod'
};
