window.DEPLOYCONFIG = {
    cookieDomain: '.{{ domain.domain }}',
    apiUrl: '{{ "https" if other.tls.tlsEnabled else "http"}}://{{ domain.subDomain.consoleApi }}.{{ domain.domain }}',
    wsUrl: '{{ "wss" if other.tls.tlsEnabled else "ws"}}://{{ domain.subDomain.websocket }}.{{ domain.domain }}',
    innerAppDisabled: 1,
    innerAppLogin: '{{ "https" if other.tls.tlsEnabled else "http"}}://auth.{{ domain.domain }}/redirectpage/login',
    innerAppRegister: '{{ "https" if other.tls.tlsEnabled else "http"}}://auth.{{ domain.domain }}/redirectpage/register',
    innerAppProfile: '{{ "https" if other.tls.tlsEnabled else "http"}}://auth.{{ domain.domain }}/redirectpage/profile',
    innerAppCreateworkspace: '{{ "https" if other.tls.tlsEnabled else "http"}}://auth.{{ domain.domain }}/redirectpage/createworkspace',
    staticFileUrl: '{{ "https" if other.tls.tlsEnabled else "http"}}://{{ domain.subDomain.staticResource }}.{{ domain.domain }}',
    staticDatakit: 'https://static.dataflux.cn',
    cloudDatawayUrl: ''
};
