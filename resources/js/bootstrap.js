/**
 * Axios HTTP Library Configuration
 *
 * This file configures axios as the global HTTP client for the application.
 * The configured instance is available as `window.axios` and includes:
 * - CSRF token from the meta tag (X-CSRF-TOKEN header)
 * - Credentials (cookies) sent with all requests
 * - XMLHttpRequest header for Laravel to detect AJAX requests
 *
 * IMPORTANT: In Vue components, always use `const axios = window.axios`
 * instead of `import axios from 'axios'`. Importing axios directly creates
 * a new instance WITHOUT the CSRF token configuration, causing 419 errors.
 *
 * Example usage in Vue components:
 * ```
 * <script setup>
 * const axios = window.axios;
 *
 * const fetchData = async () => {
 *     const response = await axios.get('/api/data');
 *     // ...
 * };
 * </script>
 * ```
 */

import axios from 'axios';
window.axios = axios;

// Required for Laravel to identify this as an AJAX request
window.axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

// Required to send session cookies with requests (needed for CSRF verification)
window.axios.defaults.withCredentials = true;

// Configure axios to use the XSRF-TOKEN cookie for CSRF protection.
// Laravel automatically sets this cookie on each response and Axios will
// read it for every request and send it as the X-XSRF-TOKEN header.
//
// This avoids relying on a single, potentially stale value from the
// <meta name="csrf-token"> tag and keeps the header in sync with the
// session's CSRF token, preventing intermittent 419 errors on first
// form submissions after navigation.
window.axios.defaults.xsrfCookieName = 'XSRF-TOKEN';
window.axios.defaults.xsrfHeaderName = 'X-XSRF-TOKEN';

/**
 * Echo exposes an expressive API for subscribing to channels and listening
 * for events that are broadcast by Laravel. Echo and event broadcasting
 * allows your team to easily build robust real-time web applications.
 */

// import Echo from 'laravel-echo';

// import Pusher from 'pusher-js';
// window.Pusher = Pusher;

// window.Echo = new Echo({
//     broadcaster: 'pusher',
//     key: import.meta.env.VITE_PUSHER_APP_KEY,
//     cluster: import.meta.env.VITE_PUSHER_APP_CLUSTER ?? 'mt1',
//     wsHost: import.meta.env.VITE_PUSHER_HOST ? import.meta.env.VITE_PUSHER_HOST : `ws-${import.meta.env.VITE_PUSHER_APP_CLUSTER}.pusher.com`,
//     wsPort: import.meta.env.VITE_PUSHER_PORT ?? 80,
//     wssPort: import.meta.env.VITE_PUSHER_PORT ?? 443,
//     forceTLS: (import.meta.env.VITE_PUSHER_SCHEME ?? 'https') === 'https',
//     enabledTransports: ['ws', 'wss'],
// });
