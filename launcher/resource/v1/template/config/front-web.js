window.DEPLOYCONFIG = {
    cookieDomain: '.{{ domain.domain }}',
    apiUrl: "https://{{'deploy-' if __common__.debug}}{{ domain.subDomain.consoleApi }}.{{ domain.domain }}",
    wsUrl: "wss://{{'deploy-' if __common__.debug}}{{ domain.subDomain.websocket }}.{{ domain.domain }}",
    innerAppDisabled: 1,
    innerAppLogin: 'https://auth.{{ domain.domain }}/redirectpage/login',
    innerAppRegister: 'https://auth.{{ domain.domain }}/redirectpage/register',
    innerAppProfile: 'https://auth.{{ domain.domain }}/redirectpage/profile',
    innerAppCreateworkspace: 'https://auth.{{ domain.domain }}/redirectpage/createworkspace',
    cloudDatawayUrl: ''
};
