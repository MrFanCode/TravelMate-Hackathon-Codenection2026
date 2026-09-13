/** @type {import('next').NextConfig} */
module.exports = {
  // Produces a minimal, self-contained build in .next/standalone —
  // this is what makes the Docker image small and fast to start,
  // instead of shipping the whole node_modules folder.
  output: "standalone",
};
