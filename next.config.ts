import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: 'standalone', // 添加这行支持Docker部署
  /* config options here */
};

export default nextConfig;
