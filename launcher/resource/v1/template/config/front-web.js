window.DEPLOYCONFIG = {
    cookieDomain: '.{{ domain.domain }}',
    apiUrl: "https://{{ domain.subDomain.consoleApi }}.{{ domain.domain }}",
    wsUrl: "wss://{{ domain.subDomain.websocket }}.{{ domain.domain }}",
    innerAppDisabled: 1,
    innerAppLogin: 'https://auth.{{ domain.domain }}/redirectpage/login',
    innerAppRegister: 'https://auth.{{ domain.domain }}/redirectpage/register',
    innerAppProfile: 'https://auth.{{ domain.domain }}/redirectpage/profile',
    innerAppCreateworkspace: 'https://auth.{{ domain.domain }}/redirectpage/createworkspace',
    staticFileUrl: "https://{{ domain.subDomain.staticResource }}.{{ domain.domain }}",
    staticDatakit: 'https://static.dataflux.cn',
    cloudDatawayUrl: ''
};
