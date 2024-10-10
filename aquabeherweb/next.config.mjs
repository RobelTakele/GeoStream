/** @type {import('next').NextConfig} */
const nextConfig = {
  assetPrefix: process.env.NODE_ENV === 'production' ? '/GeoStream/' : '',
  trailingSlash: true,
  output: 'export',
  images: {
    unoptimized: true, // Static export requires unoptimized images
  },
};

export default nextConfig;
