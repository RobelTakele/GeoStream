/** @type {import('next').NextConfig} */
const nextConfig = {
    assetPrefix: process.env.NODE_ENV === 'production' ? '/RobelTakele/GeoStream/' : '',
    trailingSlash: true,
    output: 'export',
    images: {
      unoptimized: true,
    },
  };
  
  export default nextConfig;
  