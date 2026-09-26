// Godot's web export always names its build "index.*". Files here are only served
// compressed when tools/prepare-web-deploy.mjs decided they needed it (i.e. an
// "<path>.br" asset exists); otherwise the request falls through to plain assets.
const COMPRESSIBLE_CONTENT_TYPES = {
  '/index.wasm': 'application/wasm',
  '/index.pck': 'application/octet-stream',
};

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const contentType = COMPRESSIBLE_CONTENT_TYPES[url.pathname];

    if (contentType) {
      const encodedUrl = new URL(request.url);
      encodedUrl.pathname = `${url.pathname}.br`;
      const res = await env.ASSETS.fetch(new Request(encodedUrl, request));

      if (res.status === 304) {
        return res;
      }
      if (res.ok) {
        const headers = new Headers({
          'content-type': contentType,
          'content-encoding': 'br',
          'cache-control': 'public, max-age=0, must-revalidate',
          'vary': 'accept-encoding',
        });
        const etag = res.headers.get('etag');
        if (etag) {
          headers.set('etag', etag);
        }
        return new Response(res.body, { status: 200, headers, encodeBody: 'manual' });
      }
    }

    return env.ASSETS.fetch(request);
  },
};
