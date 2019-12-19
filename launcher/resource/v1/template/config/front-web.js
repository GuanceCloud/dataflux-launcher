window.DEPLOYCONFIG = {
    cookieDomain: '.{{ other.domain }}',
    apiUrl: "https://{{'deploy-' if __common__.debug}}console-api.{{ other.domain }}",
    wsUrl: "wss://{{'deploy-' if __common__.debug}}ws.{{ other.domain }}",
    innerAppDisabled: 1,
    innerAppLogin: 'https://auth.{{ other.domain }}/redirectpage/login',
    innerAppRegister: 'https://auth.{{ other.domain }}/redirectpage/register',
    innerAppProfile: 'https://auth.{{ other.domain }}/redirectpage/profile',
    innerAppCreateworkspace: 'https://auth.{{ other.domain }}/redirectpage/createworkspace',
};
